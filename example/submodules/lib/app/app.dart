import 'package:butter/butter.dart';
import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../app/routes.dart';
import 'routes.dart';

/// The main app declaration
class App extends StatelessWidget {
  static Routes routes = Routes();
  final GlobalKey<NavigatorState> navigatorKey;

  App({
    @required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.title,
      navigatorKey: this.navigatorKey,
      onGenerateRoute: routes.onGenerateRoute,
      initialRoute: routes.defaultModule.routeName,
    );
  }

  static BasePageConnector<BasePageState<BaseUIModel>, BasePageView> getChild(
          BuildContext context, BaseUIModel model) =>
      App.routes.routes[model.$key].getChild(context);

  static String getRouteName(BuildContext context, BaseUIModel model) =>
      App.routes.routes[model.$key].getRouteName(context);
}
