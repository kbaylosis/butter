import 'package:async_redux/async_redux.dart';
import 'package:flutter/widgets.dart';

import 'app_state.dart';
import 'base_action.dart';
import 'base_dispatcher.dart';
import 'base_navigator.dart';
import 'base_store_utils.dart';
import 'base_ui_model.dart';

/// A [BaseModel] wrapper for State objects and provides all necessary utilities
/// needed to interact with the [Store] and the [Navigator].
abstract class BasePageState<Model extends BaseUIModel>
    extends BaseModel<AppState>
    implements BaseDispatcher, BaseNavigator, BaseStoreUtils {
  BasePageState();

  /// Builds the page based on the specified model
  BasePageState.build(Model m, void Function(Model m) f) {
    f(m);
  }

  /// Reads a model of type [BaseUIModel] from the store
  ///
  /// The key used for the model must be guaranteed as unique by the developer
  /// across the whole app.
  @override
  Model? read<Model extends BaseUIModel>(Model defaultModel) =>
      this.state.read(defaultModel.$key, defaultModel);

  /// Modifies the data of the model of type [BaseUIModel] stored the store
  ///
  /// The key used for the model must be guaranteed as unique by the developer
  /// across the whole app. Setting [overwrite] to true forces [mutate] not to
  /// reuse any portion of the [Model] in the [Store].
  @override
  Model mutate<Model extends BaseUIModel>(
      Model defaultModel, void Function(Model m) f,
      [bool overwrite = false]) {
    var d = overwrite ? defaultModel : read(defaultModel)!.clone();
    f(d);

    return d;
  }

  /// Writes the data of the model of type [BaseUIModel] in the store
  ///
  /// The key used for the model must be guaranteed as unique by the developer
  /// across the whole app. Setting [overwrite] to true forces [write] not to
  /// reuse any portion of the [Model] in the [Store].
  @override
  AppState write<Model extends BaseUIModel>(
          Model defaultModel, void Function(Model m) f,
          [bool overwrite = false]) =>
      this.state.copy(
            key: defaultModel.$key,
            value: mutate(defaultModel, f, overwrite),
          );

  /// Sends an anonymous action given the data of a model of type [BaseUIModel]
  ///
  /// The key used for the model must be guaranteed as unique by the developer
  /// across the whole app. Setting [overwrite] to true forces [dispatchModel] not to
  /// reuse any portion of the [Model] in the [Store].
  @override
  void dispatchModel<Model extends BaseUIModel>(
          Model defaultModel, void Function(Model m) f,
          [bool overwrite = false]) =>
      super.dispatch!(BaseAction.build({
        defaultModel.$key: mutate(defaultModel, f, overwrite),
      }));

  /// Sends an anonymous action given the data of a model of type [BaseUIModel]
  ///
  /// The key used for the model must be guaranteed as unique by the developer
  /// across the whole app. Setting [overwrite] to true forces [dispatchModel] not to
  /// reuse any portion of the [Model] in the [Store].
  ///
  /// Returns a [Future<void>]
  @override
  Future<void> dispatchFutureModel<Model extends BaseUIModel>(
          Model defaultModel, void Function(Model m) f,
          [bool overwrite = false]) =>
      super.dispatch!(BaseAction.build({
        defaultModel.$key: mutate(defaultModel, f, overwrite),
      }));

  /// Removes the current route from the navigation stack
  @override
  void pop() => dispatch!(NavigateAction.pop());

  /// Puts a route on top of the navigation stack
  @override
  void pushNamed(
    String route, {
    Object? arguments,
  }) =>
      dispatch!(NavigateAction.pushNamed(route, arguments: arguments));

  /// Replaces the current route with the specified route
  @override
  void pushReplacementNamed(
    String route, {
    Object? arguments,
  }) =>
      dispatch!(
          NavigateAction.pushReplacementNamed(route, arguments: arguments));

  /// Adds a route into the navigation stack and removes everything else
  @override
  void pushNamedAndRemoveAll(
    String route, {
    Object? arguments,
  }) =>
      dispatch!(
          NavigateAction.pushNamedAndRemoveAll(route, arguments: arguments));

  /// Adds a route into the navigation stack and removes everything until the condition
  /// specified in [predicate] is satisfied
  @override
  void pushNamedAndRemoveUntil(
    String route, {
    Object? arguments,
    RoutePredicate? predicate,
  }) =>
      dispatch!(NavigateAction.pushNamedAndRemoveUntil(
        route,
        predicate!,
        arguments: arguments,
      ));

  /// Removes all routes in the navigation stack until the condition specified in
  /// [predicate] is satisfied
  @override
  void popUntil(bool Function(Route<dynamic>) predicate) =>
      dispatch!(NavigateAction.popUntil(predicate));

  /// Puts a route object on top of the navigation stack
  @override
  void push(Route route) => dispatch!(NavigateAction.push(route));
}
