import 'common.dart';

Future<void> main() async {
  requireProjectRoot();
  await requireFlutter();
  requireAndroidReleaseSigning();
  await runCommand('flutter', const <String>['pub', 'get']);
  await runCommand('flutter', const <String>['build', 'apk', '--release']);
  requireFile('build/app/outputs/flutter-apk/app-release.apk');
  await runCommand(
    'flutter',
    const <String>['build', 'appbundle', '--release'],
  );
  requireFile('build/app/outputs/bundle/release/app-release.aab');
}
