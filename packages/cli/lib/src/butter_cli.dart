import 'dart:io';

import 'package:args/args.dart';
import 'package:io/io.dart';

import 'action.dart';
import 'config.dart';
import 'module.dart';
import 'page.dart';
import 'scaffolding.dart';

class ButterCLI {
  factory ButterCLI() => _instance;

  ButterCLI._internal();

  static final ButterCLI _instance = ButterCLI._internal();

  ExitCode perform([List<String>? arguments]) {
    try {
      final parser = ArgParser();
      parser.addOption('destination', abbr: 'd');
      parser.addFlag('help', abbr: 'h');
      parser.addOption('model', abbr: 'o');
      parser.addOption('module', abbr: 'm');
      parser.addOption('name', abbr: 'n');
      parser.addFlag('skeleton', abbr: 's');
      parser.addOption('type', abbr: 't');
      parser.addFlag('quiet', abbr: 'q');

      var results = parser.parse(arguments ?? []);
      String dest = results['destination'] ?? '.';

      print('Butter CLI ${Config.version == null ? '' : 'v${Config.version}'}');

      if (results['help']) {
        showHelp();
        return ExitCode.success;
      }

      if (results['skeleton']) {
        print('This will generate skeletal files of the butter framework in:');
        print(dest);
        print('');
        if (!results['quiet']) {
          do {
            stdout.write('Do you want to proceed? <y/n> ');
            var confirm = stdin.readLineSync()!;
            if (confirm.trim().toLowerCase() == 'y') {
              break;
            } else if (confirm.trim().toLowerCase() == 'n') {
              print('');
              print('---Generated nothing---');
              return ExitCode.noInput;
            }
          } while (true);
        }

        Scaffolding(dest, quiet: results['quiet']).generate();
      } else {
        String? type = results['type'];
        String? module = results['module'];
        String? name = results['name'];
        String? model = results['model'];
        var article = type == 'action' ? 'an' : 'a';

        if (type == null) {
          showHelp();
          return ExitCode.usage;
        }

        print('This will generate $article $type in your butter project in:');
        print(dest);
        print('');
        if (!results['quiet']) {
          do {
            stdout.write('Do you want to proceed? <y/n> ');
            var confirm = stdin.readLineSync()!;
            if (confirm.trim().toLowerCase() == 'y') {
              break;
            } else if (confirm.trim().toLowerCase() == 'n') {
              print('');
              print('---Generated nothing---');
              return ExitCode.noInput;
            }
          } while (true);
        }

        switch (type) {
          case 'module':
            Module(module, dest).generate();
            break;
          case 'page':
            Page(module, dest).generate(name!);
            break;
          case 'action':
            Action(module, dest).generate(name!, model!);
            break;
          default:
            print('');
            print('---Generated nothing---');
            showHelp();
            return ExitCode.usage;
        }
      }

      showLogo();
      print('');
      print('Success! Happy coding! •ᴗ•');
      print('');

      return ExitCode.success;
    } catch (e) {
      print('');
      print('Something went wrong... (╥_╥)');
      print('');
      print(e);
      print('');
      return ExitCode.ioError;
    }
  }

  void showLogo() {
    print('');
    print(
        './:::::::.   .+::: ./::: `/::::::::/  -+::::::::- ./::::::::/  -+:::::::-`');
    print(
        '+y-./+/:./.  ss..+ ss..+ +s+++-.:+// .ys++:.-++/. oy-./++++// `so.-++++--+');
    print(
        '+y-.+++/.::  ss..+ so..+ `..+s:.o-.   ..:so.:/.`  oy-.++++++` .so.-+/os-.+');
    print(
        '+s-.:///:-+` ss..+ yo..+    +s:.o       .so.::    oy-.:::::+` .so..::---/-');
    print(
        '+y-.++oo/./. ss-.+-o+.-/    +s:.o       .s+.::    oy-.+oooo:- .so.-ooo--+ ');
    print(
        '+s:::::::::  +s+/::::::`    +s/:o       .so:/-    oy::::::::+ .so:/:+s+://');
    print(
        ':///////-`   `-/////:`      -//:`       `///.     :////////:` `///- `///:`');
    print('');
  }

  void showHelp() {
    print('Usage: butter_cli [<options>] --destination <destination>');
    print('');
    print('Generates the butter framework scaffolding.');
    print('');
    print('Options:');
    print('--help or -h');
    print('  Show this information');
    print('--model or -o');
    print(
        '  The name of the default model to use usually in generating an action. Use a lowercase_with_underscores.');
    print('--module or -m');
    print('  The name of the module. Use a lowercase_with_underscores.');
    print('--name or -n');
    print(
        '  The name of the object under a module. Specify this when generating');
    print('  a page or an action. Use a lowercase_with_underscores.');
    print('--skeleton or -s');
    print('  Generates the skeletal files of the framework under lib and test');
    print('--type <item> or -t <item>');
    print('  Where <item> is any of: module, page, action.');
    print(
        '  When generating a page. A state and model is provided along with it.');
    print('');
    print('To generate a project skeleton: ');
    print(' butter_cli -s -d /path/to/project');
    print('');
    print('To generate a module: ');
    print(' butter_cli -t module -m home -d /path/to/project');
    print('');
    print('To generate a page: ');
    print(' butter_cli -t page -m profile -n edit_profile -d /path/to/project');
    print('');
    print('To generate an action: ');
    print(
        ' butter_cli -t action -m profile -o user_profile -n edit_profile -d /path/to/project');
    print('');
  }
}
