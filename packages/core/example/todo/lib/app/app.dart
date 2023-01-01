import 'package:flutter/material.dart';

import '../config/app_config.dart';
import 'routes.dart';

class App extends StatelessWidget {
  static Routes routes = Routes();
  final GlobalKey<NavigatorState> navigatorKey;

  App({
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.title,
      navigatorKey: this.navigatorKey,
      onGenerateRoute: routes.onGenerateRoute,
      initialRoute: routes.defaultModule!.routeName,
    );
  }
}
