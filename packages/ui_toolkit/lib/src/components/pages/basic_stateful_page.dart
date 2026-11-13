import 'dart:async';

import 'package:butter/butter.dart';
import 'package:flutter/material.dart';

abstract class BasicStatefulPage extends BaseStatefulPageView {
  BasicStatefulPage({super.key, super.animationDelay = 0});

  @override
  @mustCallSuper
  FutureOr<bool> beforeLoad(BuildContext context) => true;

  @override
  Widget buildLoading(BuildContext context) => const Align(
        alignment: Alignment.topCenter,
        child: LinearProgressIndicator(),
      );
}
