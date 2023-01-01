import 'package:conduit/conduit.dart';

import 'router_manager.dart';

abstract class ModuleChannel {
  late AuthServer _authServer;
  late ManagedContext _context;
  late List<RouterManager> _managers;
  late String _prefix;
  late Router _router;

  Future<void> init(Logger logger) async {
    logger.fine('Init controllers...');
    for (final m in managers) {
      logger.fine(m.routeName);
      await m.init(context);
    }
    logger.fine('Done!');
  }

  void build({
    required AuthServer authServer,
    required ManagedContext context,
    required Logger logger,
    required String prefix,
    required Router router,
    List<RouterManager> managers = const [],
  }) {
    _authServer = authServer;
    _context = context;
    _managers = managers;
    _prefix = prefix;
    _router = router;

    logger.fine('Build controllers...');
    for (final m in managers) {
      logger.fine(m.routeName);
      m.build(
        authServer: authServer,
        context: context,
        prefix: prefix,
        router: router,
      );
    }
    logger.fine('Done!');
  }

  AuthServer get authServer => _authServer;
  ManagedContext get context => _context;
  List<RouterManager> get managers => _managers;
  String get prefix => _prefix;
  Router get router => _router;
}
