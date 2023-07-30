import 'package:moor/moor_web.dart';

class Database {
  final String name;

  Database(this.name);

  open() => WebDatabase(name);
}
