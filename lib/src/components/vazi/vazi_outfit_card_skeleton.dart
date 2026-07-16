import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/shadows.dart';
import '../feedback/mitumba_skeleton.dart';

/// Premium VAZI Outfit Card Skeleton loader.
class VAZIOutfitCardSkeleton extends StatelessWidget {
  const VAZIOutfitCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MitumbaColors.surface,
        borderRadius: BorderRadius.circular(MitumbaRadius.lg),
        boxShadow: MitumbaShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Collage Area Skeleton
          Container(
            height: 280,
            width: double.infinity,
            color: MitumbaColors.background,
            child: Center(
              child: SizedBox(
                width: 140,
                height: 180,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: const [
                    // Peeking Stack Item
                    Positioned(
                      top: 4,
                      left: -12,
                      width: 140,
                      height: 180,
                      child: Opacity(
                        opacity: 0.5,
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation(-4 / 360),
                          child: MitumbaSkeleton(
                            variant: MitumbaSkeletonVariant.rectangular,
                            borderRadius: 8,
                          ),
                        ),
                      ),
                    ),

                    // Main Stack Item
                    Positioned(
                      top: 0,
                      left: 0,
                      width: 140,
                      height: 180,
                      child: MitumbaSkeleton(
                        variant: MitumbaSkeletonVariant.rectangular,
                        borderRadius: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content Area Skeleton
          Padding(
            padding: const EdgeInsets.all(20.0), // p: 2.5 * 8 = 20px
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title skeleton
                const MitumbaSkeleton(
                  width: 160,
                  height: 24,
                  variant: MitumbaSkeletonVariant.rectangular,
                ),
                const SizedBox(height: 8),

                // Sellers info skeleton
                const MitumbaSkeleton(
                  width: 90,
                  height: 12,
                  variant: MitumbaSkeletonVariant.rectangular,
                ),
                const SizedBox(height: 24),

                // Footer Row skeleton
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        MitumbaSkeleton(
                          width: 60,
                          height: 10,
                          variant: MitumbaSkeletonVariant.rectangular,
                        ),
                        SizedBox(height: 4),
                        MitumbaSkeleton(
                          width: 100,
                          height: 28,
                          variant: MitumbaSkeletonVariant.rectangular,
                        ),
                      ],
                    ),
                    const MitumbaSkeleton(
                      width: 120,
                      height: 36,
                      variant: MitumbaSkeletonVariant.rounded,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
