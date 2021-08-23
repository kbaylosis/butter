import 'package:butter/butter.dart';

import '../models/function_a_model.dart';

class FunctionAState extends BasePageState<FunctionAModel> {
  FunctionAState();

  FunctionAModel? model;

  FunctionAState.build(FunctionAModel this.model, void Function(FunctionAModel m) f)
      : super.build(model, f);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FunctionAState && this.runtimeType == other.runtimeType;
  }

  @override
  int get hashCode => this.hashCode;

  @override
  FunctionAState fromStore() => FunctionAState.build(
      read<FunctionAModel>(
        FunctionAModel(),
      )!,
      (m) {});
}
