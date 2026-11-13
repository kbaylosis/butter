import 'package:flutter/material.dart';

import '../../butter_toolkit.dart';
import '../highlight_text.dart';
import '../pages/standard_button.dart';

class InputDialog extends StatefulWidget {
  final double? height;
  final String? hintText;
  final String? initValue;
  final void Function()? onCancel;
  final bool Function(String value)? onProceed;
  final String? title;
  final double? width;

  const InputDialog({
    super.key,
    this.height,
    this.hintText,
    this.initValue,
    this.onCancel,
    this.onProceed,
    this.title,
    this.width,
  });
  @override
  State<StatefulWidget> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  final txtInput = TextEditingController();

  @override
  void initState() {
    super.initState();

    txtInput.text = widget.initValue ?? '';
  }

  @override
  void didUpdateWidget(covariant InputDialog oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initValue != widget.initValue) {
      txtInput.text = widget.initValue ?? '';
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        key: widget.key,
        title: HighlightText(
          widget.title!,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .apply(color: ButterToolkit().brandInfo.dark),
        ),
        content: SizedBox(
          height: widget.height,
          width: widget.width,
          child: TextFormField(
            controller: txtInput,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color:
                        ButterToolkit().brandInfo.grayLight.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(6.0),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                    color:
                        ButterToolkit().brandInfo.grayLight.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(6.0),
              ),
              hintText: widget.hintText,
              hintStyle: TextStyle(
                  color: ButterToolkit().brandInfo.grayLighter, fontSize: 16),
            ),
            maxLines: 8,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        actions: [
          StandardButton(
            label: 'Cancel',
            onPressed: widget.onCancel ?? () => Navigator.of(context).pop(),
            type: ButtonType.thin,
            width: 100,
          ),
          StandardButton(
            label: 'Ok',
            onPressed: () {
              if (widget.onProceed?.call(txtInput.text) ?? false) {
                Navigator.of(context).pop();
              }
            },
            type: ButtonType.normal,
            width: 100,
          ),
        ],
      );
}
