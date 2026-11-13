import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double radius;
  final Widget? child;

  const CircularButton({
    super.key,
    this.onTap,
    this.radius = 0,
    this.child,
  });

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
