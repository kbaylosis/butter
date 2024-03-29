import 'package:butter_api_commons/butter_api_commons.dart';
import 'package:conduit_core/conduit_core.dart';

import 'app_config.dart';
import 'user.dart';
import 'user_auth_controller.dart';
import 'users.dart';

final moduleList = List<ModuleChannel>.unmodifiable([
  Users(),
]);

final serviceList = List<Service>.unmodifiable([]);

class TestChannel extends BaseChannel<AppConfig, User> {
  @override
  late AuthServer authServer;

  @override
  late ManagedContext context;

  @override
  void buildCustomRoutes(String prefix, Router router) {
    router
        .route('$prefix/auth/token')
        .link(() => UserAuthController(context, authServer));
  }

  @override
  Future<AppConfig> loadConfig() async =>
      AppConfig(options!.configurationFilePath!);

  @override
  List<ModuleChannel> get modules => moduleList;

  @override
  void serverInfo(VersionConfig version, BaseConfig config) {
    logger.info('');
    logger.info('************************');
    logger.info('');
    logger.info('Name: ${config.appName}');
    logger.info('Version: ${version.version}');
    logger.info('');
    logger.info('************************');
    logger.info('');
  }

  @override
  List<Service> get services => serviceList;
}
