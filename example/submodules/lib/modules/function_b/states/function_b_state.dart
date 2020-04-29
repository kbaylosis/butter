import 'package:butter/butter.dart';

import '../models/function_b_model.dart';

class FunctionBState extends BasePageState<FunctionBModel> {
  FunctionBState();

  FunctionBModel model;

  FunctionBState.build(this.model, void Function(FunctionBModel m) f)
      : super.build(model, f);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FunctionBState && this.runtimeType == other.runtimeType;
  }

  @override
  int get hashCode => this.hashCode;

  @override
  FunctionBState fromStore() => FunctionBState.build(
      read<FunctionBModel>(
        FunctionBModel(),
      ),
      (m) {});
}
