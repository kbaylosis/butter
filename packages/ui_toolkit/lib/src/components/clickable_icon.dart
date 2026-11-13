import 'package:flutter/material.dart';

class ClickableIcon extends StatelessWidget {
  final Color? color;
  final bool hide;
  final IconData? iconData;
  final double? size;
  final void Function()? onPressed;
  final EdgeInsets? margin;
  final EdgeInsets padding;
  final Widget? child;

  const ClickableIcon({
    super.key,
    this.color,
    this.hide = false,
    this.iconData,
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
            onPressed: onPressed ?? () {},
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
