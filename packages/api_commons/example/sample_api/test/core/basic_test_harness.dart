import 'package:butter_api_commons/butter_api_commons.dart';
import 'package:conduit_core/conduit_core.dart';
import 'package:conduit_test/conduit_test.dart';
import 'package:sample_api/user.dart';

export 'package:conduit/conduit.dart';
export 'package:test/test.dart';

abstract class BasicTestHarness<T extends ApplicationChannel>
    extends TestHarness<T> with TestHarnessAuthMixin<T>, TestHarnessORMMixin {
  Map<String, dynamic>? get authToken;
  Agent get basicAgent;
  Agent get bearerAgent;
  String get prefix;

  Future<bool> grant(User user);
  Future<User?> register(User user);
  Future<User?> registerAndLogin(User user, {bool enable = false});
  Future<User?> createAdmin();
  Future<User?> createUser();
  String fakeEmail();
  void testLevels<U extends ManagedObject>(
    BasicTestHarness harness, {
    required String routeName,
    required Future<U> Function(User admin, User user) testData,
    required Future<Map<String, dynamic>> Function(
            User admin, User user, Map<String, dynamic> obj)
        updateData,
    required int Function(AccessLevel level, TestOp op) resultCode,
    Future<U> Function(User admin, User user, U obj)? mockInsertData,
  });
  U mockAudit<U extends Auditable>(U obj);
}

enum AccessLevel {
  admin,
  regular,
  guest,
}

enum TestOp {
  create,
  findOne,
  find,
  update,
  delete,
}
