import 'dart:async';

import 'package:butter_commons/butter_commons.dart';
import 'package:conduit/conduit.dart';

import '../../butter_api_commons.dart';

class AuditableController<T extends ManagedObject> extends BasicController<T> {
  AuditableController(
      String routeName, ManagedContext context, AuthServer authServer)
      : super(routeName, context, authServer);

  @override
  FutureOr<T> performInsert(Query<T> query) async {
    final context = query.context;
    final T item = await super.performInsert(query);
    final map = item.asMap();

    await AuditUtils(request: request).post(
      context,
      refId: map['id'] as int,
      entity: query.entity,
      operation: ResourceOperation.create,
      details: {
        'raw': query.values.asMap(),
        'new': map,
      },
    );

    return item;
  }

  @override
  FutureOr<T?> performUpdate(String id, Query<T> query) async {
    final context = query.context;
    final item = await query.fetchOne();
    if (item == null) {
      throw RequestNotAllowedException.code(BaseErrorCode.operationNotAllowed);
    }

    final map = item.asMap();
    final updated = await super.performUpdate(id, query);

    await AuditUtils(request: request).post(
      context,
      refId: map['id'] as int,
      entity: query.entity,
      operation: ResourceOperation.update,
      details: {
        'raw': query.values.asMap(),
        'old': map,
        'new': updated?.asMap(),
      },
    );

    return updated;
  }

  @override
  FutureOr<int?> performDelete(String id, Query<T> query) async {
    final context = query.context;
    final item = await query.fetchOne();
    final map = item?.asMap() ?? {};

    await AuditUtils(request: request).post(
      context,
      refId: map['id'] as int,
      entity: query.entity,
      operation: ResourceOperation.delete,
      details: {
        'old': map,
      },
    );

    return super.performDelete(id, query);
  }
}
