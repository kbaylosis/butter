import 'package:conduit_core/conduit_core.dart';

class CustomPredicate extends QueryPredicate {
  CustomPredicate(String format, [Map<String, dynamic>? parameters = const {}])
      : super(format, parameters);

  CustomPredicate.empty() : super.empty();

  /// Combines [predicates] with 'AND' keyword.
  ///
  /// The [format] of the return value is produced by joining together each [predicates]
  /// [format] string with 'AND'. Each [parameters] from individual [predicates] is combined
  /// into the returned [parameters].
  ///
  /// If there are duplicate parameter names in [predicates], they will be disambiguated by suffixing
  /// the parameter name in both [format] and [parameters] with a unique integer.
  ///
  /// If [predicates] is null or empty, an empty predicate is returned. If [predicates] contains only
  /// one predicate, that predicate is returned.
  factory CustomPredicate.or(Iterable<CustomPredicate> predicates) {
    final predicateList = predicates.where((p) => p.format.isNotEmpty).toList();

    if (predicateList.isEmpty) {
      return CustomPredicate.empty();
    }

    if (predicateList.length == 1) {
      return predicateList.first;
    }

    // If we have duplicate keys anywhere, we need to disambiguate them.
    int dupeCounter = 0;
    final allFormatStrings = [];
    final valueMap = <String, dynamic>{};
    for (final predicate in predicateList) {
      final duplicateKeys = predicate.parameters?.keys
              .where((k) => valueMap.keys.contains(k))
              .toList() ??
          [];

      if (duplicateKeys.isNotEmpty) {
        var fmt = predicate.format;
        final dupeMap = <String, String>{};
        for (final key in duplicateKeys) {
          final replacementKey = '$key$dupeCounter';
          fmt = fmt.replaceAll('@$key', '@$replacementKey');
          dupeMap[key] = replacementKey;
          dupeCounter++;
        }

        allFormatStrings.add(fmt);
        predicate.parameters?.forEach((key, value) {
          valueMap[dupeMap[key] ?? key] = value;
        });
      } else {
        allFormatStrings.add(predicate.format);
        valueMap.addAll(predicate.parameters ?? {});
      }
    }

    final predicateFormat = '(${allFormatStrings.join(' OR ')})';
    return CustomPredicate(predicateFormat, valueMap);
  }

  factory CustomPredicate.and(Iterable<CustomPredicate?> predicates) {
    final predicateList = predicates
        .where((p) => p?.format != null && p!.format.isNotEmpty)
        .toList();

    if (predicateList.isEmpty) {
      return CustomPredicate.empty();
    }

    if (predicateList.length == 1) {
      return predicateList.first!;
    }

    // If we have duplicate keys anywhere, we need to disambiguate them.
    int dupeCounter = 0;
    final allFormatStrings = [];
    final valueMap = <String, dynamic>{};
    for (final predicate in predicateList) {
      final duplicateKeys = predicate!.parameters?.keys
              .where((k) => valueMap.keys.contains(k))
              .toList() ??
          [];

      if (duplicateKeys.isNotEmpty) {
        var fmt = predicate.format;
        final dupeMap = <String, String>{};
        for (final key in duplicateKeys) {
          final replacementKey = '$key$dupeCounter';
          fmt = fmt.replaceAll('@$key', '@$replacementKey');
          dupeMap[key] = replacementKey;
          dupeCounter++;
        }

        allFormatStrings.add(fmt);
        predicate.parameters?.forEach((key, value) {
          valueMap[dupeMap[key] ?? key] = value;
        });
      } else {
        allFormatStrings.add(predicate.format);
        valueMap.addAll(predicate.parameters ?? {});
      }
    }

    final predicateFormat = '(${allFormatStrings.join(' AND ')})';
    return CustomPredicate(predicateFormat, valueMap);
  }
}
