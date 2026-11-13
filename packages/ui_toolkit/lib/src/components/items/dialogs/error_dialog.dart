import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../../butter_toolkit.dart';
import '../../highlight_text.dart';
import '../../pages/standard_button.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  final String? details;

  const ErrorDialog(
    this.message, {
    super.key,
    this.details,
  });

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesome.exclamation_triangle,
                  color: ButterToolkit().brandInfo.danger,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Wrap(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HighlightText(message),
                          const SizedBox(height: 10),
                          details == null
                              ? const SizedBox(height: 0)
                              : HighlightText(details ?? '',
                                  style: ButterToolkit()
                                      .brandInfo
                                      .theme
                                      .textTheme
                                      .labelSmall),
                        ],
                      ),
                    ],
                  ),
                ),
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
