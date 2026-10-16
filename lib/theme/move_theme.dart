import 'package:flutter/material.dart';

abstract final class MoveColors {
  static const navy = Color(0xFF082858);
  static const deepNavy = Color(0xFF031B43);
  static const blue = Color(0xFF0A2F68);
  static const yellow = Color(0xFFFFC400);
  static const yellowHighlight = Color(0xFFFFCA05);
  static const paleBlue = Color(0xFFEEF7FF);
  static const secondaryText = Color(0xFF667FA7);
  static const divider = Color(0xFFDCE5F0);
  static const offWhite = Color(0xFFFCFCFD);
}

abstract final class MoveLayout {
  static const double maxContentWidth = 1280;

  static double horizontalPagePadding(double width) {
    if (width < 360) {
      return 16;
    }
    if (width < 600) {
      return 20;
    }
    return 40;
  }
}

ThemeData buildMoveTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: MoveColors.navy,
    primary: MoveColors.navy,
    secondary: MoveColors.yellow,
    surface: Colors.white,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: MoveColors.secondaryText),
    ),
  );
}
