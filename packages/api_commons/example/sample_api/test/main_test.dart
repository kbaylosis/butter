import 'dart:io';

import 'package:butter_api_commons/butter_api_commons.dart';
import 'package:conduit_open_api/v3.dart';
import 'package:sample_api/channel.dart';
import 'package:test/test.dart';

void main() async {
  group('Server launch:', () {
    test('Single process', () async {
      final app = await BaseChannel.initApp<TestChannel>(
          args: ['-n1'], configFile: 'config.yaml');
      expect(app.isRunning, true);
      expect(app.supervisors.length, 1);

      await Future.delayed(const Duration(seconds: 10));

      expect(await app.stop(), isNot(throwsA(anything)));
    });

    test('Multi process (default spawns)',
        skip: Platform.numberOfProcessors ~/ 2 < 2, () async {
      final app =
          await BaseChannel.initApp<TestChannel>(configFile: 'config.yaml');
      expect(app.isRunning, true);
      expect(app.supervisors.length, greaterThan(1));

      await Future.delayed(const Duration(seconds: 10));

      expect(await app.stop(), isNot(throwsA(anything)));
    });
  });

  group('Generate Documentation', () {
    test('', () async {
      late APIDocument result;
      expect(
          result =
              await BaseChannel.testDoc<TestChannel>(configFile: 'config.yaml'),
          isNot(throwsA(anything)));

      late VersionConfig version;
      expect(
          version = VersionConfig('./pubspec.yaml'), isNot(throwsA(anything)));

      expect(result.info.title, equals(version.name));
      expect(result.info.version, equals(version.version));
    });
  });
}
