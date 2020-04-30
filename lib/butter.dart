/// A thin application framework for flutter making use of async_redux.
///
/// Butter allows you to structure your app into modules and submodules where
/// each module is composed of pages, states, models and actions as already
/// introduced by [redux](https://redux.js.org/).
///
/// Most common classes used to structure the app are: [BaseAction], [BaseModule],
/// [BasePageState], [BaseStatefulPageView], and [BaseStatelessPageView]
///
/// References:
/// * [butter_cli](https://pub.dev/packages/butter_cli)
/// * [async_redux](https://pub.dev/packages/async_redux/)
/// * [redux](https://redux.js.org/)
library butter;

export 'src/app_state.dart';
export 'src/base_action.dart';
export 'src/base_dispatcher.dart';
export 'src/base_module.dart';
export 'src/base_navigator.dart';
export 'src/base_page_connector.dart';
export 'src/base_page_specs.dart';
export 'src/base_page_state.dart';
export 'src/base_page_transition.dart';
export 'src/base_page_view.dart';
export 'src/base_routes.dart';
export 'src/base_stateful_page_view.dart';
export 'src/base_stateless_page_view.dart';
export 'src/base_ui_model.dart';
export 'src/page_arguments.dart';
