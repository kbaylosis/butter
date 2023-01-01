import 'dart:ui';

import 'package:butter/butter.dart';

class TodoModel extends BaseUIModel<TodoModel> {
  List<String>? items;
  VoidCallback? back;
  void Function(String value)? add;

  TodoModel({
    this.items,
    this.back,
    this.add,
  });

  @override
  String get $key => '/todo';

  @override
  TodoModel clone() => TodoModel(
        items: this.items == null ? [] : [...this.items!],
      );
}
