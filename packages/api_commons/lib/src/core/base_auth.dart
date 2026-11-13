import 'package:conduit_core/conduit_core.dart';
import 'package:conduit_core/managed_auth.dart';

class AppAuth<T extends ManagedAuthResourceOwner>
    extends ManagedAuthDelegate<T> {
  AppAuth(ManagedContext? context) : super(context!);

  @override
  Future<T?> getResourceOwner(AuthServer server, String username) {
    final query = Query<T>(context)
      ..predicate = QueryPredicate(
        'email = @username OR mobile = @username',
        {
          'username': username,
        },
      )
      ..returningProperties(
          (t) => [t.id, t.hashedPassword, t.salt, t.username]);

    return query.fetchOne();
  }
}
