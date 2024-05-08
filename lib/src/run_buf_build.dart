import 'dart:io';
import 'dart:typed_data';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;
import 'package:scratch_space/scratch_space.dart';

///
Future<Uint8List> runBufBuild2(
  AssetReader assetReader,
  String targetDirectory, {
  String format = 'binpb',
}) async {
  final protoAssets = await assetReader
      .findAssets(Glob(p.join(targetDirectory, '**', '*.proto')))
      .toList();
  assert(protoAssets.isNotEmpty, '');

  final bufAsset = (await assetReader
          .findAssets(Glob(p.join(targetDirectory, 'buf.yaml')))
          .toList())
      .single;

  final scratchSpace = ScratchSpace();

  await scratchSpace.ensureAssets(protoAssets, assetReader);
  await scratchSpace.ensureAssets([bufAsset], assetReader);

  final output = p.join(scratchSpace.tempDir.path, 'image.$format');

  try {
    final args = <String>[
      'build',
      '--output=$output',
    ];
    final result = await Process.run(
      'buf',
      args,
      workingDirectory: targetDirectory,
    );

    if (result.exitCode != 0) {
      throw Exception('buf failed: ${result.stderr}\nargs: $args');
    }

    return File(output).readAsBytes();
  } finally {
    await scratchSpace.delete();
  }
}
