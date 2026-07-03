import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// STI (Seller Trust Index) tier classification.
enum STITier { trusted, good, atRisk, flagged, suspended }

/// Returns STI tier config for a given score.
({Color color, String label, STITier tier}) _stiTierFromScore(int score) {
  if (score >= 80) return (color: MitumbaColors.stiTrusted, label: 'Trusted', tier: STITier.trusted);
  if (score >= 60) return (color: MitumbaColors.stiGood, label: 'Good', tier: STITier.good);
  if (score >= 40) return (color: MitumbaColors.stiAtRisk, label: 'At risk', tier: STITier.atRisk);
  if (score >= 20) return (color: MitumbaColors.stiFlagged, label: 'Flagged', tier: STITier.flagged);
  return (color: MitumbaColors.stiSuspended, label: 'Suspended', tier: STITier.suspended);
}

/// Standalone STI Score chip — displays seller trust score with color coding.
///
/// Mirrors the web `STIScoreChip` from `@mitumba/ui`.
///
/// ```dart
/// STIScoreChip(score: 85)
/// STIScoreChip(score: 45, compact: true)
/// ```
class STIScoreChip extends StatelessWidget {
  /// Creates an STI score chip.
  const STIScoreChip({
    super.key,
    required this.score,
    this.compact = false,
    this.showLabel = false,
  });

  /// STI score (0–100).
  final int score;

  /// Compact mode — smaller, no label.
  final bool compact;

  /// Whether to show the tier label (e.g. "Trusted").
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final config = _stiTierFromScore(score.clamp(0, 100));

    return Semantics(
      label: 'STI Score: $score, ${config.label}',
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? MitumbaSpacing.sm : MitumbaSpacing.md,
          vertical: compact ? 2 : 4,
        ),
        decoration: BoxDecoration(
          color: config.color.withAlpha(18),
          borderRadius: BorderRadius.circular(MitumbaRadius.full),
          border: Border.all(color: config.color.withAlpha(50)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: compact ? 6 : 8,
              height: compact ? 6 : 8,
              decoration: BoxDecoration(
                color: config.color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: MitumbaSpacing.xs),
            Text(
              '$score',
              style: TextStyle(
                fontFamily: MitumbaTypography.fontFamily,
                fontSize: compact ? MitumbaTypography.fontSizeXs : MitumbaTypography.fontSizeSm,
                fontWeight: FontWeight.w700,
                color: config.color,
              ),
            ),
            if (showLabel) ...[
              SizedBox(width: MitumbaSpacing.xs),
              Text(
                config.label,
                style: TextStyle(
                  fontFamily: MitumbaTypography.fontFamily,
                  fontSize: MitumbaTypography.fontSizeXs,
                  fontWeight: FontWeight.w500,
                  color: config.color,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
