// ignore_from_file: avoid_print
import 'dart:async';

import 'package:conduit/conduit.dart';
// ignore: implementation_imports
import 'package:conduit/src/db/postgresql/postgresql_query.dart';
// ignore: implementation_imports
import 'package:conduit/src/db/postgresql/query_builder.dart';

//
// The PostgresQueryReduce in
// https://github.com/stablekernel/aqueduct/blob/master/aqueduct/lib/src/db/postgresql/postgresql_query_reduce.dart
// lacks consideration of queries with joins thus this class
//
class ReducerQuery<T extends ManagedObject> implements QueryReduceOperation<T> {
  ReducerQuery(
    Query<T> query, {
    this.returnAllFields = false,
    this.returnAllRows = false,
  }) : _query = query as PostgresQuery<T>;

  final bool returnAllFields;
  final bool returnAllRows;
  final PostgresQuery<T> _query;

  @override
  Future<double?> average(num? Function(T object) selector) =>
      _execute('avg(${_columnName(selector)})::float');

  @override
  Future<int> count() async {
    final result = await _execute<int>('count(*)');
    if (result == null) {
      throw QueryException.transport('Count operation returned a null!');
    }

    return result;
  }

  @override
  Future<U?> maximum<U>(U? Function(T object) selector) =>
      _execute('max(${_columnName(selector)})');

  @override
  Future<U?> minimum<U>(U? Function(T object) selector) =>
      _execute('min(${_columnName(selector)})');

  @override
  Future<U?> sum<U extends num>(U? Function(T object) selector) =>
      _execute('sum(${_columnName(selector)})');

  Future<U?> perform<U>(String function) => _execute(function);

  Future<List<List<dynamic>>> performExpectRows(String function,
          {int limit = 0}) =>
      _executeExpectRows(function, limit: limit);

  String _columnName(dynamic Function(T object) selector) =>
      _query.entity.identifyAttribute(selector).name;

  Future<U?> _execute<U>(String function) async {
    // ignore: avoid_print
    print('ReducerQuery::_execute');
    final builder = PostgresQueryBuilder(_query);
    final buffer = StringBuffer();
    buffer.write('SELECT $function ');
    buffer.write('FROM ${builder.sqlTableName} ');

    if (builder.containsJoins) {
      buffer.write('${builder.sqlJoin} ');
    }

    if (builder.sqlWhereClause != null) {
      buffer.write('WHERE ${builder.sqlWhereClause} ');
    }

    final rawQuery = buffer.toString();
    // ignore: avoid_print
    print(rawQuery);

    final store = _query.context.persistentStore as PostgreSQLPersistentStore;
    final connection = await store.executionContext;
    try {
      final result = await connection
          ?.query(rawQuery, substitutionValues: builder.variables)
          .timeout(Duration(seconds: _query.timeoutInSeconds));
      return (returnAllFields ? result?.first : result?.first.first) as U?;
    } on TimeoutException catch (e) {
      throw QueryException.transport('timed out connecting to database',
          underlyingException: e);
    }
  }

  Future<List<List<dynamic>>> _executeExpectRows(String function,
      {int limit = 0}) async {
    // ignore: avoid_print
    print('ReducerQuery::_execute');
    final builder = PostgresQueryBuilder(_query);
    final buffer = StringBuffer();
    buffer.write('SELECT $function ');
    buffer.write('FROM ${builder.sqlTableName} ');

    if (builder.containsJoins) {
      buffer.write('${builder.sqlJoin} ');
    }

    if (builder.sqlWhereClause != null) {
      buffer.write('WHERE ${builder.sqlWhereClause} ');
    }

    if (limit == 0) {
      buffer.write('LIMIT $limit ');
    }

    final rawQuery = buffer.toString();
    // ignore: avoid_print
    print(rawQuery);

    final store = _query.context.persistentStore as PostgreSQLPersistentStore;
    final connection = await store.executionContext;
    try {
      return await connection
              ?.query(rawQuery, substitutionValues: builder.variables)
              .timeout(Duration(seconds: _query.timeoutInSeconds)) ??
          [];
    } on TimeoutException catch (e) {
      throw QueryException.transport('timed out connecting to database',
          underlyingException: e);
    }
  }
}
