import 'package:butter/butter.dart';

import '../actions/go_to_home_action.dart';
import '../models/init_model.dart';

// Make sure to specify the model on the BasePageState
class InitState extends BasePageState<InitModel> {
  InitState();

  InitModel? model;

  // This constructor form is not properly enforced. Which means, if you do not
  // follow this, no errors will be produced in butter. However, this allows you to
  // properly fillup your models with valid function handlers after being read
  // from the store and before it is being fed to the page.
  InitState.build(InitModel this.model, void Function(InitModel m) f)
      : super.build(model, f);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is InitState && this.runtimeType == other.runtimeType;
  }

  @override
  int get hashCode => this.hashCode;

  @override
  InitState fromStore() => InitState.build(
          read<InitModel>(
            InitModel(
              hasInitialized: false,
            ),
          )!, (m) {
        m.proceed = () => dispatch!(GoToHomeAction());
      });
}
