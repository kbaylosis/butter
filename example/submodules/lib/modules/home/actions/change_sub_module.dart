import 'package:butter/butter.dart';
import 'package:submodules/modules/home/sub_modules.dart';

import '../models/home_model.dart';

class ChangeSubModuleAction extends BaseAction {
  final String route;

  ChangeSubModuleAction(this.route);

  // Make sure to strictly follow the guidelines found here:
  // https://pub.dev/packages/async_redux/#async-reducer
  @override
  AppState reduce() => write<HomeModel>(HomeModel(), (m) {
        m.subModule = SubModules.routes[route];
      });
}
