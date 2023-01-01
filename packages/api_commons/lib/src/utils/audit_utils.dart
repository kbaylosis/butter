import 'dart:convert';

import 'package:butter_commons/butter_commons.dart';
import 'package:conduit/conduit.dart';

import '../models/auditable.dart';
import '../models/resource_user_activity.dart';

class AuditUtils {
  AuditUtils({this.request});

  final Request? request;

  Query<T> loadAuditData<T extends ManagedObject>({
    required Query<T> query,
    bool insert = false,
  }) {
    loadData(data: query.values, insert: insert);
    return query;
  }

  Query<T> query<T extends ManagedObject>(
    ManagedContext context, {
    T? values,
    bool insert = false,
  }) =>
      load(query: Query<T>(context, values: values), insert: insert);

  Query<T> load<T extends ManagedObject>({
    required Query<T> query,
    bool insert = false,
  }) {
    final data = query.values;

    if (data is Auditable) {
      final d = data as Auditable;
      if (insert) {
        d
          ..createdOn = DateTime.now()
          ..createdById = request?.authorization?.ownerID ?? 0;
      }

      d
        ..updatedOn = DateTime.now()
        ..updatedById = request?.authorization?.ownerID ?? 0;
    }

    return query;
  }

  T? loadData<T extends ManagedObject>({
    T? data,
    bool insert = false,
  }) {
    if (data is Auditable) {
      final d = data as Auditable;
      if (insert) {
        d
          ..createdOn = DateTime.now()
          ..createdById = request?.authorization?.ownerID ?? 0;
      }

      d
        ..updatedOn = DateTime.now()
        ..updatedById = request?.authorization?.ownerID ?? 0;
    }

    return data;
  }

  bool isCurrentUser(int id) => id == request?.authorization?.ownerID;

  int? get userId => request?.authorization?.ownerID;

  Future<void> post(
    ManagedContext context, {
    required ManagedEntity entity,
    required int refId,
    ResourceOperation? operation,
    Map<String, dynamic>? details,
  }) =>
      (query<ResourceUserActivity>(context, insert: true)
            ..values.refId = refId
            ..values.resource = entity.name
            ..values.operation = operation
            ..values.details = Document(jsonEncode(details)))
          .insert();
}
