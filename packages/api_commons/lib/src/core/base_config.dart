import 'dart:io';

import 'package:conduit_core/conduit_core.dart';

class BaseConfig extends Configuration {
  BaseConfig(String path) : super.fromFile(File(path));

  String? api;

  String? appName;

  DatabaseConfiguration? database;

  bool? release;

  String? logLevel;

  String? apiUrl;

  String? apiKey;

  String? apiSecret;
}
