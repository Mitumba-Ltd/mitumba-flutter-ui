import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Order status values.
enum OrderStatus {
  created,
  paymentPending,
  paid,
  sellerConfirmed,
  shipped,
  delivered,
  completed,
  cancelled,
  disputed,
}

const _statusLabels = {
  OrderStatus.created: 'Order Placed',
  OrderStatus.paymentPending: 'Awaiting Payment',
  OrderStatus.paid: 'Payment Confirmed',
  OrderStatus.sellerConfirmed: 'Seller Confirmed',
  OrderStatus.shipped: 'Shipped',
  OrderStatus.delivered: 'Delivered',
  OrderStatus.completed: 'Completed',
  OrderStatus.cancelled: 'Cancelled',
  OrderStatus.disputed: 'Disputed',
};

const _statusIcons = {
  OrderStatus.created: Icons.inventory_2_outlined,
  OrderStatus.paymentPending: Icons.schedule_outlined,
  OrderStatus.paid: Icons.payment_outlined,
  OrderStatus.sellerConfirmed: Icons.handshake_outlined,
  OrderStatus.shipped: Icons.local_shipping_outlined,
  OrderStatus.delivered: Icons.check_circle_outline,
  OrderStatus.completed: Icons.check_circle,
  OrderStatus.cancelled: Icons.cancel_outlined,
  OrderStatus.disputed: Icons.gavel_outlined,
};

Color _statusColor(OrderStatus status) {
  switch (status) {
    case OrderStatus.created:
    case OrderStatus.shipped:
      return MitumbaColors.info;
    case OrderStatus.paymentPending:
      return MitumbaColors.warning;
    case OrderStatus.paid:
    case OrderStatus.sellerConfirmed:
    case OrderStatus.delivered:
    case OrderStatus.completed:
      return MitumbaColors.green;
    case OrderStatus.cancelled:
      return MitumbaColors.error;
    case OrderStatus.disputed:
      return MitumbaColors.warning;
  }
}

/// A single event in the order timeline.
class OrderEvent {
  const OrderEvent({
    required this.status,
    required this.timestamp,
    this.note,
  });

  /// Which status this event corresponds to.
  final OrderStatus status;

  /// Human-readable timestamp.
  final String timestamp;

  /// Optional note (tracking number, cancellation reason, etc.).
  final String? note;
}

/// The happy path order of statuses.
const _happyPath = [
  OrderStatus.created,
  OrderStatus.paymentPending,
  OrderStatus.paid,
  OrderStatus.sellerConfirmed,
  OrderStatus.shipped,
  OrderStatus.delivered,
  OrderStatus.completed,
];

/// Order status timeline — vertical progression of order steps.
///
/// Mirrors the web `OrderStatusTimeline` from `@mitumba/ui`.
///
/// ```dart
/// OrderStatusTimeline(
///   currentStatus: OrderStatus.shipped,
///   events: [
///     OrderEvent(status: OrderStatus.created, timestamp: 'Jan 4, 9:15 AM'),
///     OrderEvent(status: OrderStatus.paid, timestamp: 'Jan 4, 9:20 AM'),
///   ],
/// )
/// ```
class OrderStatusTimeline extends StatelessWidget {
  /// Creates an order status timeline.
  const OrderStatusTimeline({
    super.key,
    required this.currentStatus,
    required this.events,
    this.compact = false,
    this.title = 'Order Tracking',
  });

  /// The current order status.
  final OrderStatus currentStatus;

  /// Array of order event entries.
  final List<OrderEvent> events;

  /// Compact mode — hides timestamps and notes, shrinks node size.
  final bool compact;

  /// Optional title override.
  final String title;

  @override
  Widget build(BuildContext context) {
    final isTerminal = currentStatus == OrderStatus.cancelled || currentStatus == OrderStatus.disputed;
    final steps = isTerminal ? [..._happyPath.take(_activeHappyIndex()), currentStatus] : _happyPath;
    final activeIndex = steps.indexOf(currentStatus);

    return Semantics(
      label: 'Order status: ${_statusLabels[currentStatus]}',
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
            if (!compact) _buildHeader(),
            ...List.generate(steps.length, (i) => _buildStep(
              status: steps[i],
              index: i,
              activeIndex: activeIndex,
              isLast: i == steps.length - 1,
            )),
          ],
        ),
      ),
    );
  }

  int _activeHappyIndex() {
    for (var i = events.length - 1; i >= 0; i--) {
      final idx = _happyPath.indexOf(events[i].status);
      if (idx >= 0) return idx + 1;
    }
    return 1;
  }

  Widget _buildHeader() {
    final color = _statusColor(currentStatus);

    return Padding(
      padding: EdgeInsets.only(bottom: MitumbaSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: MitumbaTypography.body1.copyWith(fontWeight: FontWeight.w700)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: MitumbaSpacing.sm, vertical: 3),
            decoration: BoxDecoration(
              color: color.withAlpha(18),
              borderRadius: BorderRadius.circular(MitumbaRadius.full),
              border: Border.all(color: color.withAlpha(50)),
            ),
            child: Text(
              _statusLabels[currentStatus]!,
              style: TextStyle(
                fontFamily: MitumbaTypography.fontFamily,
                fontSize: MitumbaTypography.fontSizeXs,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required OrderStatus status,
    required int index,
    required int activeIndex,
    required bool isLast,
  }) {
    final isCompleted = index < activeIndex;
    final isCurrent = index == activeIndex;
    final isPending = index > activeIndex;
    final color = _statusColor(status);
    final nodeSize = compact ? 28.0 : 36.0;

    final nodeColor = isCompleted
        ? MitumbaColors.green
        : isCurrent
            ? color
            : MitumbaColors.divider;

    final connectorColor = isCompleted ? MitumbaColors.green : MitumbaColors.divider;

    // Find matching event
    final matchingEvents = events.where((e) => e.status == status);
    final latestEvent = matchingEvents.isNotEmpty ? matchingEvents.last : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Node + connector column
        Column(
          children: [
            // Node
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: nodeSize,
              height: nodeSize,
              decoration: BoxDecoration(
                color: (isCompleted || isCurrent) ? nodeColor : MitumbaColors.background,
                shape: BoxShape.circle,
                border: isPending ? Border.all(color: MitumbaColors.divider, width: 2) : null,
                boxShadow: isCurrent
                    ? [BoxShadow(color: nodeColor.withAlpha(40), blurRadius: 0, spreadRadius: 4)]
                    : null,
              ),
              child: Center(
                child: isCompleted
                    ? Icon(Icons.check, size: compact ? 14 : 18, color: MitumbaColors.white)
                    : isCurrent
                        ? Icon(_statusIcons[status], size: compact ? 14 : 18, color: MitumbaColors.white)
                        : Icon(Icons.radio_button_unchecked, size: compact ? 12 : 14, color: MitumbaColors.textDisabled),
              ),
            ),
            // Connector
            if (!isLast)
              Container(
                width: 2,
                height: compact ? 16 : 24,
                margin: EdgeInsets.symmetric(vertical: MitumbaSpacing.xxs),
                color: connectorColor,
              ),
          ],
        ),
        SizedBox(width: MitumbaSpacing.base),
        // Label + timestamp
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: (nodeSize - 16) / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _statusLabels[status]!,
                  style: MitumbaTypography.body2.copyWith(
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                    color: isPending ? MitumbaColors.textDisabled : MitumbaColors.textPrimary,
                  ),
                ),
                if (!compact && latestEvent != null) ...[
                  SizedBox(height: MitumbaSpacing.xxs),
                  Text(
                    latestEvent.timestamp,
                    style: MitumbaTypography.caption.copyWith(color: MitumbaColors.textSecondary),
                  ),
                ],
                if (!compact && latestEvent?.note != null) ...[
                  SizedBox(height: MitumbaSpacing.xxs),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: MitumbaSpacing.sm, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withAlpha(12),
                      borderLeft: BorderSide(color: color, width: 2),
                    ),
                    child: Text(
                      latestEvent!.note!,
                      style: MitumbaTypography.caption.copyWith(
                        color: MitumbaColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
                if (!isLast) SizedBox(height: compact ? MitumbaSpacing.sm : MitumbaSpacing.lg),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
