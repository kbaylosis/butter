import 'package:flutter/material.dart';

class HighlightText extends StatelessWidget {
  final String? text;
  final TextStyle? style;
  final TextAlign? textAlign;

  const HighlightText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) => SelectableText(
        text ?? '',
        style: style ?? const TextStyle(),
        textAlign: textAlign ?? TextAlign.left,
        showCursor: true,
      );
}
