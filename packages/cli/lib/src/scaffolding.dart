import 'dart:io';

import 'package:io/io.dart';
import 'package:pub_cache/pub_cache.dart';

import 'paths.dart';
import 'template_engine.dart';

class Scaffolding {
  Scaffolding(this.destination, {this.quiet = false});

  final String? destination;
  final bool quiet;

  void generate() {
    _checkPubspec();

    var src = Paths.getPubCacheDir();
    var engine = TemplateEngine(quiet: quiet);

    print('Generating project skeleton... ');

    // lib
    engine.copy('$src/${Paths.libScaffoldingPath}/main.template',
        '$destination/${Paths.libPath}/main.dart');

    // lib/app
    engine.copy('$src/${Paths.libScaffoldingPath}/app/app.template',
        '$destination/${Paths.libPath}/app/app.dart');
    engine.copy('$src/${Paths.libScaffoldingPath}/app/routes.template',
        '$destination/${Paths.libPath}/app/routes.dart');
    engine.copy('$src/${Paths.libScaffoldingPath}/app/theme.template',
        '$destination/${Paths.libPath}/app/theme.dart');

    // lib/config
    engine.copy('$src/${Paths.libScaffoldingPath}/config/app_config.template',
        '$destination/${Paths.libPath}/config/app_config.dart');

    // lib/data
    print('$destination/${Paths.libPath}/data');
    copyPathSync('$src/${Paths.libScaffoldingPath}/data',
        '$destination/${Paths.libPath}/data');

    // lib/modules
    print('$destination/${Paths.libPath}/modules');
    copyPathSync('$src/${Paths.libScaffoldingPath}/modules',
        '$destination/${Paths.libPath}/modules');

    // lib/services
    print('$destination/${Paths.libPath}/services');
    copyPathSync('$src/${Paths.libScaffoldingPath}/services',
        '$destination/${Paths.libPath}/services');

    // lib/utils
    engine.copy(
        '$src/${Paths.libScaffoldingPath}/utils/sub_module_page_specs.template',
        '$destination/${Paths.libPath}/utils/sub_module_page_specs.dart');

    // test
    print('$destination/${Paths.testPath}');
    engine.copy('$src/${Paths.testScaffoldingPath}/widget_test.template',
        '$destination/${Paths.testPath}/widget_test.dart');

    // pubspec.yaml
    print('$destination/pubspec.yaml');
    _updatePubspec();

    print('✓ Done');
  }

  void _checkPubspec() {
    var srcFile = File('$destination/pubspec.yaml');
    if (!srcFile.existsSync()) {
      throw 'The specified destination (${srcFile.path}) must contain a dart project!';
    }

    final sourceData = srcFile.readAsStringSync();
    if (!sourceData.contains('sdk: flutter')) {
      throw 'The specified project must use flutter!';
    }
  }

  void _updatePubspec() {
    var srcFile = File('$destination/pubspec.yaml');
    var sourceData = srcFile.readAsStringSync();

    if (sourceData.contains('butter:')) {
      return;
    }

    final butterVersion =
        PubCache().getLatestVersion('butter')?.version.toString();
    sourceData = sourceData.replaceFirst(
        'sdk: flutter',
        'sdk: flutter\n'
            '  butter: ^$butterVersion'
            '  butter_commons: ^$butterVersion');

    srcFile.writeAsStringSync(sourceData);
  }
}
