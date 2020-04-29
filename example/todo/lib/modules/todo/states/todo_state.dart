import 'package:butter/butter.dart';

import '../actions/add_todo_action.dart';
import '../models/todo_model.dart';

// Make sure to specify the model on the BasePageState
class TodoState extends BasePageState<TodoModel> {
  TodoState();

  TodoModel model;

  TodoState.build(this.model, void Function(TodoModel m) f) :
    super.build(model, f);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
      other is TodoState && 
      this.runtimeType == other.runtimeType &&
      this.model.items == other.model.items;
  }

  @override
  int get hashCode => this.hashCode;

  @override
  TodoState fromStore() => TodoState.build(read<TodoModel>(
    TodoModel(
      items: List<String>(),
    )
  ), (m) {
    m.add = (value) => dispatch(AddTodoAction(value));
    m.back = () => this.pop();
  });
}
