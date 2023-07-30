import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double radius;
  final Widget? child;

  const CircularButton({
    Key? key,
    this.onTap,
    this.radius = 0,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          focusColor: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          onTap: onTap,
          child: child,
        ),
      );
}
