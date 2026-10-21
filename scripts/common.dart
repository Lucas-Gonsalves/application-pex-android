import 'dart:io';

void requireProjectRoot() {
  if (!File('pubspec.yaml').existsSync()) {
    fail('Execute este script a partir da raiz do projeto.');
  }
}

Future<void> requireFlutter() async {
  await runCommand(
    'flutter',
    const <String>['--version'],
    missingToolMessage:
        'Flutter SDK não encontrado no PATH. Instale o Flutter e execute flutter doctor.',
  );
}

Future<void> requireDart() async {
  await runCommand(
    'dart',
    const <String>['--version'],
    missingToolMessage:
        'Dart SDK não encontrado no PATH. O SDK acompanha a instalação do Flutter.',
  );
}

Future<void> runCommand(
  String executable,
  List<String> arguments, {
  String? missingToolMessage,
}) async {
  stdout.writeln('\n> $executable ${arguments.join(' ')}');

  try {
    final process = await Process.start(
      executable,
      arguments,
      mode: ProcessStartMode.inheritStdio,
      runInShell: Platform.isWindows,
    );
    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      exit(exitCode);
    }
  } on ProcessException {
    fail(missingToolMessage ?? 'Não foi possível executar $executable.');
  }
}

void requireFile(String path) {
  if (!File(path).existsSync()) {
    fail('Artefato não foi gerado: $path');
  }

  stdout.writeln('Artefato gerado: $path');
}

void requireAndroidReleaseSigning() {
  final propertiesFile = File('android/key.properties');
  if (!propertiesFile.existsSync()) {
    fail(
      'Assinatura de release ausente. Configure android/key.properties antes de gerar artefatos Android.',
    );
  }

  final properties = <String, String>{};
  for (final line in propertiesFile.readAsLinesSync()) {
    final trimmedLine = line.trim();
    if (trimmedLine.isEmpty || trimmedLine.startsWith('#')) {
      continue;
    }

    final separator = trimmedLine.indexOf('=');
    if (separator == -1) {
      continue;
    }

    properties[trimmedLine.substring(0, separator).trim()] =
        trimmedLine.substring(separator + 1).trim();
  }

  const requiredProperties = <String>[
    'storePassword',
    'keyPassword',
    'keyAlias',
    'storeFile',
  ];
  if (requiredProperties.any(
    (String name) => (properties[name] ?? '').isEmpty,
  )) {
    fail('android/key.properties não contém todos os dados da assinatura.');
  }

  final androidAppUri = Directory('android/app').absolute.uri;
  final storeFile = File.fromUri(
    androidAppUri.resolve(properties['storeFile']!),
  );
  if (!storeFile.existsSync()) {
    fail('O arquivo de chave configurado em android/key.properties não existe.');
  }
}

Never fail(String message) {
  stderr.writeln('\nErro: $message');
  exit(1);
}
