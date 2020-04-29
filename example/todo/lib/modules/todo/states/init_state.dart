import 'package:butter/butter.dart';

import '../../../utils/transitions/fade_page_transition.dart';
import '../models/init_model.dart';

// Make sure to specify the model on the BasePageState
class InitState extends BasePageState<InitModel> {
  InitState();

  InitModel model;

  InitState.build(this.model, void Function(InitModel m) f)
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
            InitModel(),
          ), (m) {
        m.proceed = () => this.pushNamed(
              "/todo/add",
              arguments: PageArguments(
                transition: FadePageTransition(),
              ),
            );
      });
}
