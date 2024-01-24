import 'package:butter/butter.dart';
import 'package:flutter/material.dart';

import '../../../butter_toolkit.dart';
import '../../highlight_text.dart';
import '../../pages/standard_button.dart';

class ApproveItemDialog extends StatefulWidget {
  final int id;
  final String name;
  final Future<void> Function(int id, bool approve)? onApprove;
  final void Function(dynamic e)? onError;
  final bool deny;

  const ApproveItemDialog({
    Key? key,
    required this.id,
    required this.name,
    this.onApprove,
    this.onError,
    this.deny = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ApproveItemDialogState();
}

class _ApproveItemDialogState extends State<ApproveItemDialog> {
  @override
  Widget build(BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        key: widget.key,
        title: HighlightText(
          '${widget.deny ? 'Deny' : 'Approve'} [${widget.name}]',
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
            label: widget.deny ? 'Deny' : 'Approve',
            onPressed: () async {
              try {
                await widget.onApprove!(widget.id, !widget.deny);
                if (mounted) {
                  Navigator.of(context).pop();
                }
              } on String catch (e, stacktrace) {
                Butter.e(e);
                Butter.e(stacktrace.toString());

                if (!context.mounted) return;
                String err = ButterToolkit().translator.getMessage(context, e);

                Navigator.of(context).pop();
                widget.onError!(err);
              } catch (e, stacktrace) {
                Butter.e(e.toString());
                Butter.e(stacktrace.toString());

                if (!context.mounted) return;
                const err = 'An error occured during update';
                Navigator.of(context).pop();
                widget.onError!(err);
              }
            },
            type: ButtonType.thin,
            width: 100,
          ),
        ],
      );
}
