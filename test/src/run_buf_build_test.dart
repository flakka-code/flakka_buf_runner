import 'package:build_test/build_test.dart';
import 'package:flakka_buf_runner/flakka_buf_runner.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test('buf build', () async {
    final assetReader = await PackageAssetReader.currentIsolate(
      rootPackage: 'flakka_buf_runner',
    );

    final bufYamlAssetIds =
        await assetReader.findAssets(Glob('test_proto/**/buf.yaml')).toList();
    assert(bufYamlAssetIds.isNotEmpty, '');

    final targetDirectory = p.joinAll(
      bufYamlAssetIds.single.pathSegments
          .skip(bufYamlAssetIds.first.pathSegments.length - 3)
          .take(2),
    );

    final result = await runBufBuild2(assetReader, targetDirectory);

    expect(result, isNotEmpty);
  });
}
