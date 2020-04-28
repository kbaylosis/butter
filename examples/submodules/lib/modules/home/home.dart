import 'package:butter/butter.dart';

import 'pages/home_page.dart';
import 'states/home_state.dart';

class Home extends BaseModule {

  Home() : super(
    routeName: '/home',
    routes: {
      // This is the root route of the module ('/').
      // Since Home is the root module this definition will become the entry point 
      // of the whole App
      '/': BasePageConnector<HomeState, HomePage>(
        state: HomeState(),
        page: HomePage(), 
        getPage: (vm) => HomePage(model: vm.model),
      ),
    },
  );
}
