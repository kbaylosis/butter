
import 'package:flutter/material.dart';

typedef OnDataChangedFunc = Function(Map<String, dynamic>);

@immutable
abstract class BaseUIModel {
  final OnDataChangedFunc onDataChanged;

  BaseUIModel({
    this.onDataChanged,
  });
}