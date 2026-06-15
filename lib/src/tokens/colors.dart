import 'package:flutter/material.dart';

/// Mitumba brand color tokens — mirrors `@mitumba/tokens` colors.
class MitumbaColors {
  MitumbaColors._();

  // Brand
  static const Color green = Color(0xFF3D9A52);
  static const Color greenLight = Color(0xFFEAF5EC);
  static const Color greenDark = Color(0xFF2C7A3E);
  static const Color earth = Color(0xFFA06235);
  static const Color earthLight = Color(0xFFF5EDE5);
  static const Color earthDark = Color(0xFF7D4A24);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF7F7F5);
  static const Color backgroundDark = Color(0xFF121210);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1C);
  static const Color divider = Color(0xFFEAEAE7);
  static const Color border = Color(0xFFD9D9D5);

  // Text
  static const Color textPrimary = Color(0xFF1A1A18);
  static const Color textSecondary = Color(0xFF6B6B65);
  static const Color textDisabled = Color(0xFFADADA8);
  static const Color textOnGreen = Color(0xFFFFFFFF);
  static const Color textOnEarth = Color(0xFFFFFFFF);

  // Semantic
  static const Color success = Color(0xFF3D9A52);
  static const Color successLight = Color(0xFFEAF5EC);
  static const Color successDark = Color(0xFF2C7A3E);
  static const Color error = Color(0xFFD93025);
  static const Color errorLight = Color(0xFFFCECEB);
  static const Color errorDark = Color(0xFFA52714);
  static const Color warning = Color(0xFFE67E22);
  static const Color warningLight = Color(0xFFFEF3E2);
  static const Color warningDark = Color(0xFFD35400);
  static const Color info = Color(0xFF2E86C1);
  static const Color infoLight = Color(0xFFE8F4FD);
  static const Color infoDark = Color(0xFF1B4F72);

  // STI Score
  static const Color stiTrusted = Color(0xFF3D9A52);
  static const Color stiGood = Color(0xFF2E86C1);
  static const Color stiAtRisk = Color(0xFFE67E22);
  static const Color stiFlagged = Color(0xFFD93025);
  static const Color stiSuspended = Color(0xFF6B6B65);

  /// Legacy aliases for backward compat.
  static const Color primary = green;
  static const Color primaryLight = greenLight;
  static const Color primaryDark = greenDark;
}
