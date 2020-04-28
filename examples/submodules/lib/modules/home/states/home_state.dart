import 'package:butter/butter.dart';

import 'package:submodules/config/app.dart';
import 'package:submodules/modules/home/actions/logout.dart';
import 'package:submodules/modules/init/models/init_model.dart';

import '../actions/select_menu_item.dart';
import '../models/home_model.dart';

// Make sure to specify the model on the BasePageState
class HomeState extends BasePageState<HomeModel> {
  HomeState();

  HomeModel model;

  // This constructor form is not properly enforced. Which means, if you do not
  // follow this, no errors will be produced in butter. However, this allows you to
  // properly fillup your models with valid function handlers after being read
  // from the store and before it is being fed to the page.
  HomeState.build(this.model, void Function(HomeModel m) f) :
    super.build(model, f);

  // Make sure to properly define this function. Otherwise, your reducers 
  // will not trigger view updates... and you will end up pulling all your hair.
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
      other is HomeState && 
      this.runtimeType == other.runtimeType &&
      this.model.selectedIndex == other.model.selectedIndex &&
      this.model.subModule == other.model.subModule;
  }

  @override
  int get hashCode => this.hashCode;

  @override
  HomeState fromStore() => HomeState.build(read<HomeModel>(
    HomeModel(
      selectedIndex: AppConfig.defaultHomePage,
    )
  ), (m) {
    m.onTapMenuItem = (index) => dispatch(SeletMenuItemAction(index));
    m.checkIfInit = () => read<InitModel>(InitModel()).hasInitialized;
    m.exit = () => dispatch(LogoutAction());
  });
}
