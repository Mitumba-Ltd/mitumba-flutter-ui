import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../layout/mitumba_grid.dart';
import 'vazi_outfit_card.dart';
import 'vazi_outfit_card_skeleton.dart';

/// Premium contextual panel suggesting items to complete a look.
class CompleteThisLookPanel extends StatelessWidget {
  const CompleteThisLookPanel({
    super.key,
    required this.outfits,
    this.loading = false,
  });

  /// VAZI outfit suggestions seeded from the current listing.
  final List<VAZIOutfitCard> outfits;

  /// Whether the outfits are still loading. Shows skeleton cards when true.
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (!loading && outfits.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.auto_awesome,
                    size: 16,
                    color: MitumbaColors.earth,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'AI RECOMMENDATIONS',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: MitumbaColors.earth,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Complete this look',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: MitumbaTypography.fontSizeXl,
                  fontWeight: FontWeight.w900,
                  color: MitumbaColors.textPrimary,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Grid contents
        MitumbaGrid(
          columns: const MitumbaGridColumns(xs: 1, sm: 2, md: 3, lg: 3),
          gap: 24,
          children: loading
              ? List.generate(3, (index) => const VAZIOutfitCardSkeleton())
              : outfits,
        ),
      ],
    );
  }
}
