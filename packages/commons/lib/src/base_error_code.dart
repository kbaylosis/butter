import 'utils/enum_utils.dart';

enum BaseErrorCode {
  undefined,
  //
  badPassword,
  duplicateItem,
  entityAlreadyExists,
  foreignKeyViolation,
  missingChildren,
  objectNotFound,
  operationNotAllowed,
  unexpectedError,
}

extension ErrorCodeExtension on BaseErrorCode {
  String get name => describeEnum(this);
}
