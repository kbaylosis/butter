import 'package:butter_commons/butter_commons.dart';

enum BaseErrorCode {
  undefined,
  //
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
