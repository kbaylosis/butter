import 'app_state.dart';
import 'base_ui_model.dart';

abstract class BaseStoreUtils {
  Model read<Model extends BaseUIModel>(Model defaultModel);
  Model mutate<Model extends BaseUIModel>(Model defaultModel, void Function(Model m) f);
  AppState write<Model extends BaseUIModel>(Model defaultModel, void Function(Model m) f);
}