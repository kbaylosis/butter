import 'package:recase/recase.dart';

class Templates {
  String name;

  Map<String, String>? _items;

  Map<String, String>? get items => _items;

  Templates(this.name) {
    _items = {
      'Noname': ReCase(name).pascalCase,
      'noname': ReCase(name).constantCase.toLowerCase(),
      'Sample': 'Sample',
    };
  }
}
