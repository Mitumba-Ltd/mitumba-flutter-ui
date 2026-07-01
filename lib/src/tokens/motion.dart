import 'package:flutter/animation.dart';

/// Mitumba motion tokens — mirrors `@mitumba/tokens` motion.
class MitumbaMotion {
  MitumbaMotion._();

  // Durations
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration deliberate = Duration(milliseconds: 600);
  static const Duration dramatic = Duration(milliseconds: 800);

  // Easing curves
  static const Curve standard = Curves.easeInOut;
  static const Curve enter = Curves.easeOut;
  static const Curve exit = Curves.easeIn;
  static const spring = Cubic(0.34, 1.56, 0.64, 1);
  static const smooth = Cubic(0.65, 0, 0.35, 1);

  /// Named alias for the spring curve — use for interactive bounce effects.
  static const Cubic springCurve = spring;

  /// Pre-composed transition string for interaction feedback.
  static const Duration interaction = fast;
}
