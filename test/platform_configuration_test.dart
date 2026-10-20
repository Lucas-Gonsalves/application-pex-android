import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Web usa MOVE como título e o favicon oficial', () {
    final html = File('web/index.html').readAsStringSync();
    final manifest =
        jsonDecode(File('web/manifest.json').readAsStringSync())
            as Map<String, dynamic>;

    expect(html, contains('<title>MOVE</title>'));
    expect(html, contains('name="apple-mobile-web-app-title" content="MOVE"'));
    expect(html, contains('href="icons/icon-move.ico"'));
    expect(File('web/icons/icon-move.ico').existsSync(), isTrue);
    expect(manifest['name'], 'MOVE');
    expect(manifest['short_name'], 'MOVE');
    for (final icon in manifest['icons'] as List<dynamic>) {
      final source = (icon as Map<String, dynamic>)['src'] as String;
      expect(File('web/$source').existsSync(), isTrue, reason: source);
    }
  });

  test('Android exibe MOVE sem trocar o identificador técnico', () {
    final manifest = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();

    expect(manifest, contains('android:label="MOVE"'));
    expect(manifest, contains(r'android:name="${applicationName}"'));
  });
}
