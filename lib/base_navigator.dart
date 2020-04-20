
import 'package:flutter/widgets.dart';

abstract class BaseNavigator {
  void pop();

  void pushNamed(String route, {
    Object arguments,
  });

  void pushReplacementNamed(String route, {
    Object arguments,
  });

  void pushNamedAndRemoveAll(String route, {
    Object arguments,
  });

  void pushNamedAndRemoveUntil(String route, {
    Object arguments,
    RoutePredicate predicate,
  });

  void popUntil(String route);

  void push(Route route, {
    Object arguments,
  });
}