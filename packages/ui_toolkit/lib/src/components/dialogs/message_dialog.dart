import 'package:flutter/material.dart';

import '../../butter_toolkit.dart';
import '../highlight_text.dart';
import '../pages/standard_button.dart';

class MessageDialog extends StatefulWidget {
  final String? name;
  final String? title;
  final String? message;
  final void Function()? onOk;

  const MessageDialog({
    super.key,
    this.name,
    this.onOk,
    this.title,
    this.message,
  });
  @override
  State<StatefulWidget> createState() => _MessageDialogState();
}

class _MessageDialogState extends State<MessageDialog> {
  @override
  Widget build(BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        key: widget.key,
        title: widget.title == null
            ? null
            : HighlightText(
                widget.title!,
                style: Theme.of(context).textTheme.headlineMedium!.apply(
                      color: ButterToolkit().brandInfo.dark,
                    ),
              ),
        content: widget.message == null ? null : HighlightText(widget.message!),
        actions: [
          StandardButton(
            label: 'Ok',
            onPressed: widget.onOk ?? () => Navigator.of(context).pop(),
            type: ButtonType.normal,
            width: 100,
          ),
        ],
      );
}
