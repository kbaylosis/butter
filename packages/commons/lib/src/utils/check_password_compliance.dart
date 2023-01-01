bool checkPasswordCompliance(String password,
    {int minLength = 6, bool useSpecialChars = false}) {
  // ignore: unnecessary_null_comparison
  if (password == null || password.isEmpty) {
    return false;
  }

  final hasUppercase = password.contains(RegExp(r'[A-Z]'));
  final hasDigits = password.contains(RegExp(r'[0-9]'));
  final hasLowercase = password.contains(RegExp(r'[a-z]'));
  final hasSpecialCharacters =
      password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  final hasMinLength = password.length > minLength;

  return hasDigits &&
      hasUppercase &&
      hasLowercase &&
      (!useSpecialChars || hasSpecialCharacters) &&
      hasMinLength;
}
