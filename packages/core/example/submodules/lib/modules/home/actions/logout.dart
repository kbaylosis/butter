import 'package:butter/butter.dart';

import '../../init/models/init_model.dart';
import '../models/home_model.dart';

class LogoutAction extends BaseAction {
  // Make sure to strictly follow the guidelines found here:
  // https://pub.dev/packages/async_redux/#async-reducer
  @override
  Future<AppState?> reduce() async {
    dispatchModel<HomeModel>(HomeModel(), (m) {
      m.initialized = false;
    });

    dispatchModel<InitModel>(InitModel(), (m) {
      m.hasInitialized = false;
    });

    pushNamedAndRemoveAll('/init');
    return null;
  }
}
