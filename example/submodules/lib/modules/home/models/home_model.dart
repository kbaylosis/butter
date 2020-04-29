import 'package:butter/butter.dart';
import 'package:flutter/foundation.dart';

class HomeModel extends BaseUIModel<HomeModel> {
  //
  // Do not declare things as final unless you really intend so.
  //
  int selectedIndex; 
  BaseModule subModule; 
  void Function(int index) onTapMenuItem;
  bool Function() checkIfInit;
  VoidCallback exit;

  HomeModel({
    this.selectedIndex = 0,
    this.subModule,
    this.onTapMenuItem,
  });

  // Make sure this key is unique among all models in this project. This will be
  // used as the key to retrieve this model from the AppStore. You wouldn't want
  // to overlap different models.
  @override
  String get $key => '/home'; 

  @override
  HomeModel clone() => HomeModel(
    selectedIndex: this.selectedIndex,
    subModule: this.subModule,
  );
}
