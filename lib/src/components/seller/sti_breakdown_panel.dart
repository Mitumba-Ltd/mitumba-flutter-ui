import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// An event in the Seller Trust Index breakdown activity list.
class STIEvent {
  const STIEvent({
    required this.type,
    required this.reason,
    required this.timestamp,
    required this.pointsChange,
  });

  final String type; // 'positive' | 'negative'
  final String reason;
  final String timestamp;
  final int pointsChange;
}

/// Premium STIBreakdownPanel displaying seller trust details.
/// Features a circular progress score indicator, factor bars, and recent event logs.
class STIBreakdownPanel extends StatelessWidget {
  const STIBreakdownPanel({
    super.key,
    required this.score,
    required this.fulfillmentRate,
    required this.accuracyRate,
    required this.avgResponseHours,
    required this.daysActive,
    required this.recentEvents,
  });

  final int score;
  final double fulfillmentRate;
  final double accuracyRate;
  final double avgResponseHours;
  final int daysActive;
  final List<STIEvent> recentEvents;

  Color _getScoreColor() {
    if (score >= 80) return const Color(0xFF0F973D); // Trusted
    if (score >= 60) return const Color(0xFFE6B800); // Good
    if (score >= 40) return const Color(0xFFF2994A); // At Risk
    return const Color(0xFFD32F2F); // Flagged
  }

  String _getScoreLabel() {
    if (score >= 80) return 'Trusted';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'At Risk';
    return 'Flagged';
  }

  @override
  Widget build(BuildContext context) {
    final scoreColor = _getScoreColor();
    final scoreLabel = _getScoreLabel();

    final factors = [
      _FactorData(
        label: 'Order fulfillment',
        value: fulfillmentRate,
        display: '${(fulfillmentRate * 100).round()}%',
      ),
      _FactorData(
        label: 'Listing accuracy',
        value: accuracyRate,
        display: '${(accuracyRate * 100).round()}%',
      ),
      _FactorData(
        label: 'Avg. response time',
        value: null,
        display: '${avgResponseHours.toStringAsFixed(1)}h',
      ),
      _FactorData(
        label: 'Days active',
        value: null,
        display: '$daysActive',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: MitumbaColors.surface,
        borderRadius: BorderRadius.circular(MitumbaRadius.xl),
        border: Border.all(color: MitumbaColors.divider),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - circular ring indicator
          Padding(
            padding: const EdgeInsets.all(MitumbaSpacing.xl),
            child: Row(
              children: [
                // Score circular progress ring
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 72,
                      height: 72,
                      child: CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 4,
                        color: MitumbaColors.background,
                      ),
                    ),
                    SizedBox(
                      width: 72,
                      height: 72,
                      child: CircularProgressIndicator(
                        value: score / 100.0,
                        strokeWidth: 4,
                        color: scoreColor,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$score',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: scoreColor,
                            height: 1.0,
                          ),
                        ),
                        const Text(
                          '/ 100',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: MitumbaColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: MitumbaSpacing.xl),

                // Labels
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Seller Trust Index',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: MitumbaTypography.fontSizeLg,
                          fontWeight: FontWeight.w700,
                          color: MitumbaColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: scoreColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: MitumbaSpacing.xs),
                          Text(
                            scoreLabel,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: MitumbaTypography.fontSizeSm,
                              fontWeight: FontWeight.w600,
                              color: scoreColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Factor Bars
          Padding(
            padding: const EdgeInsets.only(
              left: MitumbaSpacing.xl,
              right: MitumbaSpacing.xl,
              bottom: MitumbaSpacing.xl,
            ),
            child: Column(
              children: factors.map((factor) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: MitumbaSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            factor.label,
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: MitumbaTypography.fontSizeSm,
                              color: MitumbaColors.textSecondary,
                            ),
                          ),
                          Text(
                            factor.display,
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: MitumbaTypography.fontSizeSm,
                              fontWeight: FontWeight.w700,
                              color: MitumbaColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      if (factor.value != null) ...[
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(MitumbaRadius.full),
                          child: SizedBox(
                            height: 6,
                            child: LinearProgressIndicator(
                              value: factor.value,
                              color: scoreColor,
                              backgroundColor: MitumbaColors.background,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // Recent activity logs
          if (recentEvents.isNotEmpty) ...[
            Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: MitumbaColors.divider)),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: MitumbaSpacing.xl,
                vertical: MitumbaSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recent activity',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: MitumbaTypography.fontSizeSm,
                      fontWeight: FontWeight.w700,
                      color: MitumbaColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: MitumbaSpacing.md),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recentEvents.length,
                    itemBuilder: (context, index) {
                      final event = recentEvents[index];
                      final isPositive = event.type == 'positive';
                      final color = isPositive
                          ? const Color(0xFF0F973D)
                          : const Color(0xFFD32F2F);
                      final bgColor = color.withValues(alpha: 0.1);

                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: MitumbaSpacing.sm),
                        decoration: BoxDecoration(
                          border: index != recentEvents.length - 1
                              ? const Border(bottom: BorderSide(color: MitumbaColors.divider))
                              : null,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: bgColor,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                isPositive ? Icons.trending_up : Icons.trending_down,
                                size: 14,
                                color: color,
                              ),
                            ),
                            const SizedBox(width: MitumbaSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.reason,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: MitumbaTypography.fontSizeSm,
                                      fontWeight: FontWeight.w500,
                                      color: MitumbaColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    event.timestamp,
                                    style: const TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: MitumbaTypography.fontSizeXs,
                                      color: MitumbaColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: MitumbaSpacing.sm),
                            Text(
                              '${isPositive ? '+' : ''}${event.pointsChange}',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: MitumbaTypography.fontSizeSm,
                                fontWeight: FontWeight.w700,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FactorData {
  const _FactorData({
    required this.label,
    this.value,
    required this.display,
  });

  final String label;
  final double? value;
  final String display;
}
