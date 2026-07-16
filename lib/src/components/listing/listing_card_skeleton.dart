import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/shadows.dart';
import '../feedback/mitumba_skeleton.dart';

/// Premium Listing Card Skeleton. Perfectly mirrors the ListingCard geometry and spatial density.
class ListingCardSkeleton extends StatelessWidget {
  const ListingCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MitumbaColors.surface,
        borderRadius: BorderRadius.circular(MitumbaRadius.lg),
        border: Border.all(color: MitumbaColors.divider),
        boxShadow: MitumbaShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image skeleton (1:1 Aspect Ratio)
          const AspectRatio(
            aspectRatio: 1.0,
            child: MitumbaSkeleton(
              variant: MitumbaSkeletonVariant.rectangular,
            ),
          ),

          // Content skeleton
          Padding(
            padding: const EdgeInsets.all(20.0), // p: 2.5 * 8 = 20px
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title skeleton
                const MitumbaSkeleton(
                  width: double.infinity,
                  height: 20,
                  variant: MitumbaSkeletonVariant.rectangular,
                ),
                const SizedBox(height: 8),

                // Brand/Size skeleton
                const FractionallySizedBox(
                  widthFactor: 0.4,
                  child: MitumbaSkeleton(
                    height: 12,
                    variant: MitumbaSkeletonVariant.rectangular,
                  ),
                ),
                const SizedBox(height: 24),

                // Footer Row skeleton
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    MitumbaSkeleton(
                      width: 100,
                      height: 32,
                      variant: MitumbaSkeletonVariant.rounded,
                    ),
                    MitumbaSkeleton(
                      width: 80,
                      height: 32,
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
