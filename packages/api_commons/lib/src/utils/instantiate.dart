import 'dart:mirrors';

dynamic instantiate(Type type) {
  final mirror = reflectClass(type);
  return mirror.newInstance(const Symbol(''), []).reflectee;
}
