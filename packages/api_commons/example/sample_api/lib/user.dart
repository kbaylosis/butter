import 'package:butter_api_commons/butter_api_commons.dart';
import 'package:conduit/conduit.dart';
import 'package:conduit_core/managed_auth.dart';

class User extends ManagedObject<_User>
    implements _User, ManagedAuthResourceOwner<_User> {
  @Serialize(input: true, output: false)
  String? password;
}

@Table(name: 'user_account')
class _User extends ResourceOwnerTableDefinition implements BasicModel {
  @Column(nullable: true)
  @Validate.matches(r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$')
  String? email;

  @Column(nullable: true)
  DateTime? disabledOn;
}
