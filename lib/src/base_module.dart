import 'package:async_redux/async_redux.dart';
import 'package:flutter/widgets.dart';

import 'base_page_connector.dart';
import 'base_page_state.dart';
import 'base_page_view.dart';

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

  String getRouteName(BuildContext context) =>
      NavigateAction.getCurrentNavigatorRouteName(context);

  /// Retrieves the current route
  BasePageConnector<BasePageState, BasePageView> getRoute(
      BuildContext context) {
    String routeName = this.getRouteName(context);

    if (routes.containsKey(routeName)) {
      return _fetchRouteByType(context, routeName);
    } else {
      return _fetchRouteByType(context, '/');
    }
  }

  /// Retrieves the current route
  BasePageConnector<BasePageState, BasePageView> getChild(
      BuildContext context) {
    if (modules == null) {
      return null;
    }

    String routeName = this.getRouteName(context);

    if (modules.containsKey(routeName)) {
      return modules[routeName].getRoute(context);
    } else if (modules.containsKey('/')) {
      return modules['/'].getRoute(context);
    }

    return this.getRoute(context);
  }

  BasePageConnector<BasePageState, BasePageView> _fetchRouteByType(
      BuildContext context, String routeName) {
    var r = routes[routeName];
    if (r is BasePageConnector) {
      return r;
    } else if (r is BaseModule) {
      return r.getRoute(context);
    }

    throw FormatException(
        'Invalid type in BaseModule.routes for route [$routeName] in [${this.routeName}]. '
        'Must of be of type BasePageConnector or BaseModule.');
  }
}
