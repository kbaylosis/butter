import 'package:butter_toolkit/butter_toolkit.dart';
import 'package:flutter/material.dart';

class ContentWrapperDecor extends PageDecorator {
  final bool center;
  final double? height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? width;

  ContentWrapperDecor({
    this.center = true,
    this.height,
    this.margin,
    this.padding,
    this.width,
  });

  @override
  Widget? build(BuildContext context, {Widget? child}) {
    final body = Container(
      alignment: Alignment.center,
      height: height,
      margin: margin,
      padding: padding,
      width: width,
      child: child,
    );

    return center ? Center(child: body) : body;
  }
}
