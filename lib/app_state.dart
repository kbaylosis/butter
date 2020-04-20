
import 'package:flutter/foundation.dart';

class AppState {
  final Map<String, dynamic> _data;

  AppState({
    @required Map<String, dynamic> data,
  }) :
    _data = data
  ;

  AppState copy({ String key, dynamic value }) {
    final Map<String, dynamic> newData = new Map<String, dynamic>.from(this._data);
    newData[key] = value;
    
    return AppState(data: newData);
  }

  AppState copyAll(Map<String, dynamic> map) {
    final Map<String, dynamic> newData = new Map<String, dynamic>.from(this._data);
    newData.addAll(map);
    
    return AppState(data: newData);
  }

  AppState copyMultiple(List<Map<String, dynamic>> maps) {
    final Map<String, dynamic> newData = new Map<String, dynamic>.from(this._data);
    maps.forEach((map) {
      newData.addAll(map);
    });
    
    return AppState(data: newData);
  }

  dynamic read(String key, [ dynamic defValue ]) {
    return this._data[key] ?? defValue;
  }
}