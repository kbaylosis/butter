import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/todo_model.dart';

class AddTodoForm extends StatefulWidget {
  final TodoModel? model;

  AddTodoForm(this.model);

  @override
  State<StatefulWidget> createState() => _AddTodoFormState();
}

class _AddTodoFormState extends State<AddTodoForm> {
  final TextEditingController txtItem = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];

    widget.model!.items!.forEach((element) {
      items.add(
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(10),
          child: Text(element),
        ),
      );
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: TextField(
                  controller: txtItem,
                  decoration: InputDecoration(
                    hintText: 'Enter todo item',
                  ),
                  onSubmitted: (value) {
                    widget.model!.add!(value);
                    txtItem.clear();
                  },
                ),
              ),
              Expanded(
                flex: 0,
                child: IconButton(
                  icon: Icon(Icons.add_circle),
                  onPressed: () {
                    widget.model!.add!(txtItem.text);
                    txtItem.clear();
                  },
                ),
              ),
            ],
          ),
        ),
        ...items,
      ],
    );
  }
}
