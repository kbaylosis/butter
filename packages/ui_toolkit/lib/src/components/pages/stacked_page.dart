import 'package:flutter/material.dart';

import 'standard_button.dart';

abstract class StackedPage extends Widget {
  final String title = '';
  final void Function()? onChanged = null;

  const StackedPage({super.key});

  bool get allowNext;
  bool goBack();
  Future<void> next();
  ButtonType get nextType;
  Widget? subTitle();
}

class StackedView extends StatelessWidget {
  final Widget? child;
  final double? height;

  const StackedView({
    super.key,
    this.child,
    this.height,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        height: height,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: child ?? const SizedBox(),
        ),
      );
}

class StackedPagedController {
  bool Function() allowNext = () => false;
  Future<void> Function() next = () async {};
  ButtonType? Function() nextType = () => null;
}
