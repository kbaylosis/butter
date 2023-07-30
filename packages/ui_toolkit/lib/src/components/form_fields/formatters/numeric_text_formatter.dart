import 'package:flutter/services.dart';

class NumericTextFormatter extends TextInputFormatter {
  final int? min;
  final int? max;
  final bool isDouble;

  NumericTextFormatter({
    this.min,
    this.max,
    this.isDouble = true,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var value = newValue.text.replaceAll(RegExp(r'((?![\.0-9]).)'), '');
    var number =
        isDouble ? (double.tryParse(value) ?? 0) : (int.tryParse(value) ?? 0);

    if ((min != null && number < min!) || (max != null && number > max!)) {
      value = oldValue.text;
    } else if (value.split('.').length > 2) {
      value = oldValue.text;
    }

    return TextEditingValue(
      text: value,
      selection: newValue.selection,
    );
  }
}
