import 'app_state.dart';
import 'base_ui_model.dart';

/// Interface definition for the [Store]
///
/// Use this for entities needing to implement [Store] operations
abstract class BaseStoreUtils {
  /// Reads a model of type [BaseUIModel] from the store
  Model? read<Model extends BaseUIModel>(Model defaultModel);

  /// Modifies the data of the model of type [BaseUIModel] stored the store
  ///
  /// The key used for the model must be guaranteed as unique by the developer
  /// across the whole app. Setting [overwrite] to true forces [mutate] not to
  /// reuse any portion of the [Model] in the [Store].
  Model mutate<Model extends BaseUIModel>(
      Model defaultModel, void Function(Model m) f,
      [bool overwrite = false]);

  /// Writes the data of the model of type [BaseUIModel] in the store
  ///
  /// The key used for the model must be guaranteed as unique by the developer
  /// across the whole app. Setting [overwrite] to true forces [write] not to
  /// reuse any portion of the [Model] in the [Store].
  AppState write<Model extends BaseUIModel>(
      Model defaultModel, void Function(Model m) f,
      [bool overwrite = false]);
}
