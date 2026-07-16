import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../layout/mitumba_grid.dart';
import 'vazi_outfit_card.dart';
import 'vazi_outfit_card_skeleton.dart';

/// Premium VAZI Feed Section. Engineered for high-fidelity curation display.
class VAZIFeedSection extends StatelessWidget {
  const VAZIFeedSection({
    super.key,
    required this.outfits,
    this.loading = false,
    this.onSeeAll,
  });

  /// VAZI outfits to display in the section.
  final List<VAZIOutfitCard> outfits;

  /// Whether the outfits are still loading. Shows skeleton cards when true.
  final bool loading;

  /// Called when the user presses "Explore All".
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.auto_awesome,
                        size: 18,
                        color: MitumbaColors.earth,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'AI CURATION',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: MitumbaColors.earth,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'VAZI Picks for You',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: MitumbaTypography.fontSizeXxl,
                      fontWeight: FontWeight.w900,
                      color: MitumbaColors.textPrimary,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
              if (onSeeAll != null)
                GestureDetector(
                  onTap: onSeeAll,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'EXPLORE ALL',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: MitumbaColors.earth,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: MitumbaColors.earth,
                        ),
                      ],
                    ),
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
