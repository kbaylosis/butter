import 'package:moor_flutter/moor_flutter.dart';

class Database {
  final String name;

  Database(this.name);

  FlutterQueryExecutor open() =>
      FlutterQueryExecutor.inDatabaseFolder(path: '$name.sqlite');
}
