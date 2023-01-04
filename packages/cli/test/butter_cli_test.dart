import 'dart:io';

import 'package:butter_cli/src/butter_cli.dart';
import 'package:io/io.dart';
import 'package:test/test.dart';

void main() {
  group('Normal case tests:', () {
    test('Generate scaffolding', () async {
      final destination = Directory([
        Directory.systemTemp.createTempSync().path,
        'sample_flutter'
      ].join('/'))
          .path;
      await Process.run('cp', ['-R', 'templates/sample_flutter', destination]);
      expect(ButterCLI().perform(['-q', '-s', '-d$destination']),
          equals(ExitCode.success));
      await Process.run('rm', ['-R', destination]);
    });

    test('Show help', () {
      expect(ButterCLI().perform(), equals(ExitCode.usage));
    });
  });
}
