import 'package:butter/butter.dart';
import 'package:flutter/widgets.dart';

class NoTransition extends BasePageTransition {
  @override
  build() => (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) =>
          child;
}
