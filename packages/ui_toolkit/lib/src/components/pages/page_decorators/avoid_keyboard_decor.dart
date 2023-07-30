import 'package:avoid_keyboard/avoid_keyboard.dart';
import 'package:flutter/material.dart';

import '../base_page.dart';

class AvoidKeyboardDecor extends PageDecorator {
  @override
  Widget? build(BuildContext context, {Widget? child}) =>
      AvoidKeyboard(child: child!);
}
