import 'package:butter/butter.dart';

import 'pages/function_a_page.dart';
import 'states/function_a_state.dart';

class FunctionA extends BaseModule {
  FunctionA()
      : super(
          routeName: '/functionA',
          routes: {
            '/': BasePageConnector<FunctionAState, FunctionAPage>(
              state: FunctionAState(),
              page: FunctionAPage(),
              getPage: (vm) => FunctionAPage(model: vm.model),
            ),
          },
        );
}
