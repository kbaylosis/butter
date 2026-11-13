import 'package:butter/butter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../butter_toolkit.dart';
import '../../../utils/screens.dart';
import '../../highlight_text.dart';
import '../../pages/standard_button.dart';
import '../../pages/standard_page.dart';
import '../items_table_model.dart';

abstract class AbstractAddItemDialog<T extends ItemsTableModel>
    extends StatefulWidget {
  final AddItemDialogController<T> controller;
  final T model;
  final int? index;

  const AbstractAddItemDialog({
    super.key,
    required this.controller,
    required this.model,
    this.index,
  });
}

class AddItemDialog<T extends ItemsTableModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, bool loading,
      void Function() clearError)? buildItemFields;
  final AddItemDialogController<T> controller;
  final double height;
  final void Function()? initFields;
  final DialogMode mode;
  final T model;
  final String? name;
  final Future<void> Function()? onAdd;
  final Future<void> Function()? onEdit;
  final List<Widget?>? postActions;
  final List<Widget?>? preActions;
  final bool showCancel;
  final bool showSave;
  final double width;

  const AddItemDialog({
    super.key,
    this.buildItemFields,
    required this.controller,
    this.height = 200,
    this.initFields,
    this.mode = DialogMode.add,
    required this.model,
    this.name,
    this.onAdd,
    this.onEdit,
    this.postActions,
    this.preActions,
    this.showCancel = true,
    this.showSave = true,
    this.width = 300,
  });

  @override
  State<StatefulWidget> createState() => _AddItemDialogState<T>();
}

class _AddItemDialogState<T extends ItemsTableModel>
    extends State<AddItemDialog<T>> {
  T? _model;
  String? _error;
  bool _loading = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    Butter.d('_AddItemDialogState::initState');
    super.initState();

    if (widget.mode == DialogMode.edit) {
      widget.initFields?.call();
    }

    _model = widget.model;
    Butter.d('controller: ${widget.controller}');
    widget.controller.setModel = (m) =>
        Future.microtask(() => mounted ? setState(() => _model = m) : null);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => kIsWeb
      ? AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text(
            '${widget.mode == DialogMode.add ? 'Add' : 'Edit'} ${widget.name}',
            style: Theme.of(context).textTheme.headlineMedium!.apply(
                  color: ButterToolkit().brandInfo.grayDarker,
                  fontWeightDelta: 6,
                ),
          ),
          content: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 5),
                  _error == null
                      ? Container()
                      : Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(bottom: 10),
                          child: HighlightText(
                            _error!,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                  Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    thickness: 5,
                    child: Container(
                      height: widget.height,
                      padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                      width: widget.width,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(right: 10, top: 15),
                        scrollDirection: Axis.vertical,
                        child: widget.buildItemFields == null
                            ? null
                            : widget.buildItemFields!(
                                context, _model!, _loading, _clearError),
                      ),
                    ),
                  ),
                ],
              ),
              _loading
                  ? Container(
                      alignment: Alignment.center,
                      height: 5,
                      child: const LinearProgressIndicator(),
                    )
                  : Container(height: 5),
            ],
          ),
          actions: List.castFrom<Widget?, Widget>([
            ...(widget.preActions ?? []),
            widget.showCancel
                ? StandardButton(
                    label: 'Cancel',
                    onPressed: _loading
                        ? null
                        : () {
                            FocusScope.of(context).unfocus();
                            Navigator.of(context).pop();
                          },
                    type: ButtonType.thin,
                    width: 100,
                  )
                : null,
            widget.showSave
                ? StandardButton(
                    label: 'Save',
                    onPressed: _loading
                        ? null
                        : () async {
                            String? error;
                            try {
                              setState(() => _loading = true);

                              if (widget.mode == DialogMode.add) {
                                await widget.onAdd?.call();
                              } else {
                                await widget.onEdit?.call();
                              }

                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            } on String catch (e) {
                              if (!context.mounted) return;
                              error = ButterToolkit()
                                  .translator
                                  .getMessage(context, e);
                            } catch (e, stacktrace) {
                              Butter.e(e.toString());
                              Butter.e(stacktrace.toString());

                              if (!context.mounted) return;
                              error = ButterToolkit().translator.getMessage(
                                  context,
                                  'Error ${widget.mode == DialogMode.add ? 'adding' : 'updating'} the record');
                            }

                            setState(() {
                              _error = error;
                              _loading = false;
                            });
                          },
                    width: 100,
                    type: ButtonType.primary,
                  )
                : null,
            ...(widget.postActions ?? []),
          ]..removeWhere((element) => element == null)),
        )
      : StandardPage(
          title:
              '${widget.mode == DialogMode.add ? 'Add' : 'Edit'} ${widget.name}',
          centerTitle: false,
          outerPadding: EdgeInsets.zero,
          innerPadding: EdgeInsets.zero,
          showAppBar: true,
          height: 650,
          width: Screens(context).screenSize.width,
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  _error == null
                      ? Container()
                      : Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(bottom: 10),
                          child: HighlightText(
                            _error!,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                  Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    thickness: 5,
                    child: Container(
                      height: widget.height,
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        child: widget.buildItemFields == null
                            ? null
                            : widget.buildItemFields!(
                                context, _model!, _loading, _clearError),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  widget.showSave
                      ? StandardButton(
                          label: 'Save',
                          onPressed: _loading
                              ? null
                              : () async {
                                  String? error;
                                  try {
                                    setState(() => _loading = true);

                                    if (widget.mode == DialogMode.add) {
                                      await widget.onAdd?.call();
                                    } else {
                                      await widget.onEdit?.call();
                                    }

                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                    }
                                  } on String catch (e) {
                                    if (!context.mounted) return;
                                    error = ButterToolkit()
                                        .translator
                                        .getMessage(context, e);
                                  } catch (e, stacktrace) {
                                    Butter.e(e.toString());
                                    Butter.e(stacktrace.toString());

                                    if (!context.mounted) return;
                                    error = ButterToolkit().translator.getMessage(
                                        context,
                                        'Error ${widget.mode == DialogMode.add ? 'adding' : 'updating'} the record');
                                  }

                                  setState(() {
                                    _error = error;
                                    _loading = false;
                                  });
                                },
                          width: 250,
                          type: ButtonType.normal,
                        )
                      : const SizedBox(),
                ],
              ),
              _loading
                  ? Container(
                      alignment: Alignment.center,
                      height: 5,
                      child: const LinearProgressIndicator(),
                    )
                  : Container(height: 5),
            ],
          ),
        );

  void _clearError() => setState(() => _error = null);
}

enum DialogMode {
  add,
  edit,
}

class AddItemDialogController<T extends ItemsTableModel> {
  void Function(T model)? setModel;
}
