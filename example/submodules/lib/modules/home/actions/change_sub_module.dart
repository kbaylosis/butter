import 'package:butter/butter.dart';

class ChangeSubModuleAction extends BaseAction {
  final String route;

  ChangeSubModuleAction(this.route);

  // Make sure to strictly follow the guidelines found here:
  // https://pub.dev/packages/async_redux/#async-reducer
  @override
  Future<AppState?> reduce() async {
    pushReplacementNamed(this.route);
    return null;
  }
}
