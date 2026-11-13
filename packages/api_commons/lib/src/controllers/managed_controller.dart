import 'dart:async';
import 'dart:convert';

import 'package:butter_commons/butter_commons.dart';
import 'package:conduit_common/conduit_common.dart';
import 'package:conduit_core/conduit_core.dart';
import 'package:conduit_open_api/v3.dart';

import '../../butter_api_commons.dart';
import '../utils/is_managed_entity.dart';

/// A [Controller] that implements basic CRUD operations for a [ManagedObject].
///
/// Instances of this class map a REST API call
/// directly to a database [Query]. For example, this [Controller] handles an HTTP PUT request by executing an update [Query]; the path variable in the request
/// indicates the value of the primary key for the updated row and the HTTP request body are the values updated.
///
/// When routing to a [ManagedObjectController], you must provide the following route pattern, where <name> can be any string:
///
///       router.route('/<name>/[:id]')
///
/// You may optionally use the static method [ManagedObjectController.routePattern] to create this string for you.
///
/// The mapping for HTTP request to action is as follows:
///
/// - GET /<name>/:id -> Fetch Object by ID
/// - PUT /<name>/:id -> Update Object by ID, HTTP Request Body contains update values.
/// - DELETE /<name>/:id -> Delete Object by ID
/// - POST /<name> -> Create new Object, HTTP Request Body contains update values.
/// - GET /<name> -> Fetch instances of Object
///
/// You may use this class without subclassing, but you may also subclass it to modify the executed [Query] prior to its execution, or modify the returned [Response] after the query has been completed.
///
/// The HTTP response body is encoded according to [responseContentType].
///
/// GET requests with no path parameter can take extra query parameters to modify the request. The following are the available query parameters:
///
/// - count (integer): restricts the number of objects fetched to count. By default, this is null, which means no restrictions.
/// - offset (integer): offsets the fetch by offset amount of objects. By default, this is null, which means no offset.
/// - pageBy (string): indicates the key in which to page by. See [Query.pageBy] for more information on paging. If this value is passed as part of the query, either pageAfter or pagePrior must also be passed, but only one of those.
/// - pageAfter (string): indicates the page value and direction of the paging. pageBy must also be set. See [Query.pageBy] for more information.
/// - pagePrior (string): indicates the page value and direction of the paging. pageBy must also be set. See [Query.pageBy] for more information.
/// - sortBy (string): indicates the sort order. The syntax is 'sortBy=key,order' where key is a property of [InstanceType] and order is either 'asc' or 'desc'. You may specify multiple sortBy parameters.
class ManagedController<InstanceType extends ManagedObject>
    extends ResourceController {
  /// Creates an instance of a [ManagedObjectController].
  ManagedController(ManagedContext context) : super() {
    _context = context;
  }

  /// Creates a new [ManagedObjectController] without a static type.
  ///
  /// This method is used when generating instances of this type dynamically from runtime values,
  /// where the static type argument cannot be defined. Behaves just like the unnamed constructor.
  ///
  ManagedController.forEntity(this.entity, ManagedContext context) : super() {
    _context = context;
  }

  ManagedEntity? entity;
  ManagedContext? _context;
  Map<String, String> params = {};

  /// Returns a route pattern for using [ManagedObjectController]s.
  ///
  /// Returns the string '/$name/[:id]', to be used as a route pattern in a [Router] for instances of [ResourceController] and subclasses.
  static String routePattern(String name) => '/$name/[:id]';

  /// Executed prior to a fetch by ID query.
  ///
  /// You may modify the [query] prior to its execution in this method. The [query] will have a single matcher, where the [InstanceType]'s primary key
  /// is equal to the first path argument in the [Request]. You may also return a new [Query],
  /// but it must have the same [InstanceType] as this controller. If you return null from this method, no [Query] will be executed
  /// and [didNotFindObject] will immediately be called.
  FutureOr<Query<InstanceType>> willFindObjectWithQuery(
          Query<InstanceType> query) =>
      query;

  /// Executed after a fetch by ID query that found a matching instance.
  ///
  /// By default, returns a [Response.ok] with the encoded instance. The [object] is the fetched [InstanceType]. You may override this method
  /// to provide some other behavior.
  FutureOr<Response> didFindObject(
          InstanceType object, Map<String, dynamic> summary) =>
      Response.ok(object);

  /// Executed after a fetch by ID query that did not find a matching instance.
  ///
  /// By default, returns [Response.notFound]. You may override this method to provide some other behavior.
  FutureOr<Response> didNotFindObject() => Response.notFound();

  @Operation.get('id')
  Future<Response> getObject(
    @Bind.path('id') String id, {
    // Generic parameters
    //
    // Parameters that doesn't fall under the recognized purposes
    @Bind.query('params') List<String>? params,
  }) async {
    _loadParams(params, id: id);
    final query = Query<InstanceType>(_context!);
    final primaryKey = query.entity.primaryKey;
    final parsedIdentifier =
        _getIdentifierFromPath(id, query.entity.properties[primaryKey]);
    query.where((o) => o[primaryKey]).equalTo(parsedIdentifier);

    final q = await willFindObjectWithQuery(query);
    final result = await performFindObject(id, q);

    if (result != null) {
      return didFindObject(result, {});
    }

    return didNotFindObject();
  }

  /// Executed prior to an insert query being executed.
  ///
  /// You may modify the [query] prior to its execution in this method. You may also return a new [Query],
  /// but it must have the same type argument as this controller. If you return null from this method,
  /// no values will be inserted and [didInsertObject] will immediately be called with the value null.
  FutureOr<Query<InstanceType>> willInsertObjectWithQuery(
          Query<InstanceType> query) =>
      query;

  FutureOr<InstanceType> performInsert(Query<InstanceType> query) =>
      query.insert();

  /// Executed after an insert query is successful.
  ///
  /// By default, returns [Response.ok]. The [object] is the newly inserted [InstanceType]. You may override this method to provide some other behavior.
  FutureOr<Response> didInsertObject(InstanceType? object) =>
      Response.ok(object);

  @Operation.post()
  Future<Response> createObject({
    // Generic parameters
    //
    // Parameters that doesn't fall under the recognized purposes
    @Bind.query('params') List<String>? params,
  }) async {
    try {
      _loadParams(params);
      final result = await _context!.transaction((transaction) async {
        final query = Query<InstanceType>(transaction);
        final instance = query.entity.instanceOf() as InstanceType;
        logger.fine('ManagedController::createObject');
        logger.fine(request!.body.as());
        instance.readFromMap(request!.body.as());
        query.values = instance;

        final q = await willInsertObjectWithQuery(query);
        return performInsert(q);
      });

      return didInsertObject(result);
    } on Response {
      rethrow;
    } on RequestNotAllowedException catch (e, stacktrace) {
      logger.severe(e, e, stacktrace);
      rethrow;
    } on QueryException catch (e, stacktrace) {
      logger.severe(e, e, stacktrace);
      throw RequestNotAllowedException(e.message);
    } catch (e, stacktrace) {
      logger.severe(e, e, stacktrace);
    }

    throw RequestNotAllowedException.code(BaseErrorCode.unexpectedError);
  }

  /// Executed prior to a delete query being executed.
  ///
  /// You may modify the [query] prior to its execution in this method. You may also return a new [Query],
  /// but it must have the same type argument as this controller. If you return null from this method,
  /// no delete operation will be performed and [didNotFindObjectToDeleteWithID] will immediately be called with the value null.
  FutureOr<Query<InstanceType>> willDeleteObjectWithQuery(
          Query<InstanceType> query) =>
      query;

  /// Executed after an object was deleted.
  ///
  /// By default, returns [Response.ok] with no response body. You may override this method to provide some other behavior.
  FutureOr<Response> didDeleteObjectWithID(dynamic id) => Response.ok(null);

  FutureOr<int?> performDelete(String id, Query<InstanceType> query) =>
      query.delete();

  /// Executed when no object was deleted during a delete query.
  ///
  /// Defaults to return [Response.notFound]. You may override this method to provide some other behavior.
  FutureOr<Response> didNotFindObjectToDeleteWithID(dynamic id) =>
      throw RequestNotAllowedException.code(BaseErrorCode.objectNotFound,
          notFound: true);

  @Operation.delete('id')
  Future<Response> deleteObject(
    @Bind.path('id') String id, {
    // Generic parameters
    //
    // Parameters that doesn't fall under the recognized purposes
    @Bind.query('params') List<String>? params,
  }) async {
    try {
      _loadParams(params, id: id);
      final result = await _context!.transaction((transaction) async {
        final query = Query<InstanceType>(transaction);
        final primaryKey = query.entity.primaryKey;
        final parsedIdentifier =
            _getIdentifierFromPath(id, query.entity.properties[primaryKey]);
        query.where((o) => o[primaryKey]).equalTo(parsedIdentifier);

        final q = await willDeleteObjectWithQuery(query);

        return performDelete(id, q);
      });

      if (result == 0) {
        return didNotFindObjectToDeleteWithID(id);
      } else {
        return didDeleteObjectWithID(id);
      }
    } on Response {
      rethrow;
    } on RequestNotAllowedException catch (e, stacktrace) {
      logger.severe(e, e, stacktrace);
      rethrow;
    } on QueryException catch (e, stacktrace) {
      logger.severe(e, e, stacktrace);
      throw RequestNotAllowedException(e.message);
    } catch (e, stacktrace) {
      logger.severe(e, e, stacktrace);
    }

    throw RequestNotAllowedException.code(BaseErrorCode.unexpectedError);
  }

  /// Executed prior to a update query being executed.
  ///
  /// You may modify the [query] prior to its execution in this method. You may also return a new [Query],
  /// but it must have the same type argument as this controller. If you return null from this method,
  /// no values will be inserted and [didNotFindObjectToUpdateWithID] will immediately be called with the value null.
  FutureOr<Query<InstanceType>> willUpdateObjectWithQuery(
          Query<InstanceType> query) =>
      query;

  FutureOr<InstanceType?> performUpdate(String id, Query<InstanceType> query) =>
      query.updateOne();

  /// Executed after an object was updated.
  ///
  /// By default, returns [Response.ok] with the encoded, updated object. You may override this method to provide some other behavior.
  FutureOr<Response> didUpdateObject(InstanceType object) =>
      Response.ok(object);

  /// Executed after an object not found during an update query.
  ///
  /// By default, returns [Response.notFound]. You may override this method to provide some other behavior.
  FutureOr<Response> didNotFindObjectToUpdateWithID(dynamic id) =>
      Response.notFound();

  @Operation.put('id')
  Future<Response> updateObject(
    @Bind.path('id') String id, {
    // Generic parameters
    //
    // Parameters that doesn't fall under the recognized purposes
    @Bind.query('params') List<String>? params,
  }) async {

    late final Map<String, dynamic> body;
    try {
      _loadParams(params, id: id);
      try {
        body = await request!.body.as();
      } catch (e) {
        body = await request!.body.decode();
      }

      final result = await _context!.transaction((transcation) async {
        final query = Query<InstanceType>(transcation);
        final primaryKey = query.entity.primaryKey;
        final parsedIdentifier =
            _getIdentifierFromPath(id, query.entity.properties[primaryKey]);
        query.where((o) => o[primaryKey]).equalTo(parsedIdentifier);

        final instance = query.entity.instanceOf() as InstanceType;
        instance.readFromMap(body);
        query.values = instance;

        final q = await willUpdateObjectWithQuery(query);

        return performUpdate(id, q);
      });

      if (result == null) {
        return didNotFindObjectToUpdateWithID(id);
      } else {
        return didUpdateObject(result);
      }
    } on Response {
      logger.fine(request);
      logger.fine(body);
      rethrow;
    } on RequestNotAllowedException catch (e, stacktrace) {
      logger.fine(request);
      logger.fine(body);
      logger.severe(e, e, stacktrace);
      rethrow;
    } on QueryException catch (e, stacktrace) {
      logger.fine(request);
      logger.fine(body);
      logger.severe(e, e, stacktrace);
      throw RequestNotAllowedException(e.message);
    } catch (e, stacktrace) {
      logger.fine(request);
      logger.fine(body);
      logger.severe(e, e, stacktrace);
    }

    throw RequestNotAllowedException.code(BaseErrorCode.unexpectedError);
  }

  /// Executed prior to a fetch query being executed.
  ///
  /// You may modify the [query] prior to its execution in this method. You may also return a new [Query],
  /// but it must have the same type argument as this controller. If you return null from this method,
  /// no objects will be fetched and [didFindObjects] will immediately be called with the value null.
  FutureOr<Query<InstanceType>> willFindObjectsWithQuery(
          Query<InstanceType> query,
          {List<String>? searchBy}) =>
      query;

  FutureOr<InstanceType?> performFindObject(
          String id, Query<InstanceType> query) =>
      query.fetchOne();

  FutureOr<List<InstanceType>?> performFindObjects(Query<InstanceType> query,
          {List<String>? searchBy}) =>
      query.fetch();

  // Determine total number records
  FutureOr<int?> performFindCount(Query<InstanceType> query) async {
    query.offset = 0;
    query.fetchLimit = 0;
    return ReducerQuery(query).count();
  }

  /// Executed after a fetch query is executed.
  ///
  /// This is used to perform reducer operations on the current query
  ///
  FutureOr<Map<String, dynamic>> processFoundObjectsWithQuery(
          List<InstanceType> records, Query<InstanceType> query) =>
      {};

  /// Executed after a list of objects has been fetched.
  ///
  /// By default, returns [Response.ok] with the encoded list of founds objects (which may be the empty list).
  FutureOr<Response> didFindObjects(List<InstanceType> objects, int? total,
          Map<String, dynamic> summary) =>
      Response.ok(objects);

  @Operation.get()
  Future<Response> getObjects({
    /// Limits the number of objects returned.
    @Bind.query('count') int count = 10,

    /// An integer offset into an ordered list of objects.
    ///
    /// Use with count.
    ///
    /// See pageBy for an alternative form of offsetting.
    @Bind.query('offset') int offset = 0,

    /// The property of this object to page by.
    ///
    /// Must be a key in the object type being fetched. Must
    /// provide either pageAfter or pagePrior. Use with count.
    @Bind.query('pageBy') String? pageBy,

    /// A value-based offset into an ordered list of objects.
    ///
    /// Objects are returned if their
    /// value for the property named by pageBy is greater than
    /// the value of pageAfter. Must provide pageBy, and the type
    /// of the property designated by pageBy must be the same as pageAfter.
    @Bind.query('pageAfter') String? pageAfter,

    /// A value-based offset into an ordered list of objects.
    ///
    /// Objects are returned if their
    /// value for the property named by pageBy is less than
    /// the value of pageAfter. Must provide pageBy, and the type
    /// of the property designated by pageBy must be the same as pageAfter.
    @Bind.query('pagePrior') String? pagePrior,

    /// Designates a sorting strategy for the returned objects.
    ///
    /// This value must take the form 'name,asc' or 'name,desc', where name
    /// is the property of the returned objects to sort on.
    @Bind.query('sortBy') List<String>? sortBy,

    /// Used to search values on the specified fields
    ///
    /// This value must take the form 'name,value', where name
    /// is the property of the returned objects to search on.
    @Bind.query('searchBy') List<String>? searchBy,

    // Generic parameters
    //
    // Parameters that doesn't fall under the recognized purposes
    @Bind.query('params') List<String>? params,
  }) async {
    try {
      _loadParams(params);
      final query = Query<InstanceType>(_context!);
      query.fetchLimit = count;
      query.offset = offset;

      if (pageBy != null) {
        QuerySortOrder direction;
        String pageValue;
        if (pageAfter != null) {
          direction = QuerySortOrder.ascending;
          pageValue = pageAfter;
        } else if (pagePrior != null) {
          direction = QuerySortOrder.descending;
          pageValue = pagePrior;
        } else {
          return Response.badRequest(body: {
            'error':
                'missing required parameter "pageAfter" or "pagePrior" when "pageBy" is given'
          });
        }

        final pageByProperty = query.entity.properties[pageBy];
        if (pageByProperty == null) {
          throw Response.badRequest(
              body: {'error': 'cannot page by "$pageBy"'});
        }

        final parsed = _parseValueForProperty(pageValue, pageByProperty);
        query.pageBy((t) => t[pageBy], direction,
            boundingValue: parsed == 'null' ? null : parsed);
      }

      if (sortBy != null) {
        for (final sort in sortBy) {
          final split = sort.split(',').map((str) => str.trim()).toList();
          if (split.length != 2) {
            throw Response.badRequest(body: {
              'error':
                  'invalid "sortBy" format. syntax: "name,asc" or "name,desc".'
            });
          }
          if (query.entity.properties[split.first] == null) {
            throw Response.badRequest(
                body: {'error': 'cannot sort by "$sortBy"'});
          }
          if (split.last != 'asc' && split.last != 'desc') {
            throw Response.badRequest(body: {
              'error':
                  'invalid "sortBy" format. syntax: "name,asc" or "name,desc".'
            });
          }
          final sortOrder = split.last == 'asc'
              ? QuerySortOrder.ascending
              : QuerySortOrder.descending;
          query.sortBy((t) => t[split.first], sortOrder);
        }
      }

      if (searchBy != null && searchBy.isNotEmpty) {
        var or = '';
        final exp = StringBuffer();
        final Map<String, dynamic> values = {};
        for (final s in searchBy) {
          final search = Uri.decodeComponent(s);
          logger.fine(search);
          final searchMap = jsonDecode(search);
          var e = searchMap['exp'].toString();
          final field = e.split(' ')[0];
          if (field.startsWith('___') && field.endsWith('___')) {
            logger.fine(field);
            final values = searchMap['values'] as Map<String, dynamic>;
            values.forEach((key, value) {
              logger.fine(value);
              if (value is num || value is bool) {
                e = e.replaceAll('@$key', value.toString());
              } else {
                e = e.replaceAll('@$key', '\'${value.toString()}\'');
              }
            });

            this.params[field] = e;
            continue;
          }

          exp.write('$exp$or${searchMap['exp']}');
          if (searchMap['values'] != null) {
            values.addAll(searchMap['values'] as Map<String, dynamic>);
          }

          or = ' OR ';
        }

        query.predicate = QueryPredicate(exp.toString(), values);
      }

      final q = await willFindObjectsWithQuery(query, searchBy: searchBy);
      final results = await performFindObjects(q, searchBy: searchBy) ?? [];

      final total = await performFindCount(query);
      final summary = await processFoundObjectsWithQuery(results, query);

      return didFindObjects(results, total, summary);
    } on Response {
      rethrow;
    } on RequestNotAllowedException catch (e, stacktrace) {
      logger.severe(e, e, stacktrace);
      rethrow;
    } on QueryException catch (e, stacktrace) {
      logger.severe(e, e, stacktrace);
      throw RequestNotAllowedException(e.message);
    } catch (e, stacktrace) {
      logger.severe(e, e, stacktrace);
    }

    throw RequestNotAllowedException.code(BaseErrorCode.unexpectedError);
  }

  dynamic castValue(String type, String value) {
    switch (type) {
      case 'ManagedPropertyType.boolean':
        return value.trim().toLowerCase() == 'true';
      case 'ManagedPropertyType.integer':
      case 'ManagedPropertyType.bigInteger':
        return int.parse(value);
      case 'ManagedPropertyType.doublePrecision':
        return double.parse(value);
      case 'ManagedPropertyType.datetime':
        return DateTime.parse(value);
      default:
        return value;
    }
  }

  @override
  APIRequestBody? documentOperationRequestBody(
      APIDocumentContext context, Operation? operation) {
    if (operation!.method == 'POST' || operation.method == 'PUT') {
      return APIRequestBody.schema(
          context.schema.getObjectWithType(InstanceType),
          contentTypes: ['application/json'],
          isRequired: true);
    }

    return null;
  }

  @override
  Map<String, APIResponse> documentOperationResponses(
      APIDocumentContext context, Operation operation) {
    switch (operation.method) {
      case 'GET':
        if (operation.pathVariables.isEmpty) {
          return {
            '200': APIResponse.schema(
                'Returns a list of objects.',
                APISchemaObject.array(
                    ofSchema: context.schema.getObjectWithType(InstanceType))),
            '400': APIResponse.schema('Invalid request.',
                APISchemaObject.object({'error': APISchemaObject.string()}))
          };
        }

        return {
          '200': APIResponse.schema('Returns a single object.',
              context.schema.getObjectWithType(InstanceType)),
          '404': APIResponse('No object found.')
        };
      case 'PUT':
        return {
          '200': APIResponse.schema('Returns updated object.',
              context.schema.getObjectWithType(InstanceType)),
          '404': APIResponse('No object found.'),
          '400': APIResponse.schema('Invalid request.',
              APISchemaObject.object({'error': APISchemaObject.string()})),
          '409': APIResponse.schema('Object already exists',
              APISchemaObject.object({'error': APISchemaObject.string()})),
        };
      case 'POST':
        return {
          '200': APIResponse.schema('Returns created object.',
              context.schema.getObjectWithType(InstanceType)),
          '400': APIResponse.schema('Invalid request.',
              APISchemaObject.object({'error': APISchemaObject.string()})),
          '409': APIResponse.schema('Object already exists',
              APISchemaObject.object({'error': APISchemaObject.string()}))
        };
      case 'DELETE':
        return {
          '200': APIResponse('Object successfully deleted.'),
          '404': APIResponse('No object found.'),
        };
    }

    return {};
  }

  @override
  Map<String, APIOperation> documentOperations(
      APIDocumentContext context, String route, APIPath path) {
    final ops = super.documentOperations(context, route, path);

    final query = Query<InstanceType>(_context!);
    final entityName = query.entity.name;

    if (path.parameters
        .where((p) => p?.location == APIParameterLocation.path)
        .isEmpty) {
      ops['get']!.id = 'get${entityName}s';
      ops['post']!.id = 'create$entityName';
    } else {
      ops['get']!.id = 'get$entityName';
      ops['put']!.id = 'update$entityName';
      ops['delete']!.id = 'delete$entityName';
    }

    return ops;
  }

  dynamic _getIdentifierFromPath(
          String value, ManagedPropertyDescription? desc) =>
      _parseValueForProperty(value, desc, onError: Response.notFound());

  dynamic _parseValueForProperty(String value, ManagedPropertyDescription? desc,
      {Response? onError}) {
    if (value == 'null') {
      return null;
    }

    try {
      switch (desc?.type?.kind) {
        case ManagedPropertyType.string:
          return value;
        case ManagedPropertyType.bigInteger:
          return int.parse(value);
        case ManagedPropertyType.integer:
          return int.parse(value);
        case ManagedPropertyType.datetime:
          return DateTime.parse(value);
        case ManagedPropertyType.doublePrecision:
          return double.parse(value);
        case ManagedPropertyType.boolean:
          return value == 'true';
        case ManagedPropertyType.list:
        case ManagedPropertyType.map:
        case ManagedPropertyType.document:
        default:
          return null;
      }
    } on FormatException {
      throw onError ?? Response.badRequest();
    }
  }

  void _loadParams(List<String>? params, {String? id}) {
    logger.fine('ManagedController::_loadParams');
    this.params = {};
    if (id != null) {
      this.params['id'] = id;
    }

    for (final element in params ?? <String>[]) {
      final frags = element.split(':');
      if (frags.length >= 2) {
        final firstSplitter = element.indexOf(':');
        this.params[frags[0]] = element.substring(firstSplitter + 1);
      } else {
        this.params[element] = true.toString();
      }
    }

    logger.fine(this.params);
  }

  @override
  void documentComponents(APIDocumentContext context) {
    final parentEntity = instantiate(InstanceType).entity as ManagedEntity;
    final entities = <String, ManagedObject>{};
    final specialProps = <String>[];
    logger.fine('[${parentEntity.name}]');
    for (final prop in parentEntity.properties.keys) {
      final dynamic e = parentEntity.properties[prop];
      final p = prop.toString();
      logger.fine('$p => ${e.declaredType.toString()}');
      if (isManagedEntity(e)) {
        entities[p] = instantiate(e.declaredType as Type) as ManagedObject;
      } else if (e.declaredType.toString() == 'Map<String, dynamic>') {
        specialProps.add(p);
      }
    }

    documentManagedObjects(
      context,
      parentEntity: parentEntity,
      entities: entities,
      specialProps: specialProps,
    );
  }

  void documentManagedObjects(
    APIDocumentContext context, {
    required ManagedEntity parentEntity,
    Map<String, ManagedObject> entities = const {},
    List<String> specialProps = const [],
  }) {
    final schema = parentEntity.document(context);
    for (final propName in entities.keys) {
      final entity = entities[propName];
      schema.properties?[propName] = entity!.documentSchema(context)
        ..referenceURI = Uri(
            path:
                '/components/schemas/${entity.entity.instanceType.toString()}');
    }

    for (final propName in specialProps) {
      schema.properties?[propName]?.additionalPropertySchema?.type =
          APIType.object;
    }

    context.schema.register(parentEntity.instanceType.toString(), schema,
        representation: parentEntity.instanceType);

    super.documentComponents(context);
  }
}
