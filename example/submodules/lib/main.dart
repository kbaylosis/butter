import 'package:async_redux/async_redux.dart';
import 'package:butter/butter.dart';
import 'package:flutter/widgets.dart';

import 'app/app.dart';

Store<AppState> store;
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  Butter.level = LogLevel.debug;
  Butter.showTimestamp = true;
  Butter.showFxLogs = true;

  Butter.d('Starting the app...');
  store = Store<AppState>(initialState: AppState(data: Map<String, dynamic>()));
  NavigateAction.setNavigatorKey(navigatorKey);

  runApp(StoreProvider<AppState>(
    store: store,
    child: App(
      navigatorKey: navigatorKey,
    ),
  ));
}
