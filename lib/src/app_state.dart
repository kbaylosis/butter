import 'package:flutter/foundation.dart';

/// Stores the application's state
class AppState {
  final Map<String, dynamic> _data;

  AppState({
    @required Map<String, dynamic> data,
  }) : _data = data;

  /// Copies a value into the store
  AppState copy({String key, dynamic value}) {
    final Map<String, dynamic> newData = Map<String, dynamic>.of(this._data);
    newData[key] = value;

    return AppState(data: newData);
  }

  /// Copies a set of values into the store
  AppState copyAll(Map<String, dynamic> map) {
    final Map<String, dynamic> newData = Map<String, dynamic>.of(this._data);
    newData.addAll(map);

    return AppState(data: newData);
  }

  /// Copies multiple sets of values into the store
  AppState copyMultiple(List<Map<String, dynamic>> maps) {
    final Map<String, dynamic> newData = Map<String, dynamic>.of(this._data);
    maps.forEach((map) {
      newData.addAll(map);
    });

    return AppState(data: newData);
  }

  /// Retrieves a value from the store
  T read<T>(String key, [T defValue]) {
    return this._data[key] ?? defValue;
  }
}
