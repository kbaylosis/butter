import 'package:butter/butter.dart';

import '../models/init_model.dart';

class GoToHomeAction extends BaseAction {
  @override
  AppState reduce() {
    this.pushNamedAndRemoveAll("/");

    return write<InitModel>(InitModel(), (m) {
      m.hasInitialized = true;
    });
  }
}
