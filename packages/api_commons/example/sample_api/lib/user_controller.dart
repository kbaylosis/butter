import 'package:butter_api_commons/butter_api_commons.dart';
import 'package:conduit_core/conduit_core.dart';

import 'user.dart';

class UserController extends BasicController<User> {
  UserController(ManagedContext context, AuthServer authServer)
      : super('users', context, authServer);
}
