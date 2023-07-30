import 'package:flutter/material.dart';

import '../items/dialogs/error_dialog.dart';

Future<void> showErrorDialog(BuildContext context, dynamic message) =>
    showDialog(
      context: context,
      builder: (_) => ErrorDialog(message.toString()),
      routeSettings: RouteSettings(name: ModalRoute.of(context)?.settings.name),
    );
