import 'package:async_redux/async_redux.dart';
import 'package:flutter/widgets.dart';

/// The base interface for navigation
abstract class BaseNavigator {
  /// Removes the current route from the navigation stack
  void pop();

  /// Puts a route on top of the navigation stack
  void pushNamed(
    String route, {
    Object? arguments,
  });

  /// Replaces the current route with the specified route
  void pushReplacementNamed(
    String route, {
    Object? arguments,
  });

  /// Adds a route into the navigation stack and removes everything else
  void pushNamedAndRemoveAll(
    String route, {
    Object? arguments,
  });

  /// Adds a route into the navigation stack and removes everything until the condition
  /// specified in [predicate] is satisfied
  void pushNamedAndRemoveUntil(
    String route, {
    Object? arguments,
    RoutePredicate? predicate,
  });

  /// Removes all routes in the navigation stack until the condition specified in
  /// [predicate] is satisfied
  void popUntil(bool Function(Route<dynamic>) predicate);

  /// Puts a route object on top of the navigation stack
  void push(Route route);

  /// Retrieves the routeName of the current route in the navigation stack
  static String? getRouteName(BuildContext context) =>
      NavigateAction.getCurrentNavigatorRouteName(context);
}
