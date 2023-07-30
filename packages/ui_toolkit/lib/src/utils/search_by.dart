import 'dart:convert';

class SearchBy {
  final String? exp;
  final Map<String, dynamic>? values;

  SearchBy({
    this.exp,
    this.values = const {},
  });

  @override
  String toString() => Uri.encodeComponent(jsonEncode({
        'exp': exp,
        'values': values,
      }));

  static SearchBy and(List<SearchBy?> items) {
    var junction = '';
    final exp = StringBuffer();
    final value = <String, dynamic>{};
    for (var element in items) {
      if (element == null) {
        continue;
      }

      exp.write('$junction(${element.exp})');
      junction = ' AND ';
      value.addAll(element.values ?? {});
    }

    return SearchBy(
      exp: exp.toString().trim(),
      values: value,
    );
  }
}
