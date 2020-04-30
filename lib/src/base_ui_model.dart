/// The base definition of UI Models
abstract class BaseUIModel<T> {
  /// A unique [String] to be used as a key in the redux [Store]
  String get $key;

  /// Handles copying of the current [BaseUIModel] object
  T clone();
}
