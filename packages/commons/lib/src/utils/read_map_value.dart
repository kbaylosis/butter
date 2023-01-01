dynamic readMapValue(Map map, List<String> keys) {
  dynamic value = map;
  for (final key in keys) {
    if (value == null) {
      break;
    }

    value = value[key];
  }

  return value;
}
