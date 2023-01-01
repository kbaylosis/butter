import 'package:conduit/conduit.dart';

class Auditable {
  @Column(nullable: true)
  DateTime? createdOn;

  @Column(nullable: true)
  int? createdById;

  @Column(nullable: true)
  DateTime? updatedOn;

  @Column(nullable: true)
  int? updatedById;
}
