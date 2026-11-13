import 'package:butter/butter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:throttling/throttling.dart';

import '../../butter_toolkit.dart';
import '../../utils/screens.dart';
import '../clickable_icon.dart';
import '../pages/standard_page.dart';

class PickerDialog<T> extends StatefulWidget {
  final PickerDialogController<T> controller;
  final void Function(String searchText)? fetchItems;
  final List<T> Function(String searchText)? fetchSyncItems;
  final dynamic Function(T item)? getValue;
  final String hintText;
  final double height;
  final List<TextInputFormatter>? inputFormatters;
  final List<T> items;
  final String? initialItem;
  final bool Function(T item)? isSelected;
  final bool loading;
  final String title;
  final bool autoSearch;
  final Future<bool> Function(T item)? onSelect;
  final bool searcheable;
  final double width;

  const PickerDialog({
    super.key,
    this.autoSearch = false,
    required this.controller,
    this.fetchItems,
    this.fetchSyncItems,
    this.getValue,
    this.height = 250,
    this.hintText = '',
    this.initialItem,
    this.inputFormatters,
    this.items = const [],
    this.isSelected,
    this.loading = false,
    this.title = '',
    this.onSelect,
    this.searcheable = true,
    this.width = 300,
  });

  @override
  State<StatefulWidget> createState() => _PickerDialogState<T>();
}

class _PickerDialogState<T> extends State<PickerDialog<T>> {
  final TextEditingController txtSearch = TextEditingController();
  final _scrollController = ScrollController();
  final _scrollController2 = ScrollController();
  String? _error;
  List<T> _items = [];
  late bool _loading;
  final debouncer = Debouncing(duration: const Duration(seconds: 1));

  @override
  void initState() {
    super.initState();

    _loading = widget.loading;
    _items = widget.items;
    txtSearch.text = widget.initialItem ?? '';

    widget.controller.setLoading = (loading) => Future.microtask(() => mounted
        ? setState(() {
            Butter.d('PickerDialog::setState::setLoading');
            _loading = loading;
            Butter.d(_loading);
          })
        : null);
    widget.controller.setItems = (items) => Future.microtask(() => mounted
        ? setState(() {
            Butter.d('PickerDialog::setState::setItems');
            _items = items;
            Butter.d(_items.asMap());
          })
        : null);

    _fetchItems(widget.initialItem ?? '');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => kIsWeb
      ? AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: widget.title == ''
              ? Align(
                  alignment: Alignment.topRight,
                  child: ClickableIcon(
                    iconData: MaterialCommunityIcons.close,
                    size: 25,
                    onPressed: () => Navigator.of(context).pop(),
                    color: ButterToolkit().brandInfo.gray,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.headlineMedium!.apply(
                            color: ButterToolkit().brandInfo.dark,
                          ),
                    ),
                    ClickableIcon(
                      iconData: MaterialCommunityIcons.close,
                      size: 25,
                      onPressed: () => Navigator.of(context).pop(),
                      color: ButterToolkit().brandInfo.gray,
                    ),
                  ],
                ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _error == null
                  ? Container()
                  : Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        _error!,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
              widget.searcheable
                  ? TextFormField(
                      autofocus: true,
                      controller: txtSearch,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ButterToolkit()
                                  .brandInfo
                                  .grayLight
                                  .withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: ButterToolkit()
                                  .brandInfo
                                  .grayLight
                                  .withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        hintText: widget.hintText,
                        suffixIcon: ClickableIcon(
                          iconData: FontAwesome5Solid.search,
                          size: 20,
                          onPressed: () {
                            if (txtSearch.text != '') {
                              _fetchItems(txtSearch.text);
                            }
                          },
                          color: ButterToolkit()
                              .brandInfo
                              .grayLight
                              .withOpacity(0.5),
                        ),
                      ),
                      inputFormatters: widget.inputFormatters,
                      onChanged: (text) {
                        _clearError();

                        if (widget.autoSearch) {
                          _fetchItems(text);
                        }
                      },
                      onFieldSubmitted: widget.autoSearch ? null : _fetchItems,
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  : Container(),
              const SizedBox(height: 10),
              Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                thickness: 5,
                child: SizedBox(
                  height: widget.height,
                  width: widget.width,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: _list(),
                  ),
                ),
              ),
            ],
          ),
        )
      : StandardPage(
          title: widget.title,
          centerTitle: false,
          outerPadding: EdgeInsets.zero,
          innerPadding: EdgeInsets.zero,
          showAppBar: true,
          height: Screens(context).screenSize.height,
          width: Screens(context).screenSize.width,
          body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _error == null
                    ? Container()
                    : Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          _error!,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                widget.searcheable
                    ? TextFormField(
                        autofocus: true,
                        controller: txtSearch,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: ButterToolkit()
                                    .brandInfo
                                    .grayLight
                                    .withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: ButterToolkit()
                                    .brandInfo
                                    .grayLight
                                    .withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          hintText: widget.hintText,
                          suffixIcon: ClickableIcon(
                            iconData: FontAwesome5Solid.search,
                            size: 20,
                            onPressed: () {
                              if (txtSearch.text != '') {
                                _fetchItems(txtSearch.text);
                              }
                            },
                            color: ButterToolkit()
                                .brandInfo
                                .grayLight
                                .withOpacity(0.5),
                          ),
                        ),
                        inputFormatters: widget.inputFormatters,
                        onChanged: (text) {
                          _clearError();

                          if (widget.autoSearch) {
                            _fetchItems(text);
                          }
                        },
                        onFieldSubmitted:
                            widget.autoSearch ? null : _fetchItems,
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    : Container(),
                const SizedBox(height: 10),
                Scrollbar(
                  controller: _scrollController2,
                  thumbVisibility: true,
                  thickness: 5,
                  child: SizedBox(
                    height: 550,
                    child: SingleChildScrollView(
                      controller: _scrollController2,
                      child: _list(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

  void _clearError() => setState(() => _error = null);

  Widget _list() {
    if (_loading) {
      return Container(
        alignment: Alignment.topCenter,
        height: 5,
        child: const LinearProgressIndicator(),
      );
    } else if (_items.isEmpty) {
      return Text(
        '(empty)',
        style: Theme.of(context).textTheme.bodyMedium,
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = widget.getValue == null
              ? _items[index].toString()
              : widget.getValue!(_items[index]);
          return ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: (item is Widget)
                ? item
                : Text(
                    item,
                    style: widget.isSelected!(_items[index])
                        ? Theme.of(context).textTheme.bodyLarge
                        : Theme.of(context).textTheme.bodyMedium,
                  ),
            onTap: () async {
              try {
                T item = _items[index];
                if (widget.onSelect == null) {
                  Navigator.of(context).pop(item);
                } else {
                  widget.onSelect?.call(item).then((value) => value ?
                    Navigator.of(context).pop(item) : null);
                }
              } catch (e) {
                Butter.e(e.toString());
                setState(() => _error = 'Selection failed');
              }
            },
          );
        },
      );
    }
  }

  void _fetchItems(String searchText) {
    setState(() => _loading = true);
    debouncer.debounce(() {
      if (widget.fetchItems != null) {
        widget.fetchItems?.call(searchText);
        return;
      }

      final result = widget.fetchSyncItems?.call(searchText);
      if (result != null) {
        setState(() {
          _items = result;
          _loading = false;
        });
      }
    });
  }
}

class PickerDialogController<T> {
  void Function(bool loading)? setLoading;
  void Function(List<T> items)? setItems;
}
