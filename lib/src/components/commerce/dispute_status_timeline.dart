import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Dispute status values.
enum DisputeStatus {
  open,
  sellerResponded,
  underReview,
  resolvedRefund,
  resolvedRelease,
  resolvedPartial,
  withdrawn,
}

const _statusLabels = {
  DisputeStatus.open: 'Open',
  DisputeStatus.sellerResponded: 'Seller Responded',
  DisputeStatus.underReview: 'Under Review',
  DisputeStatus.resolvedRefund: 'Resolved — Refund',
  DisputeStatus.resolvedRelease: 'Resolved — Released',
  DisputeStatus.resolvedPartial: 'Resolved — Partial',
  DisputeStatus.withdrawn: 'Withdrawn',
};

Color _statusColor(DisputeStatus status) {
  switch (status) {
    case DisputeStatus.open:
      return MitumbaColors.warning;
    case DisputeStatus.sellerResponded:
    case DisputeStatus.underReview:
    case DisputeStatus.resolvedPartial:
      return MitumbaColors.info;
    case DisputeStatus.resolvedRefund:
      return MitumbaColors.green;
    case DisputeStatus.resolvedRelease:
    case DisputeStatus.withdrawn:
      return MitumbaColors.textSecondary;
  }
}

/// Actor role for a dispute event.
enum DisputeActorRole { buyer, seller, admin, system }

Color _actorColor(DisputeActorRole role) {
  switch (role) {
    case DisputeActorRole.buyer:
      return MitumbaColors.green;
    case DisputeActorRole.seller:
      return MitumbaColors.earth;
    case DisputeActorRole.admin:
      return MitumbaColors.info;
    case DisputeActorRole.system:
      return MitumbaColors.textDisabled;
  }
}

/// A single event in the dispute timeline.
class DisputeEvent {
  const DisputeEvent({
    required this.actorRole,
    required this.action,
    required this.createdAt,
    this.note,
  });

  /// Role of the actor who performed this action.
  final DisputeActorRole actorRole;

  /// Description of the action taken.
  final String action;

  /// ISO timestamp of the event.
  final String createdAt;

  /// Optional note or comment.
  final String? note;
}

/// Dispute status timeline — event-driven with actor badges and color-coded nodes.
///
/// Mirrors the web `DisputeStatusTimeline` from `@mitumba/ui`.
///
/// ```dart
/// DisputeStatusTimeline(
///   status: DisputeStatus.open,
///   events: [
///     DisputeEvent(actorRole: DisputeActorRole.buyer, action: 'Raised dispute', createdAt: 'Jan 5'),
///   ],
/// )
/// ```
class DisputeStatusTimeline extends StatelessWidget {
  /// Creates a dispute status timeline.
  const DisputeStatusTimeline({
    super.key,
    required this.status,
    required this.events,
  });

  /// Current dispute status.
  final DisputeStatus status;

  /// Array of dispute events.
  final List<DisputeEvent> events;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(status);

    return Semantics(
      label: 'Dispute status: ${_statusLabels[status]}',
      child: Container(
        padding: EdgeInsets.all(MitumbaSpacing.lg),
        decoration: BoxDecoration(
          color: MitumbaColors.surface,
          borderRadius: BorderRadius.circular(MitumbaRadius.xl),
          border: Border.all(color: MitumbaColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status chip
            _StatusChip(label: _statusLabels[status]!, color: statusColor),
            SizedBox(height: MitumbaSpacing.lg),
            // Event list
            ...List.generate(events.length, (i) => _EventNode(
              event: events[i],
              isLast: i == events.length - 1,
            )),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: MitumbaSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(18),
        borderRadius: BorderRadius.circular(MitumbaRadius.full),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontFamily: MitumbaTypography.fontFamily,
          fontSize: MitumbaTypography.fontSizeXs,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _EventNode extends StatelessWidget {
  const _EventNode({required this.event, required this.isLast});
  final DisputeEvent event;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final actorColor = _actorColor(event.actorRole);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Node + connector
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: actorColor,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 24,
                margin: EdgeInsets.symmetric(vertical: MitumbaSpacing.xxs),
                color: MitumbaColors.divider,
              ),
          ],
        ),
        SizedBox(width: MitumbaSpacing.base),
        // Content
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : MitumbaSpacing.base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Actor badge + action
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: MitumbaSpacing.xs,
                  children: [
                    _ActorBadge(role: event.actorRole, color: actorColor),
                    Text(
                      event.action,
                      style: MitumbaTypography.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: MitumbaColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                // Note
                if (event.note != null) ...[
                  SizedBox(height: MitumbaSpacing.xxs),
                  Text(
                    event.note!,
                    style: MitumbaTypography.caption.copyWith(
                      fontStyle: FontStyle.italic,
                      color: MitumbaColors.textSecondary,
                    ),
                  ),
                ],
                // Timestamp
                SizedBox(height: MitumbaSpacing.xxs),
                Text(
                  event.createdAt,
                  style: MitumbaTypography.caption.copyWith(
                    color: MitumbaColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ActorBadge extends StatelessWidget {
  const _ActorBadge({required this.role, required this.color});
  final DisputeActorRole role;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: MitumbaSpacing.xs, vertical: 1),
      decoration: BoxDecoration(
        color: color.withAlpha(18),
        borderRadius: BorderRadius.circular(MitumbaRadius.sm),
      ),
      child: Text(
        role.name,
        style: TextStyle(
          fontFamily: MitumbaTypography.fontFamily,
          fontSize: MitumbaTypography.fontSizeXs,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
