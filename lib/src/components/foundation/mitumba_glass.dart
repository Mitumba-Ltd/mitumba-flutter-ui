import 'dart:ui';
import 'package:flutter/material.dart';
import '../../tokens/radius.dart';

enum MitumbaGlassRounding { rounded, large, huge, full }

/// A premium glassmorphism container engineered for high-end optical depth with benchmarked blur and light-leak effects.
class MitumbaGlass extends StatelessWidget {
  const MitumbaGlass({
    super.key,
    required this.child,
    this.blur = 24.0,
    this.opacity = 0.5,
    this.rounding = MitumbaGlassRounding.large,
    this.border = true,
  });

  /// Content to be rendered inside the glass pane.
  final Widget child;

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
    double radiusValue = MitumbaRadius.lg; // 16px
    if (rounding == MitumbaGlassRounding.rounded) {
      radiusValue = MitumbaRadius.md; // 8px
    } else if (rounding == MitumbaGlassRounding.huge) {
      radiusValue = MitumbaRadius.xl; // 24px
    } else if (rounding == MitumbaGlassRounding.full) {
      radiusValue = MitumbaRadius.full; // 9999px
    }

    final borderRadius = BorderRadius.circular(radiusValue);

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
          BoxShadow(
            color: const Color(0xFF1F2687).withOpacity(0.1),
            offset: const Offset(0, 12),
            blurRadius: 32,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(opacity),
              borderRadius: borderRadius,
              border: border
                  ? Border.all(color: Colors.white.withOpacity(0.4), width: 1.0)
                  : null,
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0.0),
                            Colors.white.withOpacity(0.0),
                            Colors.white.withOpacity(0.1),
                          ],
                          stops: const [0.0, 0.4, 0.6, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
