import 'package:flutter/material.dart';

import '../../butter_toolkit.dart';
import '../highlight_text.dart';
import '../pages/standard_button.dart';

class ProceedDialog extends StatefulWidget {
  final String? name;
  final String? title;
  final String? message;
  final void Function()? onCancel;
  final void Function()? onProceed;

  const ProceedDialog({
    super.key,
    this.name,
    this.onCancel,
    this.onProceed,
    this.title,
    this.message,
  });
  @override
  State<StatefulWidget> createState() => _ProceedDialogState();
}

class _ProceedDialogState extends State<ProceedDialog> {
  @override
  Widget build(BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        key: widget.key,
        title: HighlightText(
          widget.title!,
          style: Theme.of(context).textTheme.headlineMedium!.apply(
                color: ButterToolkit().brandInfo.dark,
              ),
        ),
        content: HighlightText(widget.message!),
        actions: [
          StandardButton(
            label: 'Cancel',
            onPressed: widget.onCancel ?? () => Navigator.of(context).pop(),
            type: ButtonType.normal,
            width: 100,
          ),
          StandardButton(
            label: 'Proceed',
            onPressed: widget.onProceed,
            type: ButtonType.thin,
            width: 100,
          ),
        ],
      );
}
