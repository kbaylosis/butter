import 'package:butter_cli/src/generator.dart';
import 'package:recase/recase.dart';

import 'action.dart';
import 'page.dart';
import 'paths.dart';
import 'template_engine.dart';

class Module extends Generator {
  Module(String? name, String destination) : super(name, destination);

  void generate() {
    var src = Paths.getPubCacheDir();

    print('[Main ${ReCase(name!).titleCase} file]');
    TemplateEngine().convert('$src/$srcModulePath/noname.template',
        '$destModulePath/$name.dart', templates);

    Action(name, destination).generate('sample', name!);
    Page(name, destination).generate(name!);
  }
}
