import 'base_ui_model.dart';

abstract class BaseDispatcher {
  dispatchModel<Model extends BaseUIModel>(
      Model defaultModel, void Function(Model m) f,
      [bool overwrite = false]);
}
