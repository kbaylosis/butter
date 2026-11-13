import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../../butter_toolkit.dart';
import '../../highlight_text.dart';
import '../../pages/standard_button.dart';

class SuccessDialog extends StatelessWidget {
  final String message;

  const SuccessDialog(this.message, {super.key});

  @override
  Widget build(BuildContext context) => KeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKeyEvent: (v) {
          if (v.logicalKey == LogicalKeyboardKey.enter) {
            Navigator.pop(context);
          }
        },
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: Container(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Icon(
                  AntDesign.info,
                  color: ButterToolkit().brandInfo.danger,
                ),
                const SizedBox(width: 10),
                HighlightText(message),
              ],
            ),
          ),
          actions: [
            StandardButton(
              label: 'Close',
              onPressed: () => Navigator.of(context).pop(),
              type: ButtonType.normal,
              width: 100,
            ),
          ],
        ),
      );
}
