import 'package:flutter/material.dart';

import 'screens/move_home_page.dart';
import 'theme/move_theme.dart';

void main() {
  runApp(const MoveApp());
}

class MoveApp extends StatelessWidget {
  const MoveApp({super.key, this.launchUri});

  final ContactUriLauncher? launchUri;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MOVE',
      debugShowCheckedModeBanner: false,
      theme: buildMoveTheme(),
      home: MoveHomePage(launchUri: launchUri),
    );
  }
}
