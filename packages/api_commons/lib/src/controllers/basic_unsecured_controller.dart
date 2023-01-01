import 'package:conduit/conduit.dart';

import 'basic_controller.dart';

class BasicUnsecuredController<T extends ManagedObject>
    extends BasicController<T> {
  BasicUnsecuredController(
      String routeName, ManagedContext context, AuthServer authServer)
      : super(routeName, context, authServer);

  @override
  void build({
    required AuthServer authServer,
    required ManagedContext context,
    required String prefix,
    required Router router,
  }) {
    logger.fine('$prefix/$routeName/[:id]');
    router.route('$prefix/$routeName/[:id]').link(() => this);
  }
}
