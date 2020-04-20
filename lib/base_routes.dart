import 'package:flutter/widgets.dart';

import 'package:rokpak_mobile/core/base_module.dart';
import 'package:rokpak_mobile/core/base_page_transition.dart';
import 'package:rokpak_mobile/core/page_arguments.dart';

class BaseRoutes<SingleChildRenderObjectWidget> {
  BaseModule defaultModule;
  final BasePageTransition defaultTransition;
  Map<String, BaseModule> routes;

  BaseRoutes({
    @required List<BaseModule> modules,
    @required this.defaultTransition,
  }) {
    routes = Map();

    if (modules.isEmpty) {
      throw UnimplementedError("At least one module must be defined");
    }

    defaultModule = modules[0];
    routes['/'] = defaultModule;
    modules.forEach((m) {
      routes[m.routeName] = m;
    });
  }

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final PageArguments args = settings.arguments ?? PageArguments();
    final routeFragments = settings.name.split('/');
    String routePrefix = '';

    if (routeFragments.length > 1) {
      routePrefix = routeFragments[1];
    } else if (routeFragments.isNotEmpty) {
      routePrefix = routeFragments[0];
    }

    routePrefix = '/$routePrefix';

    if (!this.routes.containsKey(routePrefix)) {
      throw UnimplementedError();
    }

    RouteTransitionsBuilder transitionsBuilder; 
    if (args.transition != null) {
      transitionsBuilder = args.transition.build(); 
    } else if (this.defaultTransition != null) {
      transitionsBuilder = this.defaultTransition.build(); 
    }

    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) => this.routes[routePrefix],
      transitionsBuilder: transitionsBuilder,
    );
  }
}