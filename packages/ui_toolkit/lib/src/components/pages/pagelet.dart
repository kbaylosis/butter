import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../butter_toolkit.dart';
import '../clickable_icon.dart';
import '../highlight_text.dart';

class Pagelet extends StatelessWidget {
  final Widget Function()? buildLabel;
  final String? label;
  final bool loading;
  final void Function()? onBack;
  final void Function()? onClose;
  final EdgeInsetsGeometry padding;
  final Widget? child;

  const Pagelet({
    super.key,
    this.buildLabel,
    this.label = '',
    this.loading = false,
    this.padding = const EdgeInsets.all(10),
    this.onBack,
    this.onClose,
    this.child,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _mainControlBox(context),
                Container(
                  alignment: Alignment.center,
                  color: ButterToolkit().brandInfo.light,
                  height: 5,
                  margin: const EdgeInsets.only(top: 5),
                  child: loading ? const LinearProgressIndicator() : null,
                ),
                child ?? Container(),
              ],
            ),
          ),
        ),
      );

  Widget _mainControlBox(BuildContext context) =>
      (onBack == null && onClose == null)
          ? Container()
          : Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: ButterToolkit().brandInfo.gray,
                boxShadow: [
                  BoxShadow(
                    color: ButterToolkit().brandInfo.gray.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClickableIcon(
                        iconData: MaterialIcons.arrow_back,
                        color: ButterToolkit().brandInfo.info,
                        hide: onBack == null,
                        size: 20,
                        onPressed: onBack,
                      ),
                      const SizedBox(width: 10),
                      buildLabel == null
                          ? HighlightText(
                              label,
                              style:
                                  Theme.of(context).textTheme.headlineSmall!.apply(
                                        color: ButterToolkit().brandInfo.light,
                                      ),
                            )
                          : buildLabel!(),
                    ],
                  ),
                  ClickableIcon(
                    iconData: MaterialIcons.close,
                    color: ButterToolkit().brandInfo.info,
                    hide: onClose == null,
                    size: 20,
                    onPressed: onClose,
                  ),
                ],
              ),
            );
}
