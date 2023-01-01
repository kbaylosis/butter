import 'package:butter/butter.dart';

import 'pages/init_page.dart';
import 'pages/todo_page.dart';
import 'states/init_state.dart';
import 'states/todo_state.dart';

class Todo extends BaseModule {
  Todo()
      : super(
          routeName: '/todo',
          routes: {
            // This is the root route of the module ('/').
            '/': BasePageConnector<InitState, InitPage>(
              state: InitState(),
              page: InitPage(),
              getPage: (vm) => InitPage(model: vm.model),
            ),
            '/todo/add': BasePageConnector<TodoState, TodoPage>(
              state: TodoState(),
              page: TodoPage(),
              getPage: (vm) => TodoPage(model: vm.model),
            ),
          },
        );
}
