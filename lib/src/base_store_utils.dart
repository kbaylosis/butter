import 'app_state.dart';
import 'base_ui_model.dart';

abstract class BaseStoreUtils {
  Model read<Model extends BaseUIModel>(String key, Model defaultModel);
  Model mutate<Model extends BaseUIModel>(String key, void Function(Model m) f, Model defaultModel);
  AppState write<Model extends BaseUIModel>(String key, void Function(Model m) f, Model defaultModel);
}