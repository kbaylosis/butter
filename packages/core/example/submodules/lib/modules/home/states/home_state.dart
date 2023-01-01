import 'package:butter/butter.dart';


import '../../init/models/init_model.dart';
import '../actions/logout.dart';
import '../actions/select_menu_item.dart';
import '../models/home_model.dart';

// Make sure to specify the model on the BasePageState
class HomeState extends BasePageState<HomeModel> {
  HomeState();

  HomeModel? model;

  // This constructor form is not properly enforced. Which means, if you do not
  // follow this, no errors will be produced in butter. However, this allows you to
  // properly fillup your models with valid function handlers after being read
  // from the store and before it is being fed to the page.
  HomeState.build(HomeModel this.model, void Function(HomeModel m) f)
      : super.build(model, f);

  // Make sure to properly define this function. Otherwise, your reducers
  // will not trigger view updates... and you will end up pulling all your hair.
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HomeState &&
            this.runtimeType == other.runtimeType &&
            this.model!.initialized == other.model!.initialized;
  }

  @override
  int get hashCode => this.hashCode;

  @override
  HomeState fromStore() => HomeState.build(
          read<HomeModel>(HomeModel(
            initialized: false,
          )), (m) {
        m.onTapMenuItem = (index) => dispatch!(SeletMenuItemAction(index));
        m.checkIfInit = () => read<InitModel>(InitModel()).hasInitialized;
        m.exit = () => dispatch!(LogoutAction());
      });
}
