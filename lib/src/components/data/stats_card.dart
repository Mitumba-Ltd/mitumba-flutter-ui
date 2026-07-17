import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/shadows.dart';
import '../../tokens/typography.dart';
import '../foundation/mitumba_glass.dart';

/// The visual variants of [StatsCard].
enum StatsCardVariant { standard, glass, elevated, compact }

/// Unit placement position relative to the main value.
enum StatsCardUnitPosition { prefix, suffix }

/// Trend information for [StatsCard].
class StatsCardTrend {
  const StatsCardTrend({
    required this.direction,
    required this.percent,
    this.label,
  });

  /// The trend direction: 'up', 'down', or 'neutral'.
  final String direction;

  /// The percentage value of the trend.
  final double percent;

  /// Optional context label (e.g. "vs last month").
  final String? label;
}

/// A premium, living StatsCard component for data visualization.
class StatsCard extends StatefulWidget {
  const StatsCard({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.unitPosition = StatsCardUnitPosition.suffix,
    this.trend,
    this.icon,
    this.variant = StatsCardVariant.standard,
    this.color = MitumbaColors.green,
    this.onTap,
  });

  /// Description/title of the metric.
  final String label;

  /// The main metric value (formatted string or number).
  final String value;

  /// Metric unit (e.g. "%", "KES", "looks").
  final String? unit;

  /// Position of the unit relative to [value].
  final StatsCardUnitPosition unitPosition;

  /// Optional trend details (percentage direction & comparison text).
  final StatsCardTrend? trend;

  /// Icon to display at the top right corner.
  final Widget? icon;

  /// Visual theme/layout variant.
  final StatsCardVariant variant;

  /// Brand highlight color (e.g. green, earth).
  final Color color;

  /// Optional callback when user taps on the card.
  final VoidCallback? onTap;

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isGlass = widget.variant == StatsCardVariant.glass;
    final isElevated = widget.variant == StatsCardVariant.elevated;
    final isCompact = widget.variant == StatsCardVariant.compact;

    // Compact layout rendering
    if (isCompact) {
      return MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: MitumbaColors.surface,
              borderRadius: BorderRadius.circular(MitumbaRadius.lg),
              border: Border.all(
                color: _isHovered ? widget.color : MitumbaColors.border,
              ),
              boxShadow: _isHovered ? MitumbaShadows.elevated : MitumbaShadows.card,
            ),
            transform: Matrix4.identity()
              ..translate(0.0, _isHovered ? -4.0 : 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    if (widget.unit != null && widget.unitPosition == StatsCardUnitPosition.prefix) ...[
                      Text(
                        widget.unit!,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: MitumbaTypography.fontSizeBase,
                          fontWeight: FontWeight.w900,
                          color: MitumbaColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 2),
                    ],
                    Text(
                      widget.value,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: MitumbaTypography.fontSizeXl,
                        fontWeight: FontWeight.w900,
                        color: MitumbaColors.textPrimary,
                        height: 1.0,
                      ),
                    ),
                    if (widget.unit != null && widget.unitPosition == StatsCardUnitPosition.suffix) ...[
                      const SizedBox(width: 2),
                      Text(
                        widget.unit!,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: MitumbaTypography.fontSizeSm,
                          fontWeight: FontWeight.w800,
                          color: MitumbaColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  widget.label.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: MitumbaColors.textSecondary,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final cardContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                widget.label.toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: MitumbaColors.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            if (widget.icon != null) ...[
              const SizedBox(width: 12),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(MitumbaRadius.md),
                ),
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateZ(_isHovered ? 0.17 : 0.0)
                  ..scale(_isHovered ? 1.1 : 1.0),
                transformAlignment: Alignment.center,
                child: IconTheme(
                  data: IconThemeData(color: widget.color, size: 16),
                  child: widget.icon!,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            if (widget.unit != null && widget.unitPosition == StatsCardUnitPosition.prefix) ...[
              Text(
                widget.unit!,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: MitumbaTypography.fontSizeSm,
                  fontWeight: FontWeight.w900,
                  color: MitumbaColors.textSecondary,
                ),
              ),
              const SizedBox(width: 2),
            ],
            Text(
              widget.value,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: MitumbaTypography.fontSizeXxl,
                fontWeight: FontWeight.w900,
                color: MitumbaColors.textPrimary,
                height: 1.0,
                letterSpacing: -0.5,
              ),
            ),
            if (widget.unit != null && widget.unitPosition == StatsCardUnitPosition.suffix) ...[
              const SizedBox(width: 2),
              Text(
                widget.unit!,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: MitumbaTypography.fontSizeSm,
                  fontWeight: FontWeight.w800,
                  color: MitumbaColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
        if (widget.trend != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getTrendColor(widget.trend!.direction).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(MitumbaRadius.full),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getTrendIcon(widget.trend!.direction),
                      size: 12,
                      color: _getTrendColor(widget.trend!.direction),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${widget.trend!.percent.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: _getTrendColor(widget.trend!.direction),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.trend!.label ?? 'vs last month',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: MitumbaColors.textDisabled,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );

    final decorationBox = BoxDecoration(
      color: MitumbaColors.surface,
      borderRadius: BorderRadius.circular(MitumbaRadius.lg),
      border: isElevated
          ? null
          : Border.all(
              color: _isHovered ? widget.color : MitumbaColors.border,
            ),
      boxShadow: isElevated
          ? (_isHovered ? MitumbaShadows.elevated : MitumbaShadows.card)
          : (_isHovered ? MitumbaShadows.card : null),
    );

    Widget cardWidget;
    if (isGlass) {
      cardWidget = MitumbaGlass(
        rounding: MitumbaGlassRounding.large,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: cardContent,
        ),
      );
    } else {
      cardWidget = Container(
        decoration: decorationBox,
        padding: const EdgeInsets.all(24.0),
        child: cardContent,
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered ? -4.0 : 0.0),
          child: cardWidget,
        ),
      ),
    );
  }

  Color _getTrendColor(String direction) {
    if (direction == 'up') return MitumbaColors.green;
    if (direction == 'down') return Colors.red;
    return MitumbaColors.textDisabled;
  }

  IconData _getTrendIcon(String direction) {
    if (direction == 'up') return Icons.trending_up;
    if (direction == 'down') return Icons.trending_flat; // fallback
    return Icons.trending_flat;
  }
}
