import 'package:flutter/material.dart';

/// Mitumba typography tokens — mirrors `@mitumba/tokens` typography.
class MitumbaTypography {
  MitumbaTypography._();

  static const String fontFamily = 'Nunito';

  // Font weights
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extrabold = FontWeight.w800;

  // Font sizes
  static const double fontSizeXs = 11;
  static const double fontSizeSm = 12;
  static const double fontSizeBase = 14;
  static const double fontSizeMd = 16;
  static const double fontSizeLg = 18;
  static const double fontSizeXl = 20;
  static const double fontSizeXxl = 22;
  static const double fontSizeXxxl = 26;
  static const double fontSizeDisplay = 32;

  // Line heights
  static const double lineHeightTight = 1.2;
  static const double lineHeightSnug = 1.35;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.6;

  // Pre-composed styles
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeDisplay,
    fontWeight: extrabold,
    height: 1.1,
  );
  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXxxl,
    fontWeight: bold,
    height: lineHeightTight,
  );
  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXxl,
    fontWeight: bold,
    height: lineHeightTight,
  );
  static const TextStyle h4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXl,
    fontWeight: bold,
    height: lineHeightTight,
  );
  static const TextStyle h5 = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeLg,
    fontWeight: semibold,
    height: lineHeightSnug,
  );
  static const TextStyle body1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeMd,
    fontWeight: regular,
    height: lineHeightNormal,
  );
  static const TextStyle body2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeBase,
    fontWeight: regular,
    height: lineHeightNormal,
  );
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeSm,
    fontWeight: medium,
    height: lineHeightNormal,
  );
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeBase,
    fontWeight: semibold,
    height: lineHeightNormal,
  );

  /// Overline — small uppercase label text.
  static const TextStyle overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXs,
    fontWeight: semibold,
    height: lineHeightNormal,
    letterSpacing: 1.5,
  );
}
