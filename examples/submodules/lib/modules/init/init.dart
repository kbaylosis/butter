import 'package:butter/butter.dart';

import 'pages/init_page.dart';
import 'states/init_state.dart';

class Init extends BaseModule {

  Init() : super(
    routeName: '/init',
    routes: {
      '/': BasePageConnector<InitState, InitPage>(
        state: InitState(),
        page: InitPage(), 
        getPage: (vm) => InitPage(model: vm.model),
      ), 
    },
  );
}
