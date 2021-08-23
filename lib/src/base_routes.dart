import 'package:flutter/widgets.dart';

import 'base_module.dart';
import 'base_page_transition.dart';
import 'page_arguments.dart';

/// This is the base definition of a route class
///
/// Processes a list of routes for app navigation
///
/// Usage:
/// ```
/// class Routes extends BaseRoutes {
///   Routes()
///     : super(
///       modules: [
///         Todo(), // First defined module gets the root route ('/')
///       ],
///       defaultTransition: ScalePageTransition(),
///     );
/// }
/// ```
/// where ScalePageTransition extends [BasePageTransition] and
/// Todo extends [BaseModule]
class BaseRoutes {
  /// The default page transition animation
  BasePageTransition? defaultTransition;

  /// The default module of the application
  BaseModule? _defaultModule;

  /// The default module of the application
  BaseModule? get defaultModule => _defaultModule;

  /// The list of top level routes in the app
  Map<String, BaseModule?>? _routes;

  /// The list of top level routes in the app
  Map<String, BaseModule?>? get routes => _routes;

  /// Handles the top level route management of the app given a list of [modules] and
  /// a [defaultTransition]
  ///
  /// The topmost module in the list of [modules] automatically becomes the [defaultModule]
  BaseRoutes({
    required List<BaseModule> modules,
    this.defaultTransition,
  })  : assert(modules != null),
        assert(modules.isNotEmpty) {
    _routes = Map();

    if (modules.isEmpty) {
      throw UnimplementedError("At least one module must be defined");
    }

    _defaultModule = modules[0];
    _routes!['/'] = _defaultModule;
    modules.forEach((m) {
      _routes![m.routeName] = m;
    });
  }

  /// Generates a route object based on the current route name
  ///
  /// Usage:
  /// ```
  /// static Routes routes = Routes();
  ///
  /// ...
  ///
  /// MaterialApp(
  ///   ...
  ///   onGenerateRoute: routes.onGenerateRoute,
  ///   ...
  /// );
  /// ```
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final PageArguments? args = settings.arguments as PageArguments<BasePageTransition>?;
    final routeFragments = settings.name!.split('/');
    String routePrefix = '';

    if (routeFragments.length > 1) {
      routePrefix = routeFragments[1];
    } else if (routeFragments.isNotEmpty) {
      routePrefix = routeFragments[0];
    }

    routePrefix = '/$routePrefix';

    if (!this._routes!.containsKey(routePrefix)) {
      routePrefix = '/';
      print('Routing: [${settings.name}] ==> [$routePrefix]');
    }

    RouteTransitionsBuilder? transitionsBuilder;
    if (args?.transition != null) {
      transitionsBuilder = args!.transition!.build();
    } else if (this.defaultTransition != null) {
      transitionsBuilder = this.defaultTransition!.build();
    }

    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) =>
          this._routes![routePrefix]!,
      transitionsBuilder: transitionsBuilder ?? _defaultTransitionsBuilder,
    );
  }

  /// Generates a default transition builder object in case none is specified for
  /// the current route and the [defaultTransition]
  Widget _defaultTransitionsBuilder(
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child) =>
      child;
}
