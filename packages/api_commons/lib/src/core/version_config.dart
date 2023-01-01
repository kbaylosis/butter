import 'dart:io';

import 'package:yaml/yaml.dart';

class VersionConfig {
  VersionConfig(String path) {
    final contents = File(path).readAsStringSync();
    yamlMap = loadYaml(contents) as Map;
  }

  Map yamlMap = {};

  String get name => yamlMap['name'].toString();

  String get description => yamlMap['description'].toString();

  String get version => yamlMap['version'].toString();
}
