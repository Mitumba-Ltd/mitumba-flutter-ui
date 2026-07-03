import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/typography.dart';

/// Condition grade for a listing item.
enum ConditionGrade { newWithTags, excellent, good, fair }

const _gradeLabels = {
  ConditionGrade.newWithTags: 'New',
  ConditionGrade.excellent: 'Like New',
  ConditionGrade.good: 'Good',
  ConditionGrade.fair: 'Fair',
};

const _gradeColors = {
  ConditionGrade.newWithTags: MitumbaColors.green,
  ConditionGrade.excellent: MitumbaColors.info,
  ConditionGrade.good: MitumbaColors.earth,
  ConditionGrade.fair: MitumbaColors.warning,
};

/// Standalone condition badge — displays item condition with color-coded styling.
///
/// Mirrors the web `ConditionBadge` from `@mitumba/ui`.
///
/// ```dart
/// ConditionBadge(grade: ConditionGrade.excellent)
/// ```
class ConditionBadge extends StatelessWidget {
  /// Creates a condition badge.
  const ConditionBadge({
    super.key,
    required this.grade,
    this.size = ConditionBadgeSize.small,
  });

  /// The condition grade to display.
  final ConditionGrade grade;

  /// Badge size variant.
  final ConditionBadgeSize size;

  @override
  Widget build(BuildContext context) {
    final color = _gradeColors[grade]!;
    final label = _gradeLabels[grade]!;
    final isLarge = size == ConditionBadgeSize.medium;

    return Semantics(
      label: 'Condition: $label',
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isLarge ? 10 : 8,
          vertical: isLarge ? 4 : 2,
        ),
        decoration: BoxDecoration(
          color: color.withAlpha(18),
          borderRadius: BorderRadius.circular(MitumbaRadius.sm),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Text(
          label,
          style: MitumbaTypography.caption.copyWith(
            fontSize: isLarge ? MitumbaTypography.fontSizeSm : MitumbaTypography.fontSizeXs,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}

/// Size variant for [ConditionBadge].
enum ConditionBadgeSize { small, medium }
