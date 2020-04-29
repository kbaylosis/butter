import 'package:butter/butter.dart';
import 'package:flutter/widgets.dart';

class FadePageTransition extends BasePageTransition {
  @override
  build() {
    return (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) => FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}