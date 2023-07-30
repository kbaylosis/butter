import 'package:flutter/material.dart';

abstract class BrandInfo {
  bool isDarkTheme = false;
  late BrandTheme _darkTheme;
  late BrandTheme _lightTheme;

  ThemeData get theme => brandTheme.theme;

  //
  // Light/Dark definitions
  //
  Color get dark => brandTheme.dark;
  Color get light => brandTheme.light;

  //
  // Color definitions
  //
  Map<int, Color> get primarySwatch => brandTheme.primarySwatch;
  Color get primary => brandTheme.primary;
  Color get info => brandTheme.info;
  Color get success => brandTheme.success;
  Color get danger => brandTheme.danger;
  Color get warning => brandTheme.warning;

  //
  // Gray definitions
  //
  Color get grayDarkest => brandTheme.grayDarkest;
  Color get grayDarker => brandTheme.grayDarker;
  Color get grayDark => brandTheme.grayDark;
  Color get gray => brandTheme.gray;
  Color get grayLight => brandTheme.grayLight;
  Color get grayLighter => brandTheme.grayLighter;

  BrandTheme get brandTheme => isDarkTheme ? _darkTheme : _lightTheme;
  BrandTheme getDarkTheme();
  BrandTheme getLightTheme();

  BrandInfo() {
    _darkTheme = getDarkTheme();
    _lightTheme = getLightTheme();
  }
}

abstract class BrandTheme {
  final String logoPath = '';

  late final ThemeData theme;

  final Map<int, Color> primarySwatch = {
    50: const Color.fromRGBO(255, 255, 255, 0.1),
    100: const Color.fromRGBO(255, 255, 255, 0.2),
    200: const Color.fromRGBO(255, 255, 255, 0.3),
    300: const Color.fromRGBO(255, 255, 255, 0.4),
    400: const Color.fromRGBO(255, 255, 255, 0.5),
    500: const Color.fromRGBO(255, 255, 255, 0.6),
    600: const Color.fromRGBO(255, 255, 255, 0.7),
    700: const Color.fromRGBO(255, 255, 255, 0.8),
    800: const Color.fromRGBO(255, 255, 255, 0.9),
    900: const Color.fromRGBO(255, 255, 255, 1),
  };

  final Color dark = const Color.fromRGBO(0, 0, 0, 1);
  final Color light = const Color.fromRGBO(255, 255, 255, 1);

  final Color primary = const Color.fromRGBO(255, 255, 255, 1);
  final Color info = const Color.fromRGBO(255, 255, 255, 1);
  final Color success = const Color.fromRGBO(255, 255, 255, 1);
  final Color danger = const Color.fromRGBO(255, 255, 255, 1);
  final Color warning = const Color.fromRGBO(255, 255, 255, 1);

  final Color grayDarkest = const Color.fromRGBO(5, 5, 5, 1); // 1.9%
  final Color grayDarker = const Color.fromRGBO(34, 34, 34, 1); // 13.5%
  final Color grayDark = const Color.fromRGBO(51, 51, 51, 1); // 20%
  final Color gray = const Color.fromRGBO(85, 85, 85, 1); // 33.5%
  final Color grayLight = const Color.fromRGBO(119, 119, 119, 1); // 46.7%
  final Color grayLighter = const Color.fromRGBO(204, 204, 204, 1); // 93.5%
  final Color grayLightest = const Color.fromRGBO(246, 246, 246, 1); // 96.75%
}
