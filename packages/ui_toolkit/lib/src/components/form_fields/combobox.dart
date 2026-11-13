import 'package:butter/butter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../butter_toolkit.dart';
import '../clickable_icon.dart';
import '../dialogs/picker_dialog.dart';

class Combobox<T> extends StatefulWidget {
  final bool allowClear;
  final bool autoSearch;
  final String dialogHintText;
  final double dialogWidth;
  final bool enabled;
  final void Function(String searchText)? fetchItems;
  final List<T> Function(String searchText)? fetchSyncItems;
  final dynamic Function(T item)? getValue;
  final String Function(T item)? getValueAsText;
  final double? height;
  final String hintText;
  final String? initialItem;
  final List<T> items;
  final bool Function(T item)? isSelected;
  final List<TextInputFormatter>? inputFormatters;
  final bool loading;
  final void Function(T item)? onSelected;
  final void Function()? onClear;
  final bool searcheable;
  final double? width;
  final String value;
  final String dialogTitle;

  const Combobox({
    super.key,
    this.allowClear = true,
    this.autoSearch = true,
    this.dialogHintText = 'Search',
    this.dialogWidth = 300,
    this.enabled = true,
    this.fetchItems,
    this.fetchSyncItems,
    this.getValue,
    this.getValueAsText,
    this.height,
    this.hintText = '',
    this.items = const [],
    this.isSelected,
    this.initialItem,
    this.inputFormatters,
    this.loading = false,
    this.onClear,
    this.onSelected,
    this.searcheable = true,
    this.width,
    this.value = '',
    this.dialogTitle = '',
  });

  @override
  State<StatefulWidget> createState() => _ComboboxState<T>();
}

class _ComboboxState<T> extends State<Combobox<T>> {
  final txtValue = TextEditingController();
  final PickerDialogController<T> _controller = PickerDialogController();

  @override
  void initState() {
    super.initState();

    txtValue.text = widget.value;
  }

  @override
  void didUpdateWidget(Combobox<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      Butter.d('Combobox::didUpdateWidget:value');
      txtValue.text = widget.value;
    }

    if (oldWidget.items != widget.items) {
      Butter.d('Combobox::didUpdateWidget:items');
      Butter.d(widget.loading);
      _controller.setLoading?.call(widget.loading);
      _controller.setItems?.call(widget.items);
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: widget.height,
        width: widget.width,
        child: TextFormField(
          controller: txtValue,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(15.0),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: ButterToolkit().brandInfo.grayLight.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(6.0),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: ButterToolkit().brandInfo.grayLight.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(6.0),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            labelText: widget.hintText,
            suffixIcon: widget.allowClear && widget.enabled
                ? ClickableIcon(
                    iconData: EvilIcons.close,
                    size: 20,
                    onPressed: () {
                      txtValue.clear();
                      widget.onClear?.call();
                    },
                    color: ButterToolkit().brandInfo.grayLight.withOpacity(0.5),
                  )
                : null,
          ),
          readOnly: true,
          onTap: !widget.enabled
              ? null
              : () async {
                  final info = await showDialog<T>(
                    context: context,
                    builder: (_) => PickerDialog<T>(
                      title: widget.dialogTitle,
                      autoSearch: widget.autoSearch,
                      controller: _controller,
                      fetchItems: widget.fetchItems,
                      fetchSyncItems: widget.fetchSyncItems,
                      hintText: widget.dialogHintText,
                      getValue: widget.getValue,
                      initialItem: widget.initialItem ?? widget.value,
                      items: widget.items,
                      isSelected: widget.isSelected,
                      inputFormatters: widget.inputFormatters,
                      loading: widget.loading,
                      searcheable: widget.searcheable,
                      width: widget.dialogWidth,
                    ),
                    routeSettings: RouteSettings(
                        name: ModalRoute.of(context)?.settings.name),
                  );

                  if (info == null) {
                    return;
                  }

                  setState(() {
                    txtValue.text = widget.getValueAsText == null
                        ? widget.getValue!(info).toString()
                        : widget.getValueAsText!(info);
                  });

                  widget.onSelected!(info);
                },
        ),
      );
}
