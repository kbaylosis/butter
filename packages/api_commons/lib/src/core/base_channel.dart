import 'dart:io';

import 'package:collection/collection.dart';
import 'package:conduit/conduit.dart';
import 'package:conduit_core/managed_auth.dart';
import 'package:conduit_open_api/v3.dart';
import 'package:yaml/yaml.dart';

import '../utils/instantiate.dart';
import '../utils/log_utils.dart';
import 'base_auth.dart';
import 'base_config.dart';
import 'module_channel.dart';
import 'service.dart';
import 'version_config.dart';

abstract class BaseChannel<C extends BaseConfig,
    U extends ManagedAuthResourceOwner> extends ApplicationChannel {
  bool _spawned = false;
  late C config;

  //
  // Force the implementations to declare these so that the documentation engine
  // can pick it up
  //
  AuthServer get authServer;
  set authServer(AuthServer value);
  ManagedContext get context;
  set context(ManagedContext value);

  @override
  Logger get logger => _spawned ? Logger(config.appName!) : super.logger;
  Iterable<ModuleChannel> get modules;
  Iterable<Service> get services;

  Future<C> loadConfig();
  void onLogData(LogRecord rec, String severity) {}
  void buildCustomRoutes(String prefix, Router router);
  void serverInfo(VersionConfig version, C config);

  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  @override
  Future prepare() async {
    _spawned = true;
    config = await loadConfig();
    logger.parent?.level = toLevel(config.logLevel);
    logger.onRecord.listen((rec) {
      // ignore: avoid_print
      print(rec);
      if (rec.stackTrace != null) {
        // ignore: avoid_print
        print(rec.stackTrace);
      }

      if (config.release!) {
        onLogData.call(rec, toSeverity(rec.level));
      }
    });

    logger.fine('Channel::prepare');
    try {
      serverInfo(VersionConfig('./pubspec.yaml'), config);
    } catch (e) {
      logger.warning('WARNING! Unable to read the pubspec.yaml file');
    }

    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
      config.database!.username,
      config.database!.password,
      config.database!.host,
      config.database!.port,
      config.database!.databaseName,
    );

    context = ManagedContext(dataModel, persistentStore);

    authServer = AuthServer(AppAuth<U>(context));
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = _buildModuleRoutes();

    Future.delayed(const Duration(seconds: 3), () async {
      await _initServices();
      await _initModules();

      logger.info(' ');
      logger.info('************************************************');
      logger.info(' ');
      logger.info(' Server is now fully operational!');
      logger.info(' ');
      logger.info('************************************************');
    });

    return router;
  }

  ///
  /// Build module routes
  ///
  Router _buildModuleRoutes() {
    logger.info('Building module routes');
    final prefix = config.api!;
    final router = Router();
    buildCustomRoutes(prefix, router);

    for (final module in modules) {
      try {
        logger.info(module.runtimeType.toString());
        module.build(
          authServer: authServer,
          context: context,
          logger: logger,
          prefix: prefix,
          router: router,
        );
      } catch (e, stacktrace) {
        logger.severe(e, e, stacktrace);
      }
    }

    logger.info('Done!');
    return router;
  }

  ///
  /// Initialize all services
  ///
  Future<void> _initServices() async {
    logger.info('Channel::_initServices');
    logger.info('Initializing');
    for (final service in services) {
      try {
        logger.info(service.runtimeType.toString());
        await service.init(context);
      } catch (e, stacktrace) {
        logger.severe(e, e, stacktrace);
      }
    }

    logger.fine('Running');
    for (final service in services) {
      try {
        logger.fine(service.runtimeType.toString());
        service.run();
      } catch (e, stacktrace) {
        logger.severe(e, e, stacktrace);
      }
    }
    logger.info('Done!');
  }

  ///
  /// Initialize all modules
  ///
  Future<void> _initModules() async {
    logger.info('Channel::_initModules');
    for (final module in modules) {
      try {
        logger.info(module.runtimeType.toString());
        await module.init(logger);
      } catch (e, stacktrace) {
        logger.severe(e, e, stacktrace);
      }
    }
    logger.info('Done!');
  }

  static Future<Application<T>> initApp<T extends ApplicationChannel>(
      {List<String>? args, String? configFile}) async {
    // ignore: avoid_print
    print(args);
    final processes =
        args?.firstWhereOrNull((element) => element.startsWith('-n')) ?? '';

    final app = Application<T>()
      ..isolateStartupTimeout = const Duration(hours: 1)
      ..options.configurationFilePath = configFile ?? './config.yaml'
      ..options.port = 8888;

    final count = int.tryParse(processes.replaceFirst('-n', '')) ??
        Platform.numberOfProcessors ~/ 2;
    await app.start(numberOfInstances: count);

    // ignore: avoid_print
    print('Application started on port: ${app.options.port}.');
    // ignore: avoid_print
    print('Use Ctrl-C (SIGINT) to stop running the application.');

    return app;
  }

  static Future<APIDocument> testDoc<T extends ApplicationChannel>(
      {String? configFile}) async {
    final x = loadYaml(File('./pubspec.yaml').readAsStringSync()) as Map;
    final channel = instantiate(T)
      ..options = (ApplicationOptions()
        ..configurationFilePath = configFile ?? './config.src.yaml'
        ..port = 8888);
    await channel.prepare();
    return channel
        .documentAPI(x.map((key, value) => MapEntry(key.toString(), value)));
  }
}
