import 'package:butter/butter.dart';
import 'package:flutter/widgets.dart';

import 'app/app.dart';

late Store<AppState> store;
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  store = Store<AppState>(initialState: AppState(data: Map<String, dynamic>()));
  NavigateAction.setNavigatorKey(navigatorKey);

  runApp(StoreProvider<AppState>(
    store: store,
    child: App(
      navigatorKey: navigatorKey,
    ),
  ));
}
