import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class BasePage extends StatefulWidget {
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Widget body;
  final List<PageDecorator?> Function(List<PageDecorator?> decors)? decorate;
  final bool darkAppBar;
  final List<PageDecorator?> decorators;
  final Widget? leading;
  final bool showAppBar;
  final bool showLeading;
  final bool showStatusBar;
  final Widget? title;

  const BasePage({
    super.key,
    this.actions,
    this.backgroundColor,
    required this.body,
    this.decorate,
    this.darkAppBar = false,
    this.decorators = const [],
    this.leading,
    this.showAppBar = true,
    this.showLeading = true,
    this.showStatusBar = true,
    this.title,
  });

  @override
  State<StatefulWidget> createState() => _BasePageState();

  AppBar? buildAppBar() => null;

  List<PageDecorator?> buildDecorators(BuildContext context) => [];

  void dismissKeyboard() =>
      SystemChannels.textInput.invokeMethod('TextInput.hide');
}

class _BasePageState extends State<BasePage> {
  @override
  void initState() {
    super.initState();

    widget.dismissKeyboard();
  }

  @override
  Widget build(BuildContext context) {
    final decorators = (widget.decorate == null
            ? widget.buildDecorators(context)
            : widget.decorate!(widget.buildDecorators(context)))
        .reversed;
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: widget.showAppBar
          ? (widget.buildAppBar() ??
              AppBar(
                actions: widget.actions,
                backgroundColor: widget.backgroundColor,
                leading: widget.showLeading ? widget.leading : Container(),
                leadingWidth: widget.showLeading ? 56.0 : 0,
                title: widget.title,
              ))
          : null,
      body: decorators.isEmpty
          ? widget.body
          : decorators.fold(
              widget.body,
              (body, decorator) => decorator == null
                  ? body
                  : decorator.build(context, child: body)),
    );
  }
}

abstract class PageDecorator {
  Widget? build(
    BuildContext context, {
    Widget? child,
  });
}
