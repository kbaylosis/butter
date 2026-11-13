import 'package:avoid_keyboard/avoid_keyboard.dart';
import 'package:butter/butter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../butter_toolkit.dart';
import '../../utils/screens.dart';
import '../highlight_text.dart';
import 'footer.dart';
import 'header.dart';

class StandardPage extends StatefulWidget {
  final List<Widget>? actions;
  final bool allowBack;
  final bool allowExit;
  final bool avoidKeyboard;
  final bool center;
  final bool centerContent;
  final bool centerTitle;
  final bool darkAppBar;
  final Widget? footer;
  final EdgeInsets innerPadding;
  final PageType type;
  final double? height;
  final Widget? leading;
  final bool loading;
  final EdgeInsets outerPadding;
  final Future<bool> Function()? onBackPressed;
  final Future<bool> Function()? onExitPressed;
  final EdgeInsets padding;
  final bool transparentAppBar;
  final bool scrollable;
  final bool showAppBar;
  final bool showHeader;
  final bool showFooter;
  final bool showLoading;
  final String title;
  final double? width;
  //
  final Widget? body;

  const StandardPage({
    super.key,
    this.actions,
    this.allowBack = true,
    this.allowExit = false,
    this.avoidKeyboard = true,
    this.center = false,
    this.centerContent = false,
    this.centerTitle = false,
    this.darkAppBar = false,
    this.footer,
    this.innerPadding = const EdgeInsets.all(20),
    this.type = PageType.system,
    this.height,
    this.leading,
    this.loading = false,
    this.outerPadding = const EdgeInsets.all(20),
    this.onBackPressed,
    this.onExitPressed,
    this.padding = const EdgeInsets.fromLTRB(0, 10, 0, 0),
    this.scrollable = true,
    this.showAppBar = false,
    this.showHeader = false,
    this.showFooter = false,
    this.showLoading = true,
    this.title = '',
    this.transparentAppBar = false,
    this.width,
    //
    this.body,
  });

  @override
  State<StatefulWidget> createState() => _StandardPageState();

  static bool applyPageType({
    required BuildContext context,
    PageType type = PageType.system,
  }) =>
      type == PageType.container ||
      (type == PageType.system && (kIsWeb && !Screens(context).isMobile));

  static dismissKeyboard() =>
      SystemChannels.textInput.invokeMethod('TextInput.hide');

  static void updateAppbar(bool darkAppBar) => Future.delayed(
      const Duration(milliseconds: 500),
      () => SystemChrome.setSystemUIOverlayStyle(
          darkAppBar ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark));
}

class _StandardPageState extends State<StandardPage> {
  @override
  void initState() {
    super.initState();

    StandardPage.updateAppbar(widget.darkAppBar);
    StandardPage.dismissKeyboard();
  }

  @override
  Widget build(BuildContext context) => _avoidKeyboard(
        child: _scrollable(
          child: _outerContainer(
            context: context,
            child: _innerContainer(
              context: context,
              child: Column(
                children: List.castFrom<Widget?, Widget>([
                  _appBar(context),
                  _loading(context),
                  _contentContainer(
                    context: context,
                    child: widget.body,
                  ),
                ]..removeWhere((element) => element == null)),
              ),
            ),
          ),
        ),
      );

  Widget _avoidKeyboard({required Widget child}) =>
      widget.avoidKeyboard && !Screens.isWeb
          ? AvoidKeyboard(child: child)
          : child;

  Widget? _header(BuildContext context) => widget.showHeader &&
          StandardPage.applyPageType(context: context, type: widget.type)
      ? Container(
          margin: const EdgeInsets.only(bottom: 30),
          child: Header(
            logoPath: ButterToolkit().logoPath,
            title: ButterToolkit().title,
          ),
        )
      : null;

  Widget? _footer(BuildContext context) => widget.showFooter &&
          StandardPage.applyPageType(context: context, type: widget.type)
      ? Container(
          margin: const EdgeInsets.only(top: 30),
          child: const Footer(),
        )
      : null;

  Widget _outerContainer({required BuildContext context, Widget? child}) =>
      Container(
        padding: StandardPage.applyPageType(context: context, type: widget.type)
            ? widget.outerPadding
            : null,
        child: Column(
          children: List.castFrom<Widget?, Widget>([
            _header(context),
            StandardPage.applyPageType(context: context, type: widget.type)
                ? _center(child: child ?? Container())
                : child,
            _footer(context),
          ]..removeWhere((element) => element == null)),
        ),
      );

  Widget? _loading(BuildContext context) => Container(
        alignment: Alignment.topCenter,
        color: Colors.transparent,
        height: widget.showLoading ? 5 : null,
        margin: const EdgeInsets.only(top: 1),
        child: widget.showLoading && widget.loading
            ? const LinearProgressIndicator()
            : null,
      );

  Widget _center({required Widget child}) => Column(
        mainAxisAlignment:
            widget.center ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [widget.center ? Center(child: child) : child],
      );

  Widget _innerContainer({required BuildContext context, Widget? child}) =>
      Container(
        decoration:
            StandardPage.applyPageType(context: context, type: widget.type)
                ? BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    color: ButterToolkit().brandInfo.light,
                  )
                : BoxDecoration(color: ButterToolkit().brandInfo.light),
        height: widget.height == null
            ? null
            : widget.height! +
                (StandardPage.applyPageType(context: context, type: widget.type)
                    ? 0
                    : 200),
        padding: widget.innerPadding,
        width: widget.width,
        child: child,
      );

  Widget? _appBar(BuildContext context) => widget.showAppBar
      ? Column(
          children: [
            AppBar(
              actions: widget.allowExit
                  ? ([
                      ...(widget.actions ?? []),
                      TextButton.icon(
                        icon: Icon(
                          MaterialIcons.exit_to_app,
                          color: ButterToolkit().brandInfo.dark,
                          size: 24,
                        ),
                        label: Text(
                          '',
                          style: TextStyle(
                              color: ButterToolkit().brandInfo.info,
                              fontSize: 17),
                        ),
                        onPressed: () async {
                          Butter.d('Pressed exit!');
                          StandardPage.updateAppbar(widget.darkAppBar);
                          StandardPage.dismissKeyboard();

                          if (widget.onExitPressed == null) {
                            _handlePostExitPressed();
                          } else {
                            widget.onExitPressed?.call()
                              .then((value) => value ? _handlePostExitPressed() : null);
                          }
                        },
                      )
                    ])
                  : widget.actions,
              backgroundColor: Colors.white,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarBrightness:
                    widget.darkAppBar ? Brightness.light : Brightness.dark,
              ),
              centerTitle: widget.centerTitle,
              elevation: 1,
              leading: widget.allowBack
                  ? TextButton.icon(
                      icon: Icon(
                        MaterialIcons.arrow_back,
                        color: ButterToolkit().brandInfo.dark,
                        size: 24,
                      ),
                      label: Text(
                        '',
                        style: TextStyle(
                            color: ButterToolkit().brandInfo.info,
                            fontSize: 17),
                      ),
                      onPressed: () async {
                        Butter.d('Pressed back!');
                        StandardPage.updateAppbar(widget.darkAppBar);
                        StandardPage.dismissKeyboard();

                        if (widget.onBackPressed == null) {
                            _handlePostBackPressed();
                        } else {
                          widget.onBackPressed?.call()
                            .then((value) => value ? _handlePostBackPressed() : null);
                        }
                      },
                    )
                  : Container(),
              leadingWidth:
                  (widget.allowBack || widget.leading != null) ? 100 : 0,
              toolbarHeight: kToolbarHeight,
              title: HighlightText(
                widget.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        )
      : null;

  Widget _scrollable({Widget? child}) => widget.scrollable &&
          StandardPage.applyPageType(context: context, type: widget.type)
      ? SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: child,
        )
      : (child ?? Container());

  Widget _contentContainer({required BuildContext context, Widget? child}) =>
      widget.height == null
          ? _content(context: context, child: child)
          : Expanded(
              flex: 1,
              child: _content(context: context, child: child),
            );

  Widget _content({required BuildContext context, Widget? child}) => Material(
        child: Container(
          padding: widget.padding,
          child: Stack(
            children: List.castFrom<Widget?, Widget>([
              Column(
                mainAxisAlignment: widget.centerContent
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  child ?? Container(),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: widget.footer,
              ),
            ]..removeWhere((element) => element == null)),
          ),
        ),
      );

  void _handlePostExitPressed() async {
    Butter.d('Called onExitPressed successfully!');
    final result =
        await Navigator.of(context).maybePop();
    Butter.d('Called maybePop: $result');
    if (!result && mounted) {
      // TODO: (1) Find a way that this doesn't happen
      // TODO: (2) Double check if TODO (1) still occurs
      Navigator.of(context).pushNamed('/_/dashboard');
    }
  }

  void _handlePostBackPressed() async {
    Butter.d('Called onBackPressed successfully!');
    try {
      FocusScope.of(context).unfocus();
      // TODO: (1) Can produce the following error in iOS debug: routes.dart': Failed assertion: line 1408 pos 12: 'scope != null': is not true.
      // TODO: (2) Double check if TODO (1) still occurs
      final result =
          await Navigator.of(context).maybePop();
      Butter.d('Called maybePop: $result');
      if (!result && mounted) {
        // TODO: (1) Find a way that this doesn't happen
        // TODO: (2) Double check if TODO (1) still occurs
        Navigator.of(context).pushNamed('/_/dashboard');
      }
    } catch (e) {
      Butter.e(e);
    }
  }
}

enum PageType {
  none,
  container,
  system,
}
