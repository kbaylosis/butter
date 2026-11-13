import 'dart:async';
import 'dart:convert';

import 'package:conduit_core/conduit_core.dart';

import '../../butter_api_commons.dart';

class BasicController<T extends ManagedObject> extends ManagedController<T>
    implements RouterManager<T> {
  BasicController(this.routeName, this.context, this.authServer)
      : super(context);

  @override
  final String routeName;

  final ManagedContext context;
  final AuthServer authServer;

  @override
  FutureOr<Query<T>> willInsertObjectWithQuery(Query<T> query) async {
    query.values.removePropertyFromBackingMap('id');
    return AuditUtils(request: request).load(query: query, insert: true);
  }

  @override
  FutureOr<Query<T>> willUpdateObjectWithQuery(Query<T> query) {
    query.values
        .removePropertiesFromBackingMap(['id', 'createdOn', 'createdById']);
    return AuditUtils(request: request).load(query: query);
  }

  @override
  FutureOr<Response> didFindObject(T object, Map<String, dynamic> summary) =>
      Response.ok(object, headers: {
        'access-control-expose-headers': 'x-total, x-summary',
        'x-total': 1,
        'x-summary': jsonEncode(summary),
      });

  @override
  FutureOr<Response> didFindObjects(
          List<T> objects, int? total, Map<String, dynamic> summary) =>
      Response.ok(objects, headers: {
        'access-control-expose-headers': 'x-total, x-summary',
        'x-total': total,
        'x-summary': jsonEncode(summary),
      });

  @override
  Future<void> init(ManagedContext? context) async {
    // No implementation
  }

  @override
  void build({
    required AuthServer authServer,
    required ManagedContext context,
    required String prefix,
    required Router router,
  }) {
    logger.fine('$prefix/$routeName/[:id]');
    router
        .route('$prefix/$routeName/[:id]')
        .link(() => Authorizer.bearer(authServer))!
        .link(() => this);
  }

  Query<U> addPredicate<U extends ManagedObject>(
      Query<U> query, QueryPredicate predicate) {
    if (query.predicate == null || (query.predicate?.format ?? '').isEmpty) {
      query.predicate = predicate;
    } else {
      query.predicate!.format =
          [query.predicate!.format, predicate.format].join(' AND ');
      query.predicate!.parameters.addAll(predicate.parameters);
    }

    logger.fine(query.predicate!.format);
    return query;
  }

  Query<U> addPredicates<U extends ManagedObject>(
      Query<U> query, List<QueryPredicate> predicates) {
    final formats = predicates.map((e) => e.format).join(' AND ');
    final params = predicates.fold<Map<String, dynamic>>({},
        (previousValue, element) => previousValue..addAll(element.parameters));

    if (query.predicate == null || (query.predicate?.format ?? '').isEmpty) {
      query.predicate!.format = formats;
    } else {
      query.predicate!.format =
          [query.predicate!.format, formats].join(' AND ');
    }

    query.predicate!.parameters.addAll(params);
    logger.fine(query.predicate!.format);
    return query;
  }
}
