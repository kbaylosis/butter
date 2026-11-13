import 'dart:async';

import 'package:flutter/material.dart';

import 'base_page_specs.dart';
import 'base_page_view.dart';

/// An implementation of the [BasePageView] using a [StatefulWidget]
///
/// It exposes methods that allow handling of a page when it is about to load or update,
/// and when loading produces an error. This makes it possible to run asynchronous
/// processes when a page loads or updates.
abstract class BaseStatefulPageView extends StatefulWidget
    implements BasePageView {
  final int animationDelay;

  BaseStatefulPageView({
    super.key,
    this.animationDelay = 1,
  });

  @override
  State<StatefulWidget> createState() => _BaseStatefulPageViewState();

  /// Called when a page is about to be loaded.
  ///
  /// [buildLoading] is called while waiting for the result of this function.
  ///
  /// Returns either a [Future<bool>] or [bool]. If [true] is returned, the page
  /// will load normally, otherwise, it will not proceed to calling [build].
  FutureOr<bool?> beforeLoad(BuildContext context) => true;

  /// Called when a page is about to be updated.
  ///
  /// Returns either a [Future<bool>] or [bool]. If [true] is returned, the page
  /// will update normally, otherwise, it will not proceed to calling [build].
  FutureOr<bool?> beforeUpdate(BuildContext context) => true;

  /// Called while waiting for the result of [beforeLoad]
  ///
  /// Returns the [Widget] to render on the page
  Widget buildLoading(BuildContext context) {
    return Scaffold();
  }

  /// Renders the 'normal' view of the page
  ///
  /// Returns an empty [Scaffold] by default.
  Widget build(BuildContext context, {bool loading = false}) => Scaffold();

  /// Renders the 'error' view of the page
  ///
  /// Returns an empty [Scaffold] by default.
  Widget buildError(BuildContext context) => Scaffold();

  /// The page specs of type [BasePageSpecs]
  @override
  BasePageSpecs? get specs => null;
}

/// The [State] implementation of [BaseStatefulPageView]
///
/// It manages the page cycle to make it possible for loading and update events
/// to be intercepted.
class _BaseStatefulPageViewState extends State<BaseStatefulPageView> {
  bool _loading = true;
  late Future<bool?>? _loadForm;

  /// Initializes [initialized] and [loadRetVal]
  @override
  void initState() {
    _loadForm = widget.animationDelay == 0
        ? Future.microtask(() => this._cycle(context))
        : Future.delayed(Duration(seconds: widget.animationDelay),
            () => this._cycle(context));
    super.initState();
  }

  /// Housekeeping of [_BaseStatefulPageViewState]
  @override
  void dispose() {
    super.dispose();
  }

  /// Builds the view of the page depending on its state (loading, updating or error)
  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _loadForm,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData || widget.animationDelay == 0) {
            return widget.build(context, loading: _loading);
          } else if (snapshot.hasError) {
            return widget.buildError(context);
          }

          return widget.buildLoading(context);
        },
      );

  /// Manages the page cycle
  ///
  /// Returns null if page loading or updating needs to be aborted
  Future<bool?> _cycle(BuildContext context) async {
    final result = await widget.beforeLoad(context);
    _loading = !(result ?? false);
    return result;
  }
}
