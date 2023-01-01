import 'package:flutter/widgets.dart';

/// The base class for page transitions
///
/// This is used to build [RouteTransitionsBuilder] for page transitions.
abstract class BasePageTransition {
  /// Build a [RouteTransitionsBuilder] object
  ///
  /// Usage:
  /// ```
  /// class FadePageTransition extends BasePageTransition {
  ///   @override
  ///   build() {
  ///     return (
  ///       BuildContext context,
  ///       Animation<double> animation,
  ///       Animation<double> secondaryAnimation,
  ///       Widget child,
  ///     ) =>
  ///         FadeTransition(
  ///           opacity: animation,
  ///           child: child,
  ///         );
  ///   }
  /// }
  /// ```
  RouteTransitionsBuilder build();
}
