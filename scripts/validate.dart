import 'common.dart';

Future<void> main() async {
  requireProjectRoot();
  await requireFlutter();
  await requireDart();
  await runCommand('flutter', const <String>['pub', 'get']);
  await runCommand('dart', const <String>[
    'format',
    '--output=none',
    '--set-exit-if-changed',
    'lib',
    'test',
    'scripts',
  ]);
  await runCommand('flutter', const <String>[
    'analyze',
    'lib',
    'test',
    'scripts',
  ]);
  await runCommand('flutter', const <String>['test']);
  report('\nValidação concluída com sucesso.');
}
