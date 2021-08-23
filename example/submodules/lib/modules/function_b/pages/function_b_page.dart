import 'package:butter/butter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:submodules/utils/sub_module_page_specs.dart';

import '../models/function_b_model.dart';

class FunctionBPage extends BaseStatelessPageView {
  final FunctionBModel? model;

  FunctionBPage({this.model});

  final _specs = PageSpecs(
    inSafeArea: true,
    hasAppBar: true,
    title: 'Function B',
  );

  @override
  get specs {
    return this._specs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Function B'),
      ),
    );
  }
}
