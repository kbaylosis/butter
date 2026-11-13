import 'package:butter/butter.dart';
import 'package:flutter/material.dart';

import '../../../butter_toolkit.dart';
import '../../highlight_text.dart';
import '../../pages/standard_button.dart';

class DeleteItemDialog extends StatefulWidget {
  final int id;
  final String name;
  final Future<void> Function(int id)? onDelete;
  final void Function(dynamic e)? onError;

  const DeleteItemDialog({
    super.key,
    required this.id,
    required this.name,
    this.onDelete,
    this.onError,
  });
  @override
  State<StatefulWidget> createState() => _DeleteItemDialogState();
}

class _DeleteItemDialogState extends State<DeleteItemDialog> {
  @override
  Widget build(BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        key: widget.key,
        title: HighlightText(
          'Delete [${widget.name}]',
          style: Theme.of(context).textTheme.headlineMedium!.apply(
                color: ButterToolkit().brandInfo.grayDarker,
              ),
        ),
        content: const Text('Are you sure you want to proceed?'),
        actions: [
          StandardButton(
            label: 'Cancel',
            onPressed: () => Navigator.of(context).pop(),
            type: ButtonType.normal,
            width: 100,
          ),
          StandardButton(
            label: 'Delete',
            onPressed: () async {
              try {
                await widget.onDelete!(widget.id);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              } on String catch (e) {
                Butter.d(e);
                if (!context.mounted) return;
                String err = ButterToolkit().translator.getMessage(context, e);
                Navigator.of(context).pop();
                widget.onError!(err);
              } catch (e) {
                if (!context.mounted) return;
                Navigator.of(context).pop();
                widget.onError!('An error occured during deletion');
              }
            },
            type: ButtonType.thin,
            width: 100,
          ),
        ],
      );
}
