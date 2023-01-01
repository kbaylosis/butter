import 'package:butter/butter.dart';

import 'pages/function_b_page.dart';
import 'states/function_b_state.dart';

class FunctionB extends BaseModule {
  FunctionB()
      : super(
          routeName: '/functionB',
          routes: {
            '/': BasePageConnector<FunctionBState, FunctionBPage>(
              state: FunctionBState(),
              page: FunctionBPage(),
              getPage: (vm) => FunctionBPage(model: vm.model),
            ),
          },
        );
}
