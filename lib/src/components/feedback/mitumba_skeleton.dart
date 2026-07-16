import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';

/// Variant style for [MitumbaSkeleton].
enum MitumbaSkeletonVariant {
  rectangular,
  rounded,
  circular,
}

/// A premium, living "Shimmer" Skeleton primitive.
class MitumbaSkeleton extends StatefulWidget {
  const MitumbaSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.variant = MitumbaSkeletonVariant.rounded,
  });

  /// Width of the skeleton block.
  final double? width;

  /// Height of the skeleton block.
  final double? height;

  /// Override the default border radius.
  final double? borderRadius;

  /// Visual variant. Defaults to [MitumbaSkeletonVariant.rounded].
  final MitumbaSkeletonVariant variant;

  @override
  State<MitumbaSkeleton> createState() => _MitumbaSkeletonState();
}

class _MitumbaSkeletonState extends State<MitumbaSkeleton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double radiusValue;
    if (widget.borderRadius != null) {
      radiusValue = widget.borderRadius!;
    } else {
      switch (widget.variant) {
        case MitumbaSkeletonVariant.rectangular:
          radiusValue = MitumbaRadius.xxs; // 2
          break;
        case MitumbaSkeletonVariant.rounded:
          radiusValue = MitumbaRadius.md; // 8
          break;
        case MitumbaSkeletonVariant.circular:
          radiusValue = 9999;
          break;
      }
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Semantics(
          label: 'Loading content...',
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radiusValue),
              color: MitumbaColors.background,
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Base block overlay
                Positioned.fill(
                  child: Container(
                    color: MitumbaColors.divider.withValues(alpha: 0.5),
                  ),
                ),
                // Shimmer wave
                Positioned.fill(
                  child: FractionallySizedBox(
                    widthFactor: 2.0,
                    alignment: Alignment(-2.0 + (_controller.value * 4.0), 0.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Color(0x33FFFFFF), // white with low opacity
                            Colors.transparent,
                          ],
                          stops: [0.35, 0.5, 0.65],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
