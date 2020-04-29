import 'package:butter/butter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../components/add_item_form.dart';
import '../models/todo_model.dart';

class TodoPage extends BaseStatelessPageView {
  final TodoModel model;

  TodoPage({this.model});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('TODO List'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: this.model.back,
          ),
        ),
        body: AddTodoForm(this.model),
      ),
    );
  }
}
