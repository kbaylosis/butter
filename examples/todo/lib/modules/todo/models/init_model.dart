import 'dart:ui';

import 'package:butter/butter.dart';

class InitModel extends BaseUIModel<InitModel> {
  VoidCallback proceed;

  InitModel({
    this.proceed,
  });

  @override
  String get $key => '/init';

  @override
  InitModel clone() => InitModel();
}
