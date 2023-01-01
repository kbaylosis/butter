import 'package:conduit/conduit.dart';
import 'package:conduit/managed_auth.dart';

import 'auditable.dart';
import 'basic_model.dart';

class ResourceUser extends ResourceOwnerTableDefinition
    implements BasicModel, Auditable {
  @Column(nullable: true)
  String? firstName;

  @Column(nullable: true)
  String? lastName;

  @Column(nullable: true)
  @Validate.matches(r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$')
  String? email;

  @Column(nullable: true)
  @Validate.matches(
      r'(([+][(]?[0-9]{1,3}[)]?)|([(]?[0-9]{4}[)]?))\s*[)]?[-\s\.]?[(]?[0-9]{1,3}[)]?([-\s\.]?[0-9]{3})([-\s\.]?[0-9]{3,4})')
  String? mobile;

  @Column(nullable: true)
  DateTime? emailVerifiedOn;

  @Column(nullable: true)
  DateTime? mobileVerifiedOn;

  @Column(nullable: true)
  DateTime? disabledOn;

  @Column(defaultValue: 'false')
  bool? isSuperAdmin;

  @Column(defaultValue: 'false')
  bool? changePassword;

  @Column(nullable: true)
  String? profilePic;

  @override
  int? createdById;

  @override
  DateTime? createdOn;

  @override
  int? updatedById;

  @override
  DateTime? updatedOn;
}
