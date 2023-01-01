extension StringExtension on String {
  String truncateTo(int maxLength) =>
      (length <= maxLength) ? this : '${substring(0, maxLength)}...';
  String tail(int len) =>
      (length <= len) ? this : '${substring(length - len, length)}';
  T toEnum<T>(Iterable<T> values) =>
      values.firstWhere((type) => type.toString().split('.').last == this);
  int get lines => '\n'.allMatches(this).length + 1;
}
