import 'package:async_redux/async_redux.dart';
import 'package:flutter/widgets.dart';

import 'app_state.dart';
import 'base_page_state.dart';
import 'base_page_view.dart';

/// Pairs the Page to its State
class BasePageConnector<PageState extends BasePageState,
    PageView extends BasePageView> extends StoreConnector<AppState, PageState> {
  /// A reference to an instance of the page for easy access to its [BasePageSpecs]
  final PageView? page;

  /// Creates a [BasePageConnector] to pair up a state object of type [BasePageState]
  /// with a page of type [BasePageView]
  ///
  /// Usage:
  /// ```
  /// class Todo extends BaseModule {
  ///   Todo()
  ///     : super(
  ///         routeName: '/todo',
  ///         routes: {
  ///           // This is the root route of the module ('/').
  ///           '/': BasePageConnector<InitState, InitPage>(
  ///             state: InitState(),
  ///             page: InitPage(),
  ///             getPage: (vm) => InitPage(model: vm.model),
  ///           ),
  ///           '/todo/add': BasePageConnector<TodoState, TodoPage>(
  ///             state: TodoState(),
  ///             page: TodoPage(),
  ///             getPage: (vm) => TodoPage(model: vm.model),
  ///           ),
  ///         },
  ///       );
  /// }
  /// ```
  BasePageConnector({
    required BasePageState state,
    required this.page,
    required PageView Function(PageState) getPage,
  }) : super(
          model: state,
          builder: (BuildContext context, PageState vm) => getPage(vm),
        );
}
