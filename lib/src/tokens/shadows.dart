import 'package:flutter/material.dart';

/// Mitumba shadow tokens — mirrors `@mitumba/tokens` shadows.
class MitumbaShadows {
  MitumbaShadows._();

  static const card = [
    BoxShadow(offset: Offset(0, 1), blurRadius: 3, color: Color(0x0F000000)),
    BoxShadow(offset: Offset(0, 1), blurRadius: 2, color: Color(0x1F000000)),
  ];

  static const elevated = [
    BoxShadow(offset: Offset(0, 4), blurRadius: 6, spreadRadius: -1, color: Color(0x1A000000)),
    BoxShadow(offset: Offset(0, 2), blurRadius: 4, spreadRadius: -1, color: Color(0x0F000000)),
  ];

  static const deep = [
    BoxShadow(offset: Offset(0, 10), blurRadius: 15, spreadRadius: -3, color: Color(0x1A000000)),
    BoxShadow(offset: Offset(0, 4), blurRadius: 6, spreadRadius: -2, color: Color(0x0D000000)),
  ];

  static const bottomSheet = [
    BoxShadow(offset: Offset(0, -4), blurRadius: 24, color: Color(0x14000000)),
  ];

  static const focus = [
    BoxShadow(blurRadius: 0, spreadRadius: 3, color: Color(0x403D9A52)),
  ];

  static const green = [
    BoxShadow(offset: Offset(0, 8), blurRadius: 20, color: Color(0x333D9A52)),
  ];

  static const earth = [
    BoxShadow(offset: Offset(0, 8), blurRadius: 20, color: Color(0x33A06235)),
  ];

  /// No shadow — explicit empty list for toggling shadows off.
  static const List<BoxShadow> none = [];
}
