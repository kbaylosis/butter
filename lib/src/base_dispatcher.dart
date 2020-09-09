import 'base_ui_model.dart';

/// A base interface for dispatching actions to the [Store]
abstract class BaseDispatcher {
  /// Sends an anonymous action given the data of a model of type [BaseUIModel]
  ///
  /// The key used for the model must be guaranteed as unique by the developer
  /// across the whole app. Setting [overwrite] to true forces [dispatchModel] not to
  /// reuse any portion of the [Model] in the [Store].
  void dispatchModel<Model extends BaseUIModel>(
      Model defaultModel, void Function(Model m) f,
      [bool overwrite = false]);

  /// Sends an anonymous action given the data of a model of type [BaseUIModel]
  ///
  /// The key used for the model must be guaranteed as unique by the developer
  /// across the whole app. Setting [overwrite] to true forces [dispatchModel] not to
  /// reuse any portion of the [Model] in the [Store].
  ///
  /// Returns a [Future<void>]
  Future<void> dispatchFutureModel<Model extends BaseUIModel>(
      Model defaultModel, void Function(Model m) f,
      [bool overwrite = false]);
}
