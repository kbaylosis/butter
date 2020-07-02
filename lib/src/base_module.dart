import 'package:async_redux/async_redux.dart';
import 'package:flutter/widgets.dart';

import 'base_page_connector.dart';
import 'base_page_state.dart';
import 'base_page_view.dart';
import 'fx_log.dart';

/// The base Module. It handles the internal routing of the module.
abstract class BaseModule extends StatelessWidget {
  /// The route name of the module
  final String routeName;

  /// The subroutes of this module
  final Map<String, Widget> routes;

  /// Child modules
  final Map<String, BaseModule> modules;

  /// Create a module by passing its [routeName] and all [routes] under it
  BaseModule({
    @required this.routeName,
    @required this.routes,
    this.modules,
  });

  /// Renders this module
  @override
  Widget build(BuildContext context) => getRoute(context);

  /// Retrieves the routeName of the current route in the navigation stack
  String getRouteName(BuildContext context) =>
      NavigateAction.getCurrentNavigatorRouteName(context);

  /// Retrieves the current route
  ///
  /// If a [routeName] is not specified, it will use the current route from the
  /// navigation stack.
  BasePageConnector<BasePageState, BasePageView> getRoute(BuildContext context,
      [String routeName]) {
    routeName ??= this.getRouteName(context);

    if (routes.containsKey(routeName)) {
      FxLog.d(
          'getRoute(): module->[${this.routeName}].fetchRouteByType(): [$routeName]');
      return _fetchRouteByType(context, routeName);
    } else {
      var parentRouteName = routeName == null ? '' : _trimRouteName(routeName);
      if (parentRouteName.isEmpty) {
        FxLog.d(
            'getRoute(): module->[${this.routeName}].fetchRouteByType(): [/]');
        return _fetchRouteByType(context, '/');
      }

      FxLog.d(
          'getRoute(): module->[${this.routeName}].getRoute(): [$parentRouteName]');
      return getRoute(context, parentRouteName);
    }
  }

  /// Retrieves the current route
  ///
  /// If a [routeName] is not specified, it will use the current route from the
  /// navigation stack.
  BasePageConnector<BasePageState, BasePageView> getChild(BuildContext context,
      [String routeName]) {
    if (modules == null) {
      return null;
    }

    routeName ??= this.getRouteName(context);

    if (modules.containsKey(routeName)) {
      FxLog.d(
          'getChild(): module->[$routeName].getRoute(): [${this.getRouteName(context)}]');
      return modules[routeName].getRoute(context, this.getRouteName(context));
    } else {
      var parentRouteName = _trimRouteName(routeName);
      if (parentRouteName == '/' || parentRouteName.isEmpty) {
        FxLog.w(
            'getChild(): [$routeName] module doesn\'t exist inside [${this.routeName}].');
        return null;
      }

      FxLog.d(
          'getChild(): module->[${this.routeName}].getChild(): [$parentRouteName]');
      return getChild(context, parentRouteName);
    }
  }

  /// Fetches a route using its [routeName]
  ///
  /// If an object of type [BaseModule] is obtained, drill down until the route nest
  /// yields a [BasePageConnector]. Any other type throws a [FormatException].
  /// NOTE: This mechanism doesn't handle circular references. Take good care
  /// in designing your root trees well!
  BasePageConnector<BasePageState, BasePageView> _fetchRouteByType(
      BuildContext context, String routeName) {
    var r = routes[routeName];
    if (r is BasePageConnector) {
      return r;
    } else if (r is BaseModule) {
      return r.getRoute(context, routeName);
    }

    throw FormatException(
        'Invalid type in BaseModule.routes for route [$routeName] in [${this.routeName}]. '
        'Must of be of type BasePageConnector or BaseModule.');
  }

  /// Remove either the leading or trailing path fragment '/<name>' from the full routeName
  String _trimRouteName(String routeName, [bool tail = true]) =>
      routeName.replaceFirst(
          RegExp('/([A-Za-z_])+([A-Za-z0-9_])+${tail ? '\$' : ''}'), '');
}
