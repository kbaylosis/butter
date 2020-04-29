import 'package:butter/butter.dart';
import 'package:flutter/widgets.dart';

class PageSpecs extends BasePageSpecs {
  final bool inSafeArea;
  final bool hasAppBar;
  final String title;
  final Widget leading;
  final List<Widget> actions;

  PageSpecs({
    this.inSafeArea = true,
    this.hasAppBar = true,
    this.title,
    this.leading,
    this.actions,
  });
}
