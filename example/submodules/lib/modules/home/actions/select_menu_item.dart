import 'package:butter/butter.dart';

import '../actions/change_sub_module.dart';
import '../actions/logout.dart';
import '../models/home_model.dart';

class SeletMenuItemAction extends BaseAction {
  final int index;

  SeletMenuItemAction(this.index);

  // Make sure to strictly follow the guidelines found here:
  // https://pub.dev/packages/async_redux/#async-reducer
  @override
  AppState reduce() {
    switch (this.index) {
      case 0:
        dispatch(ChangeSubModuleAction('/home/newsfeed'));
        break;
      case 1:
        dispatch(ChangeSubModuleAction('/home/functionA'));
        break;
      case 2:
        dispatch(ChangeSubModuleAction('/home/functionB'));
        break;
      default:
        dispatch(LogoutAction());
        break;
    }

    return write<HomeModel>(HomeModel(), (m) {
      m.selectedIndex = index;
    });
  }
}
