import 'dart:ui';

import 'package:butter/butter.dart';

class InitModel extends BaseUIModel<InitModel> {
  bool hasInitialized;
  VoidCallback proceed;

  InitModel({
    this.hasInitialized = false,
    this.proceed,
  });

  @override
  String get $key => '/init';

  @override
  InitModel clone() => InitModel();
}
