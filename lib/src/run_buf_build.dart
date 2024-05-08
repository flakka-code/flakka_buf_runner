import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:scratch_space/scratch_space.dart';

///
Future<String> runBufBuild(
  String targetDirectory,
) async {
  final scratchSpace = ScratchSpace();

  final output = p.join(scratchSpace.tempDir.path, 'image.txtpb');

  try {
    final args = <String>[
      'build',
      '--output=$output}',
    ];

    final result = await Process.run(
      'buf',
      args,
      workingDirectory: targetDirectory,
    );

    if (result.exitCode != 0) {
      throw Exception('buf failed: ${result.stderr}');
    }

    return File(output).readAsStringSync();
  } finally {
    await scratchSpace.delete();
  }
}
