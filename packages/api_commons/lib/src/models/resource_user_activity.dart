import 'package:butter_commons/butter_commons.dart';
import 'package:conduit/conduit.dart';

import 'auditable.dart';
import 'basic_model.dart';

class ResourceUserActivity extends ManagedObject<_ResourceUserActivity>
    implements _ResourceUserActivity {}

@Table(name: 'user_activity')
class _ResourceUserActivity extends Auditable implements BasicModel {
  @override
  @primaryKey
  int? id;

  int? refId;

  String? resource;

  ResourceOperation? operation;

  Document? details;
}
