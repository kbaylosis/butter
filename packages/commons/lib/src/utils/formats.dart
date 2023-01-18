import 'package:intl/intl.dart';

class Formats {
  static String optionalPrecision(double value, [int precision = 1]) =>
      value.toStringAsFixed(value.truncateToDouble() == value ? 0 : precision);

  static String getDayOfWeek(DateTime date) => DateFormat('EEE').format(date);

  static String getMMMdy(DateTime date) => DateFormat('MMM d, y').format(date);

  static String getYYMM(DateTime date) => DateFormat('YYMM').format(date);

  static String getTimeOrDate(DateTime date, {bool local = true}) {
    var format = 'h:mm a';
    final now = DateTime.now();
    final d = date.toLocal();
    if (d.day != now.day || d.month != now.month || d.year != now.year) {
      format = 'MM/dd/y';
    }

    return DateFormat(format).format(local ? date.toLocal() : date);
  }

  static String getDateTime(DateTime date,
          {String separator = '', bool local = true}) =>
      DateFormat('MM/dd/y ${separator.isEmpty ? '' : '$separator '}h:mm a')
          .format(local ? date.toLocal() : date);

  static String getTimestamp(DateTime date) =>
      DateFormat('yMMdd-hhmmss').format(date);

  static String getTimeOrDateTime(DateTime date,
      {String separator = '', bool local = true}) {
    var format = 'h:mm a';
    final now = DateTime.now();
    final d = date.toLocal();
    if (d.day != now.day || d.month != now.month || d.year != now.year) {
      format = 'MM/dd/y ${separator.isEmpty ? '' : '$separator '}h:mm a';
    }

    return DateFormat(format).format(local ? date.toLocal() : date);
  }

  static String getTimeOrDateTimeWithSec(DateTime date,
      {String separator = '', bool local = true}) {
    var format = 'h:mm:ss a';
    final now = DateTime.now();
    final d = date.toLocal();
    if (d.day != now.day || d.month != now.month || d.year != now.year) {
      format = 'MM/dd/y ${separator.isEmpty ? '' : '$separator '}h:mm:ss a';
    }

    return DateFormat(format).format(local ? date.toLocal() : date);
  }

  static String getTimeOrDateTimeWithMS(DateTime date,
      {String separator = '', bool local = true}) {
    var format = 'h:mm:ss.mmm a';
    final now = DateTime.now();
    final d = date.toLocal();
    if (d.day != now.day || d.month != now.month || d.year != now.year) {
      format = 'MM/dd/y ${separator.isEmpty ? '' : '$separator '}h:mm:ss.mmm a';
    }

    return DateFormat(format).format(local ? date.toLocal() : date);
  }

  static DateTime toTimezone(DateTime date, int offset) =>
      date.add(Duration(milliseconds: offset));

  static String getMonth(DateTime date) => DateFormat.MMM().format(date);

  static List<String> getMonths() {
    final m = <String>[];
    for (var i = DateTime.january; i <= DateTime.december; i++) {
      m.add(getMonth(DateTime(DateTime.now().year, i, 1)));
    }

    return m;
  }

  static int getEndOfMonth(int year, int month) {
    final now = DateTime.now();
    return DateTime(now.year, month + 1, 0).day;
  }

  static int getMinYear() => DateTime.now().year - 6;

  static int getMaxYear() => DateTime.now().year + 5;

  static String getTime(DateTime date, {bool local = true}) =>
      DateFormat('h:mm a').format(local ? date.toLocal() : date);

  static String getDate(DateTime date, {bool local = true}) =>
      DateFormat('MM/dd/y').format(local ? date.toLocal() : date);

  static final NumberFormat numberFormatter = NumberFormat('#,##0.00', 'en_US');
  static final NumberFormat numberFormatter2 = NumberFormat('###0.00', 'en_US');
  static String toMoney(double value,
      {bool useParenthesis = false, bool noComma = false}) {
    final val = useParenthesis ? value.abs() : value;
    final formatted =
        noComma ? numberFormatter2.format(val) : numberFormatter.format(val);

    if (useParenthesis) {
      return value >= 0 ? formatted : '($formatted)';
    }

    return formatted;
  }
}
