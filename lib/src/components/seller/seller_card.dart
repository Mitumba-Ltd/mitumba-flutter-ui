import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Returns the STI color and label for a given score.
({Color color, String label}) _stiConfig(int score) {
  if (score >= 80) return (color: MitumbaColors.stiTrusted, label: 'Trusted');
  if (score >= 60) return (color: MitumbaColors.stiGood, label: 'Good');
  if (score >= 40) return (color: MitumbaColors.stiAtRisk, label: 'At risk');
  if (score >= 20) return (color: MitumbaColors.stiFlagged, label: 'Flagged');
  return (color: MitumbaColors.stiSuspended, label: 'Suspended');
}

/// Compact seller profile card — avatar, name, city, STI score, listings,
/// optional action button.
///
/// Mirrors the web `SellerCard` from `@mitumba/ui`.
///
/// ```dart
/// SellerCard(
///   sellerId: 's1',
///   name: 'Mama Njeri',
///   city: 'Nairobi',
///   stiScore: 85,
///   totalListings: 42,
///   onTap: () {},
/// )
/// ```
class SellerCard extends StatelessWidget {
  /// Creates a seller card.
  const SellerCard({
    super.key,
    required this.sellerId,
    required this.name,
    required this.city,
    required this.stiScore,
    required this.totalListings,
    this.avatarUrl,
    this.isVaziFeatured = false,
    this.onTap,
    this.actionLabel,
    this.onAction,
  });

  /// Unique seller identifier.
  final String sellerId;

  /// Display name.
  final String name;

  /// City where the seller is based.
  final String city;

  /// STI score (0–100).
  final int stiScore;

  /// Total listings count.
  final int totalListings;

  /// Avatar image URL (optional).
  final String? avatarUrl;

  /// Whether VAZI-featured.
  final bool isVaziFeatured;

  /// Called when card is tapped.
  final VoidCallback? onTap;

  /// Action button label (e.g. "Visit Store").
  final String? actionLabel;

  /// Called when action button is tapped.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final sti = _stiConfig(stiScore.clamp(0, 100));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(MitumbaSpacing.lg),
        decoration: BoxDecoration(
          color: MitumbaColors.surface,
          border: Border.all(color: MitumbaColors.divider),
          borderRadius: BorderRadius.circular(MitumbaRadius.lg),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _Avatar(name: name, url: avatarUrl),
                SizedBox(width: MitumbaSpacing.base),
                Expanded(child: _Info(
                  name: name,
                  city: city,
                  totalListings: totalListings,
                  isVaziFeatured: isVaziFeatured,
                )),
                _StiChip(score: stiScore, color: sti.color, label: sti.label),
              ],
            ),
            if (actionLabel != null) ...[
              SizedBox(height: MitumbaSpacing.md),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => onAction?.call(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: MitumbaColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(MitumbaRadius.md),
                    ),
                    textStyle: MitumbaTypography.caption.copyWith(fontWeight: FontWeight.w600),
                  ),
                  child: Text(actionLabel!, style: const TextStyle(color: MitumbaColors.textPrimary)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, this.url});
  final String name;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: MitumbaColors.greenLight,
      backgroundImage: url != null ? NetworkImage(url!) : null,
      child: url == null
          ? Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(
                color: MitumbaColors.green,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            )
          : null,
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.name, required this.city, required this.totalListings, required this.isVaziFeatured});
  final String name;
  final String city;
  final int totalListings;
  final bool isVaziFeatured;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: MitumbaTypography.body2.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            if (isVaziFeatured) ...[
              SizedBox(width: MitumbaSpacing.sm),
              Container(
                padding: EdgeInsets.symmetric(horizontal: MitumbaSpacing.xs, vertical: 2),
                decoration: BoxDecoration(
                  color: MitumbaColors.earthLight,
                  borderRadius: BorderRadius.circular(MitumbaRadius.sm),
                ),
                child: const Text('VAZI', style: TextStyle(
                  color: MitumbaColors.earth,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                )),
              ),
            ],
          ],
        ),
        const SizedBox(height: 2),
        Text(
          '$city · $totalListings ${totalListings == 1 ? 'listing' : 'listings'}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: MitumbaTypography.caption.copyWith(color: MitumbaColors.textSecondary),
        ),
      ],
    );
  }
}

class _StiChip extends StatelessWidget {
  const _StiChip({required this.score, required this.color, required this.label});
  final int score;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'STI Score: $score, $label',
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: MitumbaSpacing.sm, vertical: 2),
        decoration: BoxDecoration(
          color: color.withAlpha(18),
          borderRadius: BorderRadius.circular(MitumbaRadius.full),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            SizedBox(width: MitumbaSpacing.xs),
            Text(
              '$score',
              style: TextStyle(
                fontFamily: MitumbaTypography.fontFamily,
                fontSize: MitumbaTypography.fontSizeSm,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
