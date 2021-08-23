import 'package:butter/butter.dart';

import '../models/todo_model.dart';

class AddTodoAction extends BaseAction {
  final String item;

  AddTodoAction(this.item);

  @override
  AppState reduce() => write<TodoModel>(TodoModel(), (m) {
        m.items!.add(this.item);
      });
}
