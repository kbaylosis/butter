import 'package:butter/butter.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../butter_toolkit.dart';
import '../../utils/screens.dart';
import '../../utils/search_by.dart';
import '../clickable_icon.dart';
import '../dialogs/picker_dialog.dart';
import '../form_fields/formatters/numeric_text_formatter.dart';
import '../highlight_text.dart';
import 'dialogs/add_item_dialog.dart';
import 'dialogs/approve_item_dialog.dart';
import 'dialogs/delete_item_dialog.dart';
import 'dialogs/error_dialog.dart';
import 'dialogs/show_dialog_box.dart';
import 'items_table_model.dart';

class ItemColumnSpecs {
  bool actions;
  bool center;
  bool highlight;
  String label;
  final bool numeric;
  String name;
  bool sortable;
  bool isTitle;
  double? width;

  ItemColumnSpecs({
    this.actions = false,
    this.center = false,
    this.highlight = false,
    this.isTitle = false,
    this.label = '',
    this.name = '',
    this.numeric = false,
    this.sortable = false,
    this.width,
  });
}

class ItemsTable<T extends ItemsTableModel> extends StatefulWidget {
  final List<Widget>? actions;
  final bool Function(int index)? allowApprove;
  final bool Function(int index)? allowEdit;
  final bool Function(int index)? allowDelete;
  final bool Function(int index)? allowDeny;
  final bool Function(int index)? allowPrint;
  final bool Function(int index)? allowView;
  final bool autofocusSearch;
  final List<Widget> Function(int index)? buildActions;
  final bool compactActions;
  final ItemsTableController? controller;
  final List<Widget> controlActions;
  final List<Widget> Function({
    TextEditingController? searchBox,
    void Function(String searchItem)? performSearch,
  })? buildTableActions;
  final AbstractAddItemDialog<T> Function(
      {required ItemsTableModel model, int? index})? buildAddDialog;
  final AbstractAddItemDialog<T> Function(
      {required ItemsTableModel model,
      required AddItemDialogController<ItemsTableModel> controller,
      int? index})? buildAddItemDialog;
  final PickerDialog Function()? buildPickerDialog;
  final List<ItemColumnSpecs>? columns;
  final dynamic Function(int index)? getTitle;
  final Widget? Function(int index, ItemColumnSpecs column)? getInfo;
  final dynamic Function(int index, [String? name]) getValue;
  final double? height;
  final bool initSearch;
  final List<TextInputFormatter>? inputFormatters;
  final T model;
  final Future<void> Function(int id, bool approve)? onApprove;
  final String Function(String text)? performSearch;
  final List<String?>? searchCol;
  final String? searchBoxHint;
  final bool showAddItem;
  final bool showApprove;
  final bool showControlBox;
  final bool showEdit;
  final bool showDelete;
  final bool showDeny;
  final bool showPrint;
  final bool showRefresh;
  final bool showSearch;
  final bool showView;
  final bool singlePage;
  final bool visible;
  final double? width;
  final bool wildcardSearch;

  const ItemsTable({
    super.key,
    this.actions,
    this.allowApprove,
    this.allowEdit,
    this.allowDelete,
    this.allowDeny,
    this.allowPrint,
    this.allowView,
    this.autofocusSearch = false,
    this.buildActions,
    this.buildAddDialog,
    this.buildAddItemDialog,
    this.buildPickerDialog,
    this.buildTableActions,
    this.columns,
    this.compactActions = false,
    this.controlActions = const [],
    this.controller,
    this.getTitle,
    this.getInfo,
    required this.getValue,
    this.height,
    this.initSearch = false,
    this.inputFormatters,
    required this.model,
    this.onApprove,
    this.performSearch,
    this.searchCol,
    this.searchBoxHint,
    this.showAddItem = true,
    this.showApprove = false,
    this.showControlBox = true,
    this.showEdit = true,
    this.showDelete = true,
    this.showDeny = false,
    this.showPrint = false,
    this.showRefresh = true,
    this.showSearch = true,
    this.showView = true,
    this.singlePage = false,
    this.visible = true,
    this.width,
    this.wildcardSearch = true,
  });

  @override
  State<StatefulWidget> createState() => _ItemsTableState<T>();
}

class _ItemsTableState<T extends ItemsTableModel> extends State<ItemsTable> {
  final _controller = AddItemDialogController<T>();
  final borderLess = const OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
    ),
  );
  final searchBorder1 = OutlineInputBorder(
    borderRadius: BorderRadius.circular(6.0),
    borderSide: BorderSide(
        color: ButterToolkit().brandInfo.grayLighter.withOpacity(0.5)),
  );

  final searchBorder2 = OutlineInputBorder(
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(6),
      bottomLeft: Radius.circular(6),
    ),
    borderSide: BorderSide(
        color: ButterToolkit().brandInfo.grayLighter.withOpacity(0.5)),
  );

  final txtSearch = TextEditingController();
  final txtPage = TextEditingController();
  final nodeSearch = FocusNode();
  Function eq = const ListEquality().equals;
  final _scrollController = ScrollController();
  final FocusNode _scrollFocusNode = FocusNode();

  int? _offset = 0;
  var _pageSize = 10;
  List<String>? _sortBy;
  int? _sortCol;
  bool? _sortAsc;

  @override
  void initState() {
    super.initState();
    txtPage.text = '1';
    _sortAsc = widget.model.sortAsc;
    _sortBy = widget.model.sortBy;
    _sortCol = widget.model.sortCol;
    _offset = widget.model.offset;

    if (widget.autofocusSearch) {
      Future.delayed(
          const Duration(seconds: 1), () => nodeSearch.requestFocus());
    }

    widget.controller
      ?..clearSearch = txtSearch.clear
      ..performSearch = _onSubmitText;

    if (widget.initSearch) {
      _onSubmitText();
    }
  }

  @override
  void didUpdateWidget(ItemsTable oldWidget) {
    Butter.d('_ItemsTableState::didUpdateWidget');
    super.didUpdateWidget(oldWidget);
    if (oldWidget.model.offset != widget.model.offset) {
      _offset = widget.model.offset;
      txtPage.text = widget.model.currentPage.toString();
    }

    if (oldWidget.model != widget.model) {
      Butter.d('_ItemsTableState::didUpdateWidget::model');
      Butter.d('setModel: ${_controller.setModel != null}');
      if (_controller.setModel != null) {
        Butter.d('_ItemsTableState::didUpdateWidget::setModel');
        _controller.setModel!(widget.model as T);
      }
    }
  }

  @override
  void dispose() {
    _scrollFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = Screens(context);

    return KeyboardListener(
      autofocus: screen.isMobile,
      focusNode: _scrollFocusNode,
      onKeyEvent: _handleKeyEvent,
      child: Container(
        alignment: Alignment.center,
        child: SizedBox(
          height: widget.visible ? null : 0,
          width: widget.width ?? screen.contentWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              !widget.showSearch && !widget.showControlBox
                  ? const SizedBox(height: 10)
                  : Container(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          screen.isMobile
                              ? Expanded(child: _searchBox())
                              : _searchBox(),
                          Container(
                            alignment: Alignment.centerRight,
                            padding: widget.compactActions
                                ? null
                                : const EdgeInsets.only(left: 10),
                            child: _controlBox(),
                          ),
                        ],
                      ),
                    ),
              widget.model.loading
                  ? Container(
                      alignment: Alignment.center,
                      height: 5,
                      child: const LinearProgressIndicator(),
                    )
                  : Container(height: 5),
              Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection:
                      screen.isMobile ? Axis.vertical : Axis.horizontal,
                  child: screen.isMobile
                      ? _cardList()
                      : (screen.isDesktop
                          ? Container(
                              child: _table(),
                            )
                          : _table()),
                ),
              ),
              widget.singlePage
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: _pageSizeControl(),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: _pageControl(),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBox() {
    final searchBorder = widget.compactActions ? searchBorder2 : searchBorder1;
    return SizedBox(
      height: 50,
      width: Screens(context).isMobile ? null : 300,
      child: widget.showSearch
          ? TextFormField(
              autofocus: !Screens(context).isMobile,
              focusNode: nodeSearch,
              controller: txtSearch,
              decoration: InputDecoration(
                border: searchBorder,
                contentPadding: EdgeInsets.zero,
                enabledBorder: searchBorder,
                fillColor:
                    ButterToolkit().brandInfo.grayLighter.withOpacity(0.2),
                filled: true,
                hintText: widget.searchBoxHint ?? 'Search',
                prefixIcon: Icon(
                  EvilIcons.search,
                  size: Screens(context).isMobile ? 26 : 20,
                  color: ButterToolkit().brandInfo.grayLight,
                ),
                suffixIcon: ClickableIcon(
                  iconData: EvilIcons.close,
                  size: Screens(context).isMobile ? 26 : 20,
                  onPressed: () {
                    txtSearch.clear();
                    setState(() => _offset = 0);
                    if (widget.autofocusSearch) {
                      Future.delayed(const Duration(seconds: 1),
                          () => nodeSearch.requestFocus());
                    }
                    _onSubmitText('');
                  },
                  color: ButterToolkit().brandInfo.grayLight.withOpacity(0.5),
                ),
                focusedBorder: searchBorder,
              ),
              inputFormatters: widget.inputFormatters,
              onFieldSubmitted: (value) {
                setState(() => _offset = 0);
                _onSubmitText(value);
              },
              style: TextStyle(fontSize: Screens(context).isMobile ? 16 : 12),
              textAlignVertical: TextAlignVertical.center,
            )
          : Container(),
    );
  }

  Widget _controlBox() => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...widget.controlActions,
          !widget.showAddItem ||
                  (widget.buildAddItemDialog == null &&
                      widget.buildAddDialog == null &&
                      widget.buildPickerDialog == null)
              ? Container()
              : ClickableIcon(
                  iconData: MaterialCommunityIcons.plus,
                  onPressed: () => showDialogBox(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) => widget.buildAddItemDialog == null
                        ? (widget.buildAddDialog == null
                            ? widget.buildPickerDialog!()
                            : widget.buildAddDialog!(model: widget.model))
                        : widget.buildAddItemDialog!(
                            controller: _controller,
                            model: widget.model,
                          ),
                  ),
                  size: 26,
                ),
          const SizedBox(height: 50, width: 5),
          widget.showRefresh
              ? ClickableIcon(
                  iconData: SimpleLineIcons.refresh,
                  onPressed: _onSubmitText,
                  size: Screens(context).isMobile ? 26 : 20,
                )
              : Container(),
          const SizedBox(width: 10),
        ]
          ..insertAll(0, widget.actions == null ? [] : widget.actions!)
          ..insertAll(
              0,
              widget.buildTableActions == null
                  ? []
                  : widget.buildTableActions!(
                      performSearch: _onSubmitText,
                      searchBox: txtSearch,
                    )),
      );

  Widget _table() => Material(
        color: Colors.transparent,
        child: DataTable(
          headingRowHeight: 50,
          headingRowColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) =>
                  ButterToolkit().brandInfo.grayLighter.withOpacity(0.3)),
          showCheckboxColumn: false,
          sortColumnIndex: widget.model.sortCol,
          sortAscending: widget.model.sortAsc!,
          columns: _dataColumns(),
          rows: _dataRows(),
          showBottomBorder: true,
        ),
      );

  Widget _cardList() {
    final column = widget.columns?.firstWhereOrNull((e) => e.isTitle);
    final length = widget.model.items?.length ?? 0;
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.topCenter,
        height: length == 0
            ? 200
            : ((widget.height ?? Screens(context).screenSize.height) - 230),
        width: Screens(context).contentWidth,
        child: length == 0
            ? Text(
                widget.model.loading
                    ? '--- Please wait ---'
                    : '--- No records to display ----',
                style: TextStyle(
                  color: ButterToolkit().brandInfo.grayLighter,
                  fontStyle: FontStyle.italic,
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: length,
                itemBuilder: (context, index) => _card(context, index, column),
              ),
      ),
    );
  }

  Widget _card(BuildContext context, int index, ItemColumnSpecs? column) {
    final title = widget.getTitle?.call(index) ?? column?.name;
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.fromLTRB(5, 5, 5, 20),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        onTap: (widget.allowView?.call(index) ?? true)
            ? () => _performView(index)
            : null,
        subtitle: Container(
          margin: const EdgeInsets.only(top: 16),
          child: Column(
            children: (widget.columns ?? [])
                .map((e) => e.actions
                    ? Container()
                    : widget.getInfo?.call(index, e) ?? _getInfo(index, e))
                .toList(),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            title == null
                ? Container()
                : (title is Widget)
                    ? title
                    : HighlightText(title.toString()),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _denyAction(index),
                _approveAction(index),
                _deleteAction(index),
                _editAction(index),
                _printAction(index),
                _viewAction(index),
                ...(widget.buildActions == null
                    ? []
                    : widget.buildActions!(index)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowActions(int index) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...(widget.buildActions == null ? [] : widget.buildActions!(index)),
          _viewAction(index),
          _printAction(index),
          _editAction(index),
          _deleteAction(index),
          _approveAction(index),
          _denyAction(index),
        ],
      );

  List<DataColumn> _dataColumns() => List.generate(
      widget.columns!.length,
      (index) => DataColumn(
            numeric: widget.columns![index].numeric,
            onSort: widget.columns![index].sortable
                ? (index, ascending) {
                    setState(() {
                      _sortCol = index;
                      _sortAsc = ascending;
                      _sortBy = [
                        '${widget.columns![index].name},${ascending ? 'asc' : 'desc'}'
                      ];
                    });

                    _onSubmitText();
                  }
                : null,
            label: Expanded(
              child: Container(
                alignment: widget.columns![index].actions
                    ? Alignment.center
                    : (widget.columns![index].numeric
                        ? Alignment.centerRight
                        : (widget.columns![index].center
                            ? Alignment.center
                            : Alignment.centerLeft)),
                width: widget.columns![index].width,
                child: Text(
                  widget.columns![index].label,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign:
                      widget.columns![index].center ? TextAlign.center : null,
                ),
              ),
            ),
          ));

  List<DataRow> _dataRows() => List.generate(
        widget.model.items?.length ?? 0,
        (index) => DataRow(
          color: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            // Even rows will have a grey color.
            if (index % 2 == 0) {
              return null; // Use default value for other states and odd rows.
            }

            return ButterToolkit().brandInfo.grayLighter.withOpacity(0.3);
          }),
          onSelectChanged: (widget.allowView?.call(index) ?? widget.showView)
              ? (status) => _performView(index)
              : null,
          cells: widget.columns!.expand<DataCell>(
            (element) {
              try {
                final value = widget.getValue(index, element.name);
                final child = (value is Widget)
                    ? value
                    : HighlightText(
                        value.toString(),
                        style: const TextStyle(overflow: TextOverflow.ellipsis),
                      );

                return [
                  element.actions
                      ? DataCell(
                          SizedBox(
                            width: element.width,
                            child: _rowActions(index),
                          ),
                        )
                      : DataCell(Align(
                          alignment: element.actions
                              ? Alignment.center
                              : (element.numeric
                                  ? Alignment.centerRight
                                  : (element.center
                                      ? Alignment.center
                                      : Alignment.centerLeft)),
                          child: SizedBox(
                            width: element.width,
                            child: child,
                          ),
                        ))
                ];
              } catch (e) {
                Butter.w(e.toString());
                return [
                  DataCell(
                    SizedBox(
                      width: element.width,
                      child: Container(),
                    ),
                  )
                ];
              }
            },
          ).toList(),
        ),
      );

  Widget _pageSizeControl() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: ButterToolkit().brandInfo.grayLighter.withOpacity(0.2),
            ),
            padding: const EdgeInsets.all(5),
            height: 30,
            width: 50,
            child: DropdownButton<String>(
              underline: Container(),
              icon: Icon(
                SimpleLineIcons.arrow_down,
                size: 10,
                color: ButterToolkit().brandInfo.grayLight,
              ),
              isExpanded: true,
              onChanged: (value) {
                int count = int.parse(value!);
                setState(() => _pageSize = count);
                widget.model.fetch!(offset: 0, count: count);
              },
              value: _pageSize.toString(),
              items: ['10', '50', '100']
                  .map(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(fontSize: 16)),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(width: 5),
          const Text('items/page'),
        ],
      );

  Widget _pageControl() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
            height: 50,
            width: 60,
            child: TextFormField(
              controller: txtPage,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                fillColor:
                    ButterToolkit().brandInfo.grayLighter.withOpacity(0.2),
                filled: true,
                border: borderLess,
                enabledBorder: borderLess,
                focusedBorder: borderLess,
              ),
              inputFormatters: [
                NumericTextFormatter(min: 1, max: widget.model.totalPages),
              ],
              onTap: _selectPageNum,
              onFieldSubmitted: (value) {
                setState(() {
                  final value = int.tryParse(txtPage.text) ?? 1;
                  txtPage.text = value.toString();
                  _offset = (value - 1) * _pageSize;
                });
                _onSubmitText();
              },
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
            ),
          ),
          Text(
            'of ${widget.model.totalPages}',
          ),
          const SizedBox(width: 10),
          ClickableIcon(
            iconData: AntDesign.doubleleft,
            onPressed: () {
              if (widget.model.offset! > 0) {
                setState(() => _offset = 0);
                _onSubmitText();
              }
            },
            size: 20,
          ),
          const SizedBox(width: 5),
          ClickableIcon(
            iconData: AntDesign.left,
            onPressed: () {
              final offset = widget.model.offset!;
              final count = widget.model.count!;
              if (offset - count >= 0) {
                setState(() => _offset = offset - count);
                _onSubmitText();
              }
            },
            size: 20,
          ),
          const SizedBox(width: 5),
          ClickableIcon(
            iconData: AntDesign.right,
            onPressed: () {
              final offset = widget.model.offset!;
              final count = widget.model.count!;
              if (offset + count < widget.model.total!) {
                setState(() => _offset = offset + count);
                _onSubmitText();
              }
            },
            size: 20,
          ),
          const SizedBox(width: 5),
          ClickableIcon(
            iconData: AntDesign.doubleright,
            onPressed: widget.model.totalPages > 0
                ? () {
                    final count = widget.model.count!;
                    final offset = (widget.model.totalPages - 1) * count;
                    setState(() => _offset = offset);
                    _onSubmitText();
                  }
                : null,
            size: 20,
          ),
        ],
      );

  Widget _viewAction(int index) =>
      (widget.allowView?.call(index) ?? widget.showView) ||
              (widget.allowView == null && widget.showView)
          ? ClickableIcon(
              iconData: EvilIcons.eye,
              margin: const EdgeInsets.only(left: 3, right: 3),
              onPressed: () => _performView(index),
              padding: const EdgeInsets.all(2),
              size: Screens(context).isMobile ? 36 : 22,
            )
          : Container();

  Widget _printAction(int index) =>
      (widget.allowPrint?.call(index) ?? widget.showPrint) ||
              (widget.allowPrint == null && widget.showPrint)
          ? ClickableIcon(
              iconData: AntDesign.printer,
              margin: const EdgeInsets.only(left: 3, right: 3),
              onPressed: () => widget.model.print!(
                  getContext: () => mounted ? context : null, index: index),
              padding: const EdgeInsets.all(2),
              size: Screens(context).isMobile ? 26 : 18,
            )
          : Container();

  Widget _editAction(int index) =>
      (widget.allowEdit?.call(index) ?? widget.showEdit) ||
              (widget.allowEdit == null && widget.showEdit)
          ? ClickableIcon(
              iconData: EvilIcons.pencil,
              margin: const EdgeInsets.only(left: 3, right: 3),
              onPressed: () => showDialogBox(
                barrierDismissible: false,
                context: context,
                builder: (_) => widget.buildAddItemDialog == null
                    ? widget.buildAddDialog!(model: widget.model, index: index)
                    : widget.buildAddItemDialog!(
                        model: widget.model,
                        controller: _controller,
                        index: index),
              ),
              padding: const EdgeInsets.all(2),
              size: Screens(context).isMobile ? 30 : 22,
            )
          : Container();

  Widget _deleteAction(int index) =>
      (widget.allowDelete?.call(index) ?? widget.showDelete) ||
              (widget.allowDelete == null && widget.showDelete)
          ? ClickableIcon(
              iconData: EvilIcons.trash,
              margin: const EdgeInsets.only(left: 3, right: 3),
              onPressed: () => _showDeleteDialog(index),
              padding: const EdgeInsets.all(2),
              size: Screens(context).isMobile ? 34 : 22,
            )
          : Container();

  Widget _approveAction(int index) =>
      (widget.allowApprove?.call(index) ?? widget.showApprove) ||
              (widget.allowApprove == null && widget.showApprove)
          ? ClickableIcon(
              iconData: EvilIcons.check,
              color: ButterToolkit().brandInfo.primary,
              margin: const EdgeInsets.only(left: 3, right: 3),
              onPressed: () => _showApproveDialog(index),
              padding: const EdgeInsets.all(2),
              size: Screens(context).isMobile ? 30 : 22,
            )
          : Container();

  Widget _denyAction(int index) =>
      (widget.allowDeny?.call(index) ?? widget.showDeny) ||
              (widget.allowDeny == null && widget.showDeny)
          ? ClickableIcon(
              iconData: EvilIcons.close_o,
              margin: const EdgeInsets.only(left: 3, right: 3),
              onPressed: () => _showApproveDialog(index, true),
              padding: const EdgeInsets.all(2),
              size: Screens(context).isMobile ? 30 : 22,
            )
          : Container();

  void _selectPageNum() => txtPage.selection = TextSelection(
        baseOffset: 0,
        extentOffset: txtPage.text.length,
      );

  void _showDeleteDialog(int index) {
    final value = widget.getValue(index, 'id');
    var id = (value is String) ? int.parse(value) : value;

    showDialogBox(
      context: context,
      builder: (_) => DeleteItemDialog(
        id: id,
        name: widget.getValue(index),
        onDelete: widget.model.delete,
        onError: _showErrorDialog,
      ),
    );
  }

  void _showApproveDialog(int index, [bool deny = false]) {
    final value = widget.getValue(index, 'id');
    final id = (value is int) ? value : int.parse(value.toString());

    showDialogBox(
      context: context,
      builder: (_) => ApproveItemDialog(
        deny: deny,
        id: id,
        name: widget.getValue(index),
        onApprove: widget.onApprove,
        onError: _showErrorDialog,
      ),
    );
  }

  void _showErrorDialog(dynamic message) => showDialogBox(
        context: context,
        builder: (_) => ErrorDialog(message.toString()),
      );

  void _performSearch(String searchText) {
    widget.model.fetch!(
      count: _pageSize,
      offset: _offset,
      searchBy: _createSearchBy(searchText),
      sortAsc: _sortAsc,
      sortBy: _sortBy,
      sortCol: _sortCol,
    );
  }

  List<SearchBy>? _createSearchBy(String searchText) {
    return widget.searchCol
        ?.map((e) => SearchBy(
              exp: e,
              values: searchText.isEmpty
                  ? null
                  : {
                      'value':
                          widget.wildcardSearch ? '%$searchText%' : searchText,
                      'pureValue': searchText,
                    },
            ))
        .where((element) =>
            element.exp != null &&
            !(element.exp!.contains(' @value') && element.values == null))
        .toList();
  }

  Widget _getInfo(index, column) {
    final value = widget.getValue(index, column.name);
    final style = column.highlight
        ? Theme.of(context).textTheme.displaySmall
        : Theme.of(context).textTheme.titleMedium?.apply(
              color: ButterToolkit().brandInfo.gray,
              fontSizeDelta: 3,
            );
    return column.isTitle
        ? Container()
        : Container(
            alignment: Alignment.centerLeft,
            child: (value is Widget)
                ? value
                : Text(
                    '${column.label}: ${value.toString()}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: style,
                  ),
          );
  }

  void _handleKeyEvent(KeyEvent event) {
    final isMobile = Screens(context).isMobile;
    final offset = _scrollController.offset;
    if ((isMobile && event.logicalKey == LogicalKeyboardKey.arrowUp) ||
        (!isMobile && event.logicalKey == LogicalKeyboardKey.arrowLeft)) {
      setState(() => mounted
          ? _scrollController.animateTo(offset - 50,
              duration: const Duration(milliseconds: 100), curve: Curves.ease)
          : null);
    } else if ((isMobile && event.logicalKey == LogicalKeyboardKey.arrowDown) ||
        (!isMobile && event.logicalKey == LogicalKeyboardKey.arrowRight)) {
      setState(() => mounted
          ? _scrollController.animateTo(offset + 50,
              duration: const Duration(milliseconds: 100), curve: Curves.ease)
          : null);
    }
  }

  void _onSubmitText([String? value]) {
    value ??= txtSearch.text;

    if (widget.autofocusSearch) {
      Future.delayed(
          const Duration(seconds: 1), () => nodeSearch.requestFocus());
    }

    if (widget.performSearch == null) {
      _performSearch(value);
      return;
    }

    final result = widget.performSearch!(value);
    if (result.isNotEmpty) {
      _performSearch(result);
    }

    if (result != value) {
      txtSearch.text = value;
    }
  }

  void _performView(int index) async {
    try {
      await widget.model.view?.call(index);
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }
}

class ItemsTableController {
  void Function() clearSearch = () {};
  void Function([String? value]) performSearch = ([value]) {};
}
