import 'package:butter/butter.dart';

import 'package:submodules/modules/function_a/function_a.dart';
import 'package:submodules/modules/function_b/function_b.dart';
import 'package:submodules/modules/newsfeed/newsfeed.dart';

import 'pages/home_page.dart';
import 'states/home_state.dart';

class Home extends BaseModule {
  Home()
      : super(
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
          // This is where you define module routes. This mechanism allows you to have
          // nested modules (a module within a module within a module, etc).
          //
          // It is highly encouraged to reflect nesting of modules on the path. So supposing
          // you have a path like... /home/functionA/functionB. This should mean that
          // functionB is embedded within functionA that is embedded in home.
          //
          modules: {
            '/home/newsfeed': NewsFeed(),
            '/home/functionA': FunctionA(),
            '/home/functionB': FunctionB(),
          },
        );
}
