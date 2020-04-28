import 'package:butter/butter.dart';

class LogoutAction extends BaseAction {

  // Make sure to strictly follow the guidelines found here:
  // https://pub.dev/packages/async_redux/#async-reducer
  @override
  AppState reduce() {
    super.pushNamedAndRemoveAll('/init');
    return null;
  }
}