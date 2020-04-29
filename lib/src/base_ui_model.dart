abstract class BaseUIModel<T> {
  String get $key;
  T clone();
}
