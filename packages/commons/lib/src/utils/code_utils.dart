import 'string_extension.dart';

class CodeUtils {
  static const ulidLength = 26;
  static const shortCodeLength = 7;
  static String short(String? serial,
          {String defaultValue = '', bool ellipses = false}) =>
      serial == null || serial.trim().isEmpty
          ? defaultValue
          : serial.length != ulidLength
              ? serial
              : '${ellipses ? '...' : ''}${serial.tail(shortCodeLength)}';
}
