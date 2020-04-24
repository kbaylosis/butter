import 'base_ui_model.dart';

abstract class BaseDispatcher {
  @deprecated
  dispatchAttribs(Map<String, dynamic> data);

  dispatchModel<Model extends BaseUIModel>(Model defaultModel, void Function(Model m) f);
}