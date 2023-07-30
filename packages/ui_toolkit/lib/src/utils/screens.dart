import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

class Screens {
  final BuildContext context;

  Screens(this.context);

  static const desktop = 1280.0;
  static const tablet = 720.0;
  static const mobile = 480.0;
  static const drawerWidth = 400.0;

  Size get screenSize => MediaQuery.of(context).size;
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;

  double get contentWidth =>
      MediaQuery.of(context).size.width - (isDesktop ? drawerWidth : 0);

  bool get isDesktop => MediaQuery.of(context).size.width >= desktop;

  bool get isTablet =>
      MediaQuery.of(context).size.width > mobile &&
      MediaQuery.of(context).size.width < desktop;

  bool get isMobile =>
      isIOS || isAndroid || MediaQuery.of(context).size.width <= tablet;

  bool get isWebMobile => isWeb && isMobile;

  bool get isNativeMobile => !isWeb && isMobile;

  static bool get isIOS => UniversalPlatform.isIOS;

  static bool get isAndroid => UniversalPlatform.isAndroid;

  static bool get isWeb => UniversalPlatform.isWeb;
}
