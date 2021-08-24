import 'package:butter/butter.dart';

class ChangeSubModuleAction extends BaseAction {
  final String route;

  ChangeSubModuleAction(this.route);

  // Make sure to strictly follow the guidelines found here:
  // https://pub.dev/packages/async_redux/#async-reducer
  @override
  AppState? reduce() {
    pushReplacementNamed(this.route);
    return null;
  }
}
