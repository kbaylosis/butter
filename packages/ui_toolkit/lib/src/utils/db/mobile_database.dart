import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart' show getDatabasesPath;

class Database {
  final String name;

  Database(this.name);

  LazyDatabase open() => LazyDatabase(() async {
        final dbFolder = await getDatabasesPath();
        final file = File(p.join(dbFolder, 'db.sqlite'));
        return NativeDatabase(file);
      });
}
