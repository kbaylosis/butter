import 'package:intl/intl.dart';

class Formats {
  static String optionalPrecision(double value, [int precision = 1]) =>
      value.toStringAsFixed(value.truncateToDouble() == value ? 0 : precision);

  static String getDayOfWeek(DateTime date) => DateFormat('EEE').format(date);

  static String getMMMdy(DateTime date) => DateFormat('MMM d, y').format(date);

  static String getYYMM(DateTime date) => DateFormat('YYMM').format(date);

  static String getTimeOrDate(DateTime date) {
    var format = 'h:mm:ss a';
    final now = DateTime.now();
    final diff = date.difference(now).inDays;
    if (diff != 0 || date.day != now.day) {
      format = 'MM/d/y h:mm:ssa';
    }

    return DateFormat(format).format(date);
  }

  static String getDate(DateTime date) => DateFormat('MM/d/y').format(date);

  static String getDateTime(DateTime date) =>
      DateFormat('MM/d/y h:mm:ssa').format(date);

  static final NumberFormat numberFormatter = NumberFormat('#,##0.00', 'en_US');
  static String toMoney(double? value) => numberFormatter.format(value ?? 0);
}
