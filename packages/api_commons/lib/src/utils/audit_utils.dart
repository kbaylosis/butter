import 'package:conduit_core/conduit_core.dart';

import '../models/auditable.dart';

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

  Future<T> post<T extends ManagedObject>(ManagedContext context,
          {required T values}) =>
      query<T>(context, insert: true, values: values).insert();
}
