import 'package:flutter/material.dart';

class ButtonIcon extends StatelessWidget {
  final Color color;
  final bool hide;
  final IconData? iconData;
  final double? size;
  final void Function()? onPressed;
  final EdgeInsets? margin;
  final EdgeInsets padding;
  final Widget? child;

  const ButtonIcon({
    super.key,
    this.iconData,
    this.color = const Color.fromRGBO(119, 119, 119, 0.8),
    this.hide = false,
    this.margin,
    this.onPressed,
    this.padding = const EdgeInsets.all(2),
    this.size,
    this.child,
  });

  @override
  Widget build(BuildContext context) => hide
      ? Container()
      : Container(
          margin: margin,
          child: RawMaterialButton(
            constraints: const BoxConstraints(),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: onPressed,
            padding: padding,
            shape: const CircleBorder(),
            child: child ??
                Icon(
                  iconData,
                  color: color,
                  size: size,
                ),
          ),
        );
}
