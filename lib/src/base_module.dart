import 'package:async_redux/async_redux.dart';
import 'package:flutter/widgets.dart';

import 'base_page_connector.dart';
import 'base_page_state.dart';
import 'base_page_view.dart';

abstract class BaseModule extends StatelessWidget {
  final String routeName;
  final Map<String, BasePageConnector<BasePageState, BasePageView>> routes;

  BaseModule({
    @required this.routeName,
    @required this.routes,
  });

  @override
  Widget build(BuildContext context) {
    String routeName = NavigateAction.getCurrentNavigatorRouteName(context);

    if (routes.containsKey(routeName)) {
      return routes[routeName];
    }

    throw UnimplementedError();
  }

}