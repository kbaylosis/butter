import 'package:drift/drift.dart';

abstract class DatabaseTable<D extends GeneratedDatabase, T extends TableInfo,
    R extends DataClass> {
  DatabaseTable(D db);

  Future<void> migrate(Migrator m, int from, int to);

  Future<R?> readOne() async => null;

  Future<R> writeOne(R data);

  Future<R> updateOne(String key, dynamic value);

  Future<int> clear();
}
