import 'dart:async';
import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:conduit_common/conduit_common.dart';
import 'package:conduit_open_api/v3.dart';

import 'user.dart';

/// [Controller] for issuing and refreshing OAuth 2.0 access tokens.
///
/// This controller issues and refreshes access tokens. Access tokens are issued for valid username and password (resource owner password grant)
/// or for an authorization code (authorization code grant) from a [AuthRedirectController].
///
/// See operation method [grant] for more details.
///
/// Usage:
///
///       router
///         .route("/auth/token")
///         .link(() => new BasicAuthController(authServer));
///
class UserAuthController extends ResourceController {
  /// Creates a new instance of an [UserAuthController].
  ///
  /// [authServer] is the required authorization server that grants tokens.
  UserAuthController(this.context, this.authServer) {
    acceptedContentTypes = [
      ContentType('application', 'x-www-form-urlencoded')
    ];
  }

  /// A reference to the [AuthServer] this controller uses to grant tokens.
  final AuthServer? authServer;
  final ManagedContext? context;

  /// Required basic authentication Authorization header containing client ID and secret for the authenticating client.
  ///
  /// Requests must contain the client ID and client secret in the authorization header,
  /// using the basic authentication scheme. If the client is a public client - i.e., no client secret -
  /// the client secret is omitted from the Authorization header.
  ///
  /// Example: com.stablekernel.public is a public client. The Authorization header should be constructed
  /// as so:
  ///
  ///         Authorization: Basic base64("com.stablekernel.public:")
  ///
  /// Notice the trailing colon indicates that the client secret is the empty string.
  @Bind.header(HttpHeaders.authorizationHeader)
  String? authHeader;

  final AuthorizationBasicParser _parser = const AuthorizationBasicParser();

  /// Creates or refreshes an authentication token.
  ///
  /// When grant_type is 'password', there must be username and password values.
  /// When grant_type is 'refresh_token', there must be a refresh_token value.
  /// When grant_type is 'authorization_code', there must be a authorization_code value.
  ///
  /// This endpoint requires client_id authentication. The Authorization header must
  /// include a valid Client ID and Secret in the Basic authorization scheme format.
  @Operation.post()
  Future<Response> grant(
      {@Bind.query('username') String? username,
      @Bind.query('password') String? password,
      @Bind.query('refresh_token') String? refreshToken,
      @Bind.query('code') String? authCode,
      @Bind.query('grant_type') String? grantType,
      @Bind.query('scope') String? scope}) async {
    logger.fine('BasicAuthController::grant');

    try {
      final query = Query<User>(context!)
        ..where((u) => u.username).equalTo(username);
      final user = await query.fetchOne();
      if (user == null || user.disabledOn != null) {
        throw 'User doesn\'t exist or it is disabled';
      }
    } catch (e) {
      logger.fine(e.toString());
      return Response.forbidden();
    }

    AuthBasicCredentials basicRecord;
    try {
      basicRecord = _parser.parse(authHeader);
    } on AuthorizationParserException catch (_) {
      return _responseForError(AuthRequestError.invalidClient);
    }

    try {
      final scopes = scope?.split(' ').map(AuthScope.new).toList();

      if (grantType == 'password') {
        logger.fine(username);
        final token = await authServer!.authenticate(
            username, password, basicRecord.username, basicRecord.password,
            requestedScopes: scopes);
        logger.fine(token.asMap());

        return UserAuthController.tokenResponse(token);
      } else if (grantType == 'refresh_token') {
        final token = await authServer!.refresh(
            refreshToken, basicRecord.username, basicRecord.password,
            requestedScopes: scopes);

        return UserAuthController.tokenResponse(token);
      } else if (grantType == 'authorization_code') {
        if (scope != null) {
          return _responseForError(AuthRequestError.invalidRequest);
        }

        final token = await authServer!
            .exchange(authCode, basicRecord.username, basicRecord.password);

        return UserAuthController.tokenResponse(token);
      } else if (grantType == null) {
        return _responseForError(AuthRequestError.invalidRequest);
      }
    } on FormatException {
      return _responseForError(AuthRequestError.invalidScope);
    } on AuthServerException catch (e) {
      return _responseForError(e.reason);
    }

    return _responseForError(AuthRequestError.unsupportedGrantType);
  }

  /// Transforms a [AuthToken] into a [Response] object with an RFC6749 compliant JSON token
  /// as the HTTP response body.
  static Response tokenResponse(AuthToken token) {
    return Response(
        HttpStatus.ok,
        {
          'Cache-Control': 'no-store',
          'Pragma': 'no-cache',
          'access-control-expose-headers': 'x-resource-owner',
          'x-resource-owner': token.resourceOwnerIdentifier
        },
        token.asMap());
  }

  @override
  void willSendResponse(Response response) {
    if (response.statusCode == 400) {
      // This post-processes the response in the case that duplicate parameters
      // were in the request, which violates oauth2 spec. It just adjusts the error message.
      // This could be hardened some.
      final body = response.body;
      if (body != null && body['error'] is String) {
        final errorMessage = body['error'] as String;
        if (errorMessage.startsWith('multiple values')) {
          response.body = {
            'error':
                AuthServerException.errorString(AuthRequestError.invalidRequest)
          };
        }
      }
    }
  }

  @override
  List<APIParameter?> documentOperationParameters(
      APIDocumentContext context, Operation? operation) {
    final parameters = super.documentOperationParameters(context, operation)!;
    parameters.removeWhere((p) => p!.name == HttpHeaders.authorizationHeader);
    return parameters;
  }

  @override
  APIRequestBody documentOperationRequestBody(
      APIDocumentContext context, Operation? operation) {
    final body = super.documentOperationRequestBody(context, operation)!;
    body.content!['application/x-www-form-urlencoded']!.schema!.isRequired = [
      'grant_type'
    ];
    body.content!['application/x-www-form-urlencoded']!.schema!
        .properties!['password']!.format = 'password';
    return body;
  }

  @override
  Map<String, APIOperation> documentOperations(
      APIDocumentContext context, String route, APIPath path) {
    final operations = super.documentOperations(context, route, path);

    operations.forEach((_, op) {
      op.security = [
        APISecurityRequirement({'oauth2-client-authentication': []})
      ];
    });

    final relativeUri = Uri(path: route.substring(1));
    authServer!.documentedAuthorizationCodeFlow.tokenURL = relativeUri;
    authServer!.documentedAuthorizationCodeFlow.refreshURL = relativeUri;

    authServer!.documentedPasswordFlow.tokenURL = relativeUri;
    authServer!.documentedPasswordFlow.refreshURL = relativeUri;

    return operations;
  }

  @override
  Map<String, APIResponse> documentOperationResponses(
      APIDocumentContext context, Operation operation) {
    return {
      '200': APIResponse.schema(
          'Successfully exchanged credentials for token',
          APISchemaObject.object({
            'access_token': APISchemaObject.string(),
            'token_type': APISchemaObject.string(),
            'expires_in': APISchemaObject.integer(),
            'refresh_token': APISchemaObject.string(),
            'scope': APISchemaObject.string()
          }),
          contentTypes: ['application/json']),
      '400': APIResponse.schema('Invalid credentials or missing parameters.',
          APISchemaObject.object({'error': APISchemaObject.string()}),
          contentTypes: ['application/json'])
    };
  }

  Response _responseForError(AuthRequestError error) {
    return Response.badRequest(
        body: {'error': AuthServerException.errorString(error)});
  }
}
