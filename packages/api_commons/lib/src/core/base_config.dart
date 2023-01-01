import 'dart:io';

import 'package:conduit/conduit.dart';

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
