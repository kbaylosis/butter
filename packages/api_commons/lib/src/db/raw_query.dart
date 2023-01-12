// ignore_from_file: avoid_print
import 'dart:async';

import 'package:conduit/conduit.dart';

//
// The PostgresQueryReduce in
// https://github.com/stablekernel/aqueduct/blob/master/aqueduct/lib/src/db/postgresql/postgresql_query_reduce.dart
// lacks consideration of queries with joins thus this class
//
class RawQuery {
  RawQuery(
    this.context, {
    this.timeoutInSeconds = 30,
  });

  final ManagedContext? context;
  final int timeoutInSeconds;

  Future<List<List<U>>> perform<U>(String query,
      {Map<String, dynamic>? variables}) async {
    final store = context!.persistentStore as PostgreSQLPersistentStore;
    final connection = await store.executionContext;
    try {
      final result = await connection!
          .query(query, substitutionValues: variables)
          .timeout(Duration(seconds: timeoutInSeconds));
      final retVal = <List<U>>[];
      for (final value in result) {
        final row = value.toList();
        final rowItems = <U>[];
        for (final cell in row) {
          rowItems.add(cell as U);
        }

        retVal.add(rowItems);
      }

      return retVal;
    } on TimeoutException catch (e) {
      throw QueryException.transport('timed out connecting to database',
          underlyingException: e);
    }
  }
}
