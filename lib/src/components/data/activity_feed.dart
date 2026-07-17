import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/shadows.dart';
import '../../tokens/typography.dart';
import '../feedback/empty_state.dart';
import '../feedback/mitumba_skeleton.dart';
import '../foundation/mitumba_glass.dart';

/// The visual variants of [ActivityFeed].
enum ActivityFeedVariant { standard, glass, elevated }

/// Supported types of activities in the feed.
enum ActivityType {
  order,
  // ignore: constant_identifier_names
  sti_change,
  payout,
  review,
  system
}

/// An individual event in the [ActivityFeed].
class ActivityEvent {
  const ActivityEvent({
    required this.id,
    required this.type,
    required this.title,
    required this.timestamp,
    this.subtitle,
    this.icon,
    this.color,
  });

  /// Unique event ID.
  final String id;

  /// Event type. Maps to default colors and icons.
  final ActivityType type;

  /// Title of the event.
  final String title;

  /// Human-readable timestamp (e.g. "10 min ago").
  final String timestamp;

  /// Optional detailed description.
  final String? subtitle;

  /// Custom icon widget.
  final Widget? icon;

  /// Custom highlight color.
  final Color? color;
}

/// A premium, living ActivityFeed component for timeline event streams.
class ActivityFeed extends StatelessWidget {
  const ActivityFeed({
    super.key,
    required this.events,
    this.loading = false,
    this.emptyMessage = 'No recent activity',
    this.variant = ActivityFeedVariant.standard,
    this.showTimeline = true,
  });

  /// Events to display in the feed.
  final List<ActivityEvent> events;

  /// Whether the feed is still loading. Shows skeleton list items when true.
  final bool loading;

  /// Title message shown in the empty state.
  final String emptyMessage;

  /// Visual theme/layout variant.
  final ActivityFeedVariant variant;

  /// Whether to render the vertical connecting line between events.
  final bool showTimeline;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return _buildSkeleton();
    }

    if (events.isEmpty) {
      return EmptyState(
        variant: EmptyStateVariant.compact,
        title: emptyMessage,
        subtitle: 'New marketplace updates will appear here in real-time.',
      );
    }

    return Stack(
      children: [
        // Timeline Vertical Axis Line
        if (showTimeline && events.length > 1)
          Positioned(
            left: 36, // Centered relative to the 40px icon
            top: 24,
            bottom: 24,
            child: Container(
              width: 2,
              color: MitumbaColors.divider.withValues(alpha: 0.6),
            ),
          ),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: events.length,
          separatorBuilder: (_, __) => SizedBox(
            height: variant == ActivityFeedVariant.elevated ? 16 : 8,
          ),
          itemBuilder: (context, index) {
            return _ActivityFeedItem(
              event: events[index],
              variant: variant,
            );
          },
        ),
      ],
    );
  }

  Widget _buildSkeleton() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, __) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MitumbaSkeleton(
            width: 40,
            height: 40,
            variant: MitumbaSkeletonVariant.circular,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 6),
                MitumbaSkeleton(
                  width: 140,
                  height: 16,
                  variant: MitumbaSkeletonVariant.rectangular,
                ),
                SizedBox(height: 8),
                MitumbaSkeleton(
                  width: 80,
                  height: 10,
                  variant: MitumbaSkeletonVariant.rectangular,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityFeedItem extends StatefulWidget {
  const _ActivityFeedItem({
    required this.event,
    required this.variant,
  });

  final ActivityEvent event;
  final ActivityFeedVariant variant;

  @override
  State<_ActivityFeedItem> createState() => _ActivityFeedItemState();
}

class _ActivityFeedItemState extends State<_ActivityFeedItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isGlass = widget.variant == ActivityFeedVariant.glass;
    final isElevated = widget.variant == ActivityFeedVariant.elevated;

    final config = _getTypeConfig(widget.event.type);
    final themeColor = widget.event.color ?? config.color;

    final itemContent = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon node container
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: MitumbaColors.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: _isHovered ? themeColor : MitumbaColors.border,
            ),
            boxShadow: _isHovered ? MitumbaShadows.card : null,
          ),
          transform: Matrix4.identity()
            ..rotateZ(_isHovered ? 0.17 : 0.0)
            ..scale(_isHovered ? 1.1 : 1.0),
          transformAlignment: Alignment.center,
          alignment: Alignment.center,
          child: IconTheme(
            data: IconThemeData(color: themeColor, size: 18),
            child: widget.event.icon ?? config.icon,
          ),
        ),
        const SizedBox(width: 16),

        // Text & details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.event.title,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: MitumbaTypography.fontSizeBase,
                        fontWeight: FontWeight.w800,
                        color: MitumbaColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.event.timestamp.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: MitumbaColors.textDisabled,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              if (widget.event.subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  widget.event.subtitle!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: MitumbaTypography.fontSizeSm,
                    color: MitumbaColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );

    final decorationBox = BoxDecoration(
      color: isElevated ? MitumbaColors.surface : Colors.transparent,
      borderRadius: BorderRadius.circular(MitumbaRadius.lg),
      border: isElevated
          ? Border.all(color: _isHovered ? MitumbaColors.green : MitumbaColors.border)
          : null,
      boxShadow: isElevated && _isHovered ? MitumbaShadows.card : null,
    );

    Widget innerWidget;
    if (isGlass) {
      innerWidget = MitumbaGlass(
        rounding: MitumbaGlassRounding.large,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: itemContent,
        ),
      );
    } else {
      innerWidget = Container(
        decoration: decorationBox,
        padding: const EdgeInsets.all(16.0),
        child: itemContent,
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..translate(_isHovered ? 4.0 : 0.0, 0.0), // Slides left-to-right slightly on hover
        child: innerWidget,
      ),
    );
  }

  _TypeConfig _getTypeConfig(ActivityType type) {
    switch (type) {
      case ActivityType.order:
        return const _TypeConfig(icon: Icon(Icons.shopping_cart), color: MitumbaColors.green);
      case ActivityType.sti_change:
        return const _TypeConfig(icon: Icon(Icons.star), color: MitumbaColors.greenLight); // fallback light green or blue
      case ActivityType.payout:
        return const _TypeConfig(icon: Icon(Icons.payments), color: MitumbaColors.earth);
      case ActivityType.review:
        return const _TypeConfig(icon: Icon(Icons.rate_review), color: Colors.orange);
      case ActivityType.system:
        return const _TypeConfig(icon: Icon(Icons.settings), color: MitumbaColors.textSecondary);
    }
  }
}

class _TypeConfig {
  const _TypeConfig({required this.icon, required this.color});
  final Widget icon;
  final Color color;
}
