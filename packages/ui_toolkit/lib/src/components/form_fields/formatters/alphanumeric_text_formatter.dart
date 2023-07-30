import 'package:flutter/services.dart';

class AlphaNumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.replaceAll(RegExp(r'((?![_A-Z0-9]).)'), ''),
      selection: newValue.selection,
    );
  }
}
