import 'package:butter_api_commons/butter_api_commons.dart';
import 'package:conduit_core/conduit_core.dart';

import 'user_controller.dart';

class Users extends ModuleChannel {
  @override
  void build({
    required AuthServer authServer,
    required ManagedContext context,
    required Logger logger,
    required String prefix,
    required Router router,
    List<RouterManager>? managers = const [],
  }) =>
      super.build(
        authServer: authServer,
        context: context,
        logger: logger,
        prefix: prefix,
        router: router,
        managers: [
          UserController(context, authServer),
        ],
      );
}
