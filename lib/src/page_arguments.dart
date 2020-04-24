import 'base_page_transition.dart';

class PageArguments<PageTransition extends BasePageTransition> {
  dynamic arg;
  PageTransition transition;

  PageArguments({
    this.arg, 
    this.transition,
  });
}