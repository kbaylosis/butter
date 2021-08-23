import 'package:butter/butter.dart';
import 'package:flutter/foundation.dart';

class HomeModel extends BaseUIModel<HomeModel> {
  //
  // Do not declare things as final unless you really intend so.
  //
  bool initialized;
  void Function(int index)? onTapMenuItem;
  late bool Function() checkIfInit;
  late VoidCallback exit;

  HomeModel({
    this.initialized = false,
    this.onTapMenuItem,
  });

  // Make sure this key is unique among all models in this project. This will be
  // used as the key to retrieve this model from the AppStore. You wouldn't want
  // to overlap different models.
  @override
  String get $key => '/home';

  @override
  HomeModel clone() => HomeModel(
        initialized: this.initialized,
      );
}
