import 'package:flutter/material.dart';

import '../../butter_toolkit.dart';

class BaseButton extends StatelessWidget {
  final Alignment? alignment;
  final double height;
  final String? label;
  final MainAxisAlignment? mainAxisAlignment;
  final EdgeInsets? margin;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;
  final Widget? prefix;
  final Widget? suffix;
  final ButtonType? type;
  final double? width;

  const BaseButton({
    super.key,
    this.alignment,
    this.height = 47,
    this.label,
    this.mainAxisAlignment,
    this.margin,
    this.onPressed,
    this.padding,
    this.prefix,
    this.suffix,
    this.type,
    this.width,
  });

  @override
  Widget build(BuildContext context) => type == ButtonType.hidden
      ? Container()
      : Container(
          alignment: alignment,
          margin: margin,
          padding: padding,
          decoration: getButtonDecor(),
          width: width,
          child: TextButton(
            onPressed: type == ButtonType.disabled ? null : onPressed,
            style: TextButton.styleFrom(backgroundColor: getBackground()),
            child: SizedBox(
              height: height,
              child: Row(
                mainAxisAlignment: mainAxisAlignment ??
                    ((prefix == null && suffix == null)
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.spaceBetween),
                children: List.castFrom<Widget?, Widget>([
                  prefix,
                  (prefix != null || suffix == null) ? null : Container(),
                  label == null
                      ? null
                      : Text(
                          label!,
                          style: getTextStyle(context),
                        ),
                  (prefix == null || suffix != null) ? null : Container(),
                  suffix,
                ]..removeWhere((element) => element == null)),
              ),
            ),
          ),
        );

  Color getBackground() {
    switch (type) {
      case ButtonType.primary:
        return ButterToolkit().brandInfo.primary;
      case ButtonType.disabled:
      case ButtonType.thin:
        return Colors.transparent;
      case ButtonType.normal:
      default:
        return ButterToolkit().brandInfo.dark;
    }
  }

  TextStyle? getTextStyle(BuildContext context) {
    switch (type) {
      case ButtonType.primary:
      case ButtonType.thin:
        return Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: getTextColor(),
              fontWeight: FontWeight.normal,
            );
      case ButtonType.disabled:
        return Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: getTextColor(),
            );
      case ButtonType.normal:
      default:
        return Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: getTextColor(),
            );
    }
  }

  Color getTextColor() {
    switch (type) {
      case ButtonType.primary:
      case ButtonType.thin:
        return ButterToolkit().brandInfo.light;
      case ButtonType.disabled:
        return ButterToolkit().brandInfo.grayLighter;
      case ButtonType.normal:
      default:
        return ButterToolkit().brandInfo.light;
    }
  }

  BoxDecoration? getButtonDecor() => BoxDecoration(
        border: Border.all(width: 3, color: ButterToolkit().brandInfo.light),
      );
}

enum ButtonType {
  bare,
  disabled,
  hidden,
  normal,
  primary,
  thin,
}
