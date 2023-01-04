import 'paths.dart';
import 'templates.dart';

class Generator {
  final String? name;
  final String destination;
  final String srcModulePath;
  final String destModulePath;

  Templates get templates => Templates(name!);

  Generator(this.name, this.destination)
      : srcModulePath = '${Paths.moduleScaffoldingPath}',
        destModulePath = '$destination/${Paths.modulePath}/$name';
}
