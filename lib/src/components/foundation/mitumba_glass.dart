import 'dart:ui';
import 'package:flutter/material.dart';
import '../../tokens/radius.dart';

enum MitumbaGlassRounding { rounded, large, huge, full }

/// A premium glassmorphism container engineered for high-end optical depth.
class MitumbaGlass extends StatelessWidget {
  const MitumbaGlass({
    super.key,
    required this.children,
    this.blur = 24.0,
    this.opacity = 0.5,
    this.rounding = MitumbaGlassRounding.large,
    this.border = true,
  });

  /// Content to be rendered inside the glass pane.
  final Widget children;

  /// Blur intensity in pixels.
  final double blur;

  /// Background opacity (0 to 1).
  final double opacity;

  /// Corner geometry.
  final MitumbaGlassRounding rounding;

  /// Optional border visibility.
  final bool border;

  @override
  Widget build(BuildContext context) {
    // Basic setup for structure — to be refined in subsequent commits
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white24,
      ),
      child: children,
    );
  }
}
