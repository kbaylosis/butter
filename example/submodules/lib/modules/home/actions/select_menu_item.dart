import 'package:butter/butter.dart';
import 'package:submodules/modules/home/actions/logout.dart';

import '../models/home_model.dart';
import '../utils/route_converter.dart';

class SeletMenuItemAction extends BaseAction {
  final int index;

  SeletMenuItemAction(this.index);

  // Make sure to strictly follow the guidelines found here:
  // https://pub.dev/packages/async_redux/#async-reducer
  @override
  AppState reduce() {
    var route = RouteConverter.indexToRoute(this.index);

    if (route == null) {
      dispatch(LogoutAction());
      return null;
    }

    pushReplacementNamed(route);

    return write<HomeModel>(HomeModel(), (m) {
      m.initialized = true;
    });
  }
}
