import 'package:flutter/material.dart';

import '../base_page.dart';

class ScrollableDecor extends PageDecorator {
  final ScrollController? controller;

  ScrollableDecor({
    this.controller,
  });

  @override
  Widget? build(BuildContext context, {Widget? child}) => Scrollbar(
        controller: controller,
        child: SingleChildScrollView(
          controller: controller,
          physics: const ClampingScrollPhysics(),
          child: child,
        ),
      );
}
