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
  final Map<String, BasePageConnector<BasePageState, BasePageView>> routes;

  /// Create a module by passing its [routeName] and all [routes] under it
  BaseModule({
    @required this.routeName,
    @required this.routes,
  });

  /// Renders this module
  @override
  Widget build(BuildContext context) => getCurrentRoute(context);

  /// Retrieves the current route
  BasePageConnector<BasePageState, BasePageView> getCurrentRoute(
      BuildContext context) {
    String routeName = NavigateAction.getCurrentNavigatorRouteName(context);

    if (routes.containsKey(routeName)) {
      return routes[routeName];
    } else if (routes.containsKey('/')) {
      return routes['/'];
    }

    throw UnimplementedError();
  }
}
