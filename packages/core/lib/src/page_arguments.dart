import 'base_page_transition.dart';

/// The page arguments to be passed to a route
class PageArguments<PageTransition extends BasePageTransition> {
  /// The actual arguments to be passed to a route
  final dynamic arg;

  /// The animation to perform while transitioning to a new page
  final PageTransition? transition;

  /// Creates the page argument object
  PageArguments({
    this.arg,
    this.transition,
  });
}
