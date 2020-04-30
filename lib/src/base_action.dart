import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/widgets.dart';

import 'app_state.dart';
import 'base_dispatcher.dart';
import 'base_navigator.dart';
import 'base_store_utils.dart';
import 'base_ui_model.dart';

/// A [ReduxAction] wrapper for Action objects and provides all necessary utilities
/// needed to interact with the [Store] and the [Navigator].
class BaseAction extends ReduxAction<AppState>
    implements BaseDispatcher, BaseNavigator, BaseStoreUtils {
  var _data = {};

  /// Builds anonymous actions
  ///
  /// This is useful within the butter library and using it outside is highly discouraged.
  BaseAction.build(Map<String, dynamic> data) : _data = data;

  /// An override to the [ReduxAction.reduce] to allow processing of anonymous actions
  @override
  FutureOr<AppState> reduce() => state.copyAll(this._data);

  /// Reads a model of type [BaseUIModel] from the store
  ///
  /// The key used for the model must be guaranteed as unique by the developer
  /// across the whole app.
  @override
  Model read<Model extends BaseUIModel>(Model defaultModel) =>
      this.store.state.read(defaultModel.$key, defaultModel);

  /// Modifies the data of the model of type [BaseUIModel] stored the store
  ///
  /// The key used for the model must be guaranteed as unique by the developer
  /// across the whole app.
  @override
  Model mutate<Model extends BaseUIModel>(
      Model defaultModel, void Function(Model m) f,
      [bool overwrite = false]) {
    var d = overwrite ? defaultModel : read(defaultModel).clone();
    f(d);

    return d;
  }

  /// Writes the data of the model of type [BaseUIModel] in the store
  ///
  /// The key used for the model must be guaranteed as unique by the developer
  /// across the whole app.
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
  /// across the whole app.
  @override
  dispatchModel<Model extends BaseUIModel>(
          Model defaultModel, void Function(Model m) f,
          [bool overwrite = false]) =>
      super.dispatch(BaseAction.build({
        defaultModel.$key: mutate(defaultModel, f, overwrite),
      }));

  /// Removes the current route from the navigation stack
  @override
  void pop() => dispatch(NavigateAction.pop());

  /// Puts a route on top of the navigation stack
  @override
  void pushNamed(
    String route, {
    Object arguments,
  }) =>
      dispatch(NavigateAction.pushNamed(route, arguments: arguments));

  /// Replaces the current route with the specified route
  @override
  void pushReplacementNamed(
    String route, {
    Object arguments,
  }) =>
      dispatch(
          NavigateAction.pushReplacementNamed(route, arguments: arguments));

  /// Adds a route into the navigation stack and removes everything else
  @override
  void pushNamedAndRemoveAll(
    String route, {
    Object arguments,
  }) =>
      dispatch(
          NavigateAction.pushNamedAndRemoveAll(route, arguments: arguments));

  /// Adds a route into the navigation stack and removes everything until the condition
  /// specified in [predicate] is satisfied
  @override
  void pushNamedAndRemoveUntil(
    String route, {
    Object arguments,
    RoutePredicate predicate,
  }) =>
      dispatch(NavigateAction.pushNamedAndRemoveUntil(
        route,
        arguments: arguments,
        predicate: predicate,
      ));

  /// Removes all routes in the navigation stack until the condition specified in
  /// [predicate] is satisfied
  @override
  void popUntil(String route) => dispatch(NavigateAction.popUntil(route));

  /// Puts a route object on top of the navigation stack
  @override
  void push(
    Route route, {
    Object arguments,
  }) =>
      dispatch(NavigateAction.push(route, arguments: arguments));
}
