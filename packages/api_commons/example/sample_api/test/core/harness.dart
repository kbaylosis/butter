// ignore_for_file: avoid_print

import 'package:butter_api_commons/butter_api_commons.dart';
import 'package:conduit_core/conduit_core.dart';
import 'package:conduit_test/conduit_test.dart';
import 'package:faker/faker.dart';
import 'package:sample_api/app_config.dart';
import 'package:sample_api/sample_api.dart';
import 'package:sample_api/user.dart';

import 'basic_test_harness.dart';

class Harness extends BasicTestHarness<TestChannel> {
  Map<String, dynamic>? _authToken;
  late Agent _basicAgent;
  late Agent _bearerAgent;
  late AppConfig _config;
  late String _prefix;
  bool _delayDone = false;

  @override
  Map<String, dynamic>? get authToken => _authToken;

  @override
  Agent get basicAgent => _basicAgent;

  @override
  Agent get bearerAgent => _bearerAgent;

  @override
  String get prefix => _prefix;

  @override
  ManagedContext? get context => channel!.context;

  @override
  AuthServer? get authServer => channel!.authServer;

  @override
  Future onSetUp() async {
    await resetData();

    if (!_delayDone) {
      _delayDone = true;
      await Future.delayed(const Duration(seconds: 10));
    }

    _config = AppConfig('config.src.yaml');
    _prefix = _config.api!;

    _basicAgent = Agent(application)
      ..setBasicAuthorization(_config.apiKey!, _config.apiSecret!);
    _basicAgent.headers.addAll({
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
    });

    _bearerAgent = await addClient(_config.apiKey!, secret: _config.apiSecret);
    _bearerAgent.headers.addAll({
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
    });
  }

  @override
  Future onTearDown() async {}

  @override
  Future<User?> register(User user) async {
    final respUser = await (basicAgent.post(
      '$prefix/users/registry',
      body: user.asMap()
        ..addAll({
          'password': user.password,
        }),
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      },
    ) as FutureOr<TestResponse>);

    if (respUser.statusCode != 200) {
      throw 'Unable to successfully register the user';
    }

    final u = User()..readFromMap(respUser.body.as());
    print('User:: ${u.asMap()}');
    return u;
  }

  @override
  Future<bool> grant(User user) async {
    try {
      final req = basicAgent.request('$prefix/auth/token')
        ..contentType = ContentType('application', 'x-www-form-urlencoded')
        ..body = {
          'username': user.email,
          'password': user.password,
          'grant_type': 'password',
        };

      final resp = await req.post();
      if (resp.statusCode != 200) {
        throw 'Grant request unsuccessful';
      }

      _authToken = await resp.body.decode<Map<String, dynamic>>();
      _bearerAgent.bearerAuthorization = _authToken!['access_token'].toString();
    } catch (e) {
      return false;
    }

    return true;
  }

  @override
  Future<User?> registerAndLogin(User user, {bool enable = false}) async {
    try {
      final newUser = await register(user);
      if (newUser == null) {
        throw 'Unable to successfully register the user';
      }

      if (enable) {
        //
        // Enable the user
        //
        await bearerAgent.put('$prefix/users/${newUser.id}', body: {
          'disabledOn': null,
        });
      }

      if (!await grant(user)) {
        throw 'Grant request unsuccessful';
      }

      return newUser;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User?> createAdmin() {
    final email = fakeEmail();
    final user = User()
      ..username = email
      ..password = faker.internet.password()
      ..email = email;

    return registerAndLogin(user);
  }

  @override
  Future<User?> createUser() {
    final email = fakeEmail();
    final user = User()
      ..username = email
      ..password = faker.internet.password()
      ..email = email;

    return registerAndLogin(user, enable: true);
  }

  @override
  String fakeEmail() => [
        faker.internet.random.fromCharSet('abcdeefghijklmnopqrstuvwxyz', 8),
        faker.internet.domainName()
      ].join('@');

  @override
  void testLevels<T extends ManagedObject>(
    BasicTestHarness harness, {
    required String routeName,
    required Future<T> Function(User admin, User user) testData,
    required Future<Map<String, dynamic>> Function(
            User admin, User user, Map<String, dynamic> obj)
        updateData,
    required int Function(AccessLevel level, TestOp op) resultCode,
    Future<T> Function(User admin, User user, T obj)? mockInsertData,
  }) {
    group('/$routeName', () {
      test('Admin user', () async {
        final collectionUrl = '${harness.prefix}/$routeName';
        final admin = (await harness.createAdmin())!;

        //
        // Create object
        //
        final value = await testData(admin, admin);
        final result = expectResponse(
          await harness.bearerAgent.post(collectionUrl, body: value.asMap()),
          resultCode(AccessLevel.admin, TestOp.create),
        );
        final newObj = result!.statusCode == 200
            ? (instantiate(T)..readFromMap(result.body.as()))
            : await Query<T>(
                application!.channel.context,
                values:
                    await mockInsertData?.call(admin, admin, value) ?? value,
              ).insert();

        final recordUrl = '$collectionUrl/${newObj.id}';

        //
        // Read object
        //
        expectResponse(
          await harness.bearerAgent.get(recordUrl),
          resultCode(AccessLevel.admin, TestOp.findOne),
        );

        //
        // Read objects
        //
        expectResponse(
          await harness.bearerAgent.get(collectionUrl),
          resultCode(AccessLevel.admin, TestOp.find),
        );

        //
        // Update object
        //
        expectResponse(
          await harness.bearerAgent.put(recordUrl,
              body: await updateData(admin, admin, (newObj as T).asMap())),
          resultCode(AccessLevel.admin, TestOp.update),
        );

        //
        // Delete object
        //
        expectResponse(
          await harness.bearerAgent.delete(recordUrl),
          resultCode(AccessLevel.admin, TestOp.delete),
        );
      });

      test('Regular user', () async {
        final collectionUrl = '${harness.prefix}/$routeName';
        final admin = (await harness.createAdmin())!;
        final user = (await harness.createUser())!;

        //
        // Create object
        //
        final value = await testData(admin, user);
        final result = expectResponse(
          await harness.bearerAgent.post(collectionUrl, body: value.asMap()),
          resultCode(AccessLevel.regular, TestOp.create),
        );
        final newObj = result!.statusCode == 200
            ? (instantiate(T)..readFromMap(result.body.as()))
            : await Query<T>(
                application!.channel.context,
                values:
                    await mockInsertData?.call(admin, admin, value) ?? value,
              ).insert();

        final recordUrl = '$collectionUrl/${newObj.id}';

        //
        // Read object
        //
        expectResponse(
          await harness.bearerAgent.get(recordUrl),
          resultCode(AccessLevel.regular, TestOp.findOne),
        );

        //
        // Read objects
        //
        expectResponse(
          await harness.bearerAgent.get(collectionUrl),
          resultCode(AccessLevel.regular, TestOp.find),
        );

        //
        // Update object
        //
        expectResponse(
          await harness.bearerAgent.put(recordUrl,
              body: await updateData(admin, admin, (newObj as T).asMap())),
          resultCode(AccessLevel.regular, TestOp.update),
        );

        //
        // Delete object
        //
        expectResponse(
          await harness.bearerAgent.delete(recordUrl),
          resultCode(AccessLevel.regular, TestOp.delete),
        );
      });

      test('Guest user', () async {
        final collectionUrl = '${harness.prefix}/$routeName';
        final admin = (await harness.createAdmin())!;
        final user = (await harness.createUser())!;

        //
        // Create object
        //
        final expectedCode = resultCode(AccessLevel.guest, TestOp.create);
        final value = await testData(admin, user);
        final result = expectResponse(
          await harness.basicAgent.post(collectionUrl, body: value.asMap()),
          expectedCode,
        );

        final newObj = result!.statusCode == 200
            ? (instantiate(T)..readFromMap(result.body.as()))
            : await Query<T>(
                application!.channel.context,
                values:
                    await mockInsertData?.call(admin, admin, value) ?? value,
              ).insert();

        final recordUrl = '$collectionUrl/${newObj.id}';

        //
        // Read object
        //
        expectResponse(
          await harness.basicAgent.get(recordUrl),
          resultCode(AccessLevel.guest, TestOp.findOne),
        );

        //
        // Read objects
        //
        expectResponse(
          await harness.basicAgent.get(collectionUrl),
          resultCode(AccessLevel.guest, TestOp.find),
        );

        //
        // Update object
        //
        expectResponse(
          await harness.basicAgent.put(recordUrl,
              body: await updateData(admin, admin, (newObj as T).asMap())),
          resultCode(AccessLevel.guest, TestOp.update),
        );

        //
        // Delete object
        //
        expectResponse(
          await harness.basicAgent.delete(recordUrl),
          resultCode(AccessLevel.guest, TestOp.delete),
        );
      });
    });
  }

  @override
  U mockAudit<U extends Auditable>(U obj) => obj
    ..createdById = 1
    ..createdOn = DateTime.now()
    ..updatedById = 1
    ..updatedOn = DateTime.now();
}
