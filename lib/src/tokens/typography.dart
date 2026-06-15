import 'package:flutter/material.dart';

/// Mitumba typography tokens.
class MitumbaTypography {
  MitumbaTypography._();

  static const String fontFamily = 'OpenSans';

  static const TextStyle h1 = TextStyle(fontFamily: fontFamily, fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.5);
  static const TextStyle h2 = TextStyle(fontFamily: fontFamily, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5);
  static const TextStyle h3 = TextStyle(fontFamily: fontFamily, fontSize: 24, fontWeight: FontWeight.w800);
  static const TextStyle h4 = TextStyle(fontFamily: fontFamily, fontSize: 20, fontWeight: FontWeight.w800);
  static const TextStyle h5 = TextStyle(fontFamily: fontFamily, fontSize: 18, fontWeight: FontWeight.w700);
  static const TextStyle body1 = TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w400);
  static const TextStyle body2 = TextStyle(fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w400);
  static const TextStyle caption = TextStyle(fontFamily: fontFamily, fontSize: 12, fontWeight: FontWeight.w500);
  static const TextStyle button = TextStyle(fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w700);
}
