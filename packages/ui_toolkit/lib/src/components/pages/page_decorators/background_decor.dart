import 'package:flutter/material.dart';

import '../../../utils/screens.dart';
import '../base_page.dart';

class BackgroundDecor extends PageDecorator {
  final String imagePath;

  BackgroundDecor({
    required this.imagePath,
  });

  @override
  Widget? build(BuildContext context, {Widget? child}) => Stack(
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            height: Screens(context).height,
            width: Screens(context).width,
          ),
          child ?? const SizedBox(),
        ],
      );
}
