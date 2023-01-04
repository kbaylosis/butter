import 'dart:io';

import 'package:mustache_template/mustache_template.dart';

import 'templates.dart';

class TemplateEngine {
  TemplateEngine({this.quiet = false});

  final bool quiet;

  void convert(String src, String dest, Templates? templates) {
    var srcFile = File(src);
    if (!srcFile.existsSync()) {
      throw FileSystemException('File does not exist $src');
    }

    var sourceData = srcFile.readAsStringSync();
    var template = Template(sourceData);

    var output =
        templates == null ? sourceData : template.renderString(templates.items);

    print(dest);
    var destFile = File(dest);
    if (destFile.existsSync()) {
      print('This will overwrite $dest.');
      if (!quiet) {
        do {
          stdout.write('Do you want to proceed? <y/n> ');
          var confirm = stdin.readLineSync()!;
          if (confirm.trim().toLowerCase() == 'y') {
            break;
          } else if (confirm.trim().toLowerCase() == 'n') {
            print('Skipped!');
            return;
          }
        } while (true);
      }
    }

    destFile.createSync(recursive: true);
    destFile.writeAsStringSync(output);
  }

  void copy(String src, String dest) => convert(src, dest, null);
}
