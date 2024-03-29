import 'package:conduit_core/conduit_core.dart';

class Auditable {
  @Column(nullable: true)
  DateTime? createdOn;

  @Column(nullable: true)
  int? createdById;

  @Column(nullable: true)
  DateTime? updatedOn;

  @Column(nullable: true)
  int? updatedById;

  @Column(nullable: true)
  DateTime? disabledOn;

  @Column(nullable: true)
  int? disabledById;
}
