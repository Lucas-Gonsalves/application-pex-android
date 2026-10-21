import 'common.dart';

Future<void> main() async {
  requireProjectRoot();
  await requireFlutter();
  await runCommand(
    'flutter',
    const <String>['pub', 'get'],
  );
  await runCommand(
    'flutter',
    const <String>['build', 'web', '--release'],
  );
  requireFile('build/web/index.html');
  requireFile('build/web/manifest.json');
}
