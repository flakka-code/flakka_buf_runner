import 'dart:io';

import 'package:flakka_buf_runner/flakka_buf_runner.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('buf build', () {
    test('buf build', () async {
      final targetDirectory =
          p.join(Directory.current.path, 'example', 'proto', 'module1');
      final result = await runBufBuild(targetDirectory);
      expect(result, isNotEmpty);
    });
  });
}
