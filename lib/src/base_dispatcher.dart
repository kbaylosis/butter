import 'base_ui_model.dart';

/// A base interface for dispatching actions to the [Store]
abstract class BaseDispatcher {

  /// Sends an anonymous action given the data of a model of type [BaseUIModel]
  dispatchModel<Model extends BaseUIModel>(
      Model defaultModel, void Function(Model m) f,
      [bool overwrite = false]);
}
