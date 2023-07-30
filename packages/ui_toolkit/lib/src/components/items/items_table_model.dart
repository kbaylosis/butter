import 'package:flutter/material.dart';

import '../../utils/search_by.dart';

class ItemsTableModel<T> {
  int? count;
  String? error;
  bool loading = false;
  List<T>? items;
  int? offset;
  List<SearchBy>? searchBy;
  bool? sortAsc;
  List<String>? sortBy;
  int? sortCol;
  int? total;

  Future<void> Function(T value)? add;
  void Function(
      {int? count,
      int? offset,
      int? sortCol,
      bool? sortAsc,
      List<String>? sortBy,
      List<SearchBy>? searchBy})? fetch;
  Future<void> Function(int id)? delete;
  Future<void> Function(T value)? edit;
  Future<void> Function(
      {required BuildContext? Function() getContext,
      int? index,
      dynamic record})? print;
  Future<void> Function(int? index)? view;
  void Function()? back;
  void Function()? close;

  int get currentPage => (offset! ~/ count!) + 1;
  int get totalPages => (count! > 0) ? ((total! - 1) ~/ count!) + 1 : 0;
}
