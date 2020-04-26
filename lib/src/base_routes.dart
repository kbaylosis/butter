import 'package:flutter/widgets.dart';

import 'base_module.dart';
import 'base_page_transition.dart';
import 'page_arguments.dart';

class BaseRoutes {
  BasePageTransition defaultTransition;

  BaseModule _defaultModule;
  get defaultModule => _defaultModule; 

  Map<String, BaseModule> _routes;
  get routes => _routes;

  BaseRoutes({
    @required List<BaseModule> modules,
    this.defaultTransition,
  }) : 
  assert(modules != null),
  assert(modules.isNotEmpty) {
    _routes = Map();

    if (modules.isEmpty) {
      throw UnimplementedError("At least one module must be defined");
    }

    _defaultModule = modules[0];
    _routes['/'] = _defaultModule;
    modules.forEach((m) {
      _routes[m.routeName] = m;
    });
  }

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final PageArguments args = settings.arguments;
    final routeFragments = settings.name.split('/');
    String routePrefix = '';

    if (routeFragments.length > 1) {
      routePrefix = routeFragments[1];
    } else if (routeFragments.isNotEmpty) {
      routePrefix = routeFragments[0];
    }

    routePrefix = '/$routePrefix';

    if (!this._routes.containsKey(routePrefix)) {
      return null;
    }

    RouteTransitionsBuilder transitionsBuilder;
    if (args?.transition != null) {
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
      ) => this._routes[routePrefix],
      transitionsBuilder: transitionsBuilder ?? _defaultTransitionsBuilder,
    );
  }

  Widget _defaultTransitionsBuilder(
    BuildContext context, 
    Animation<double> animation, 
    Animation<double> secondaryAnimation, 
    Widget child) => child;
}