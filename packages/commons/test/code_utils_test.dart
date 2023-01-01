import 'package:butter_commons/butter_commons.dart';
import 'package:test/test.dart';
import 'package:ulid/ulid.dart';

void main() {
  group('CodeUtils', () {
    test('short() normal use', () {
      final serial = Ulid().toString().toUpperCase();
      final shortSerial = CodeUtils.short(serial);
      expect(shortSerial.length, CodeUtils.shortCodeLength);
      expect(serial.endsWith(shortSerial), true);
    });

    test('short() bad usage', () {
      const serial = 'ABC';
      final shortSerial = CodeUtils.short(serial);
      expect(shortSerial.length, lessThan(CodeUtils.shortCodeLength));
      expect(serial.endsWith(shortSerial), true);
    });
  });
}
