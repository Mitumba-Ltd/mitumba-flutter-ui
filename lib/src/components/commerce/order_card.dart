import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/shadows.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../foundation/mitumba_chip.dart';
import '../foundation/mitumba_primary_button.dart';

enum OrderCardStatus {
  pending,
  paid,
  confirmed,
  shipped,
  delivered,
  completed,
  cancelled,
  disputed,
}

class _StatusConfig {
  const _StatusConfig({
    required this.label,
    required this.chipStatus,
  });

  final String label;
  final MitumbaChipStatus chipStatus;
}

const Map<OrderCardStatus, _StatusConfig> _statusConfigs = {
  OrderCardStatus.pending: _StatusConfig(label: 'Pending', chipStatus: MitumbaChipStatus.incomplete),
  OrderCardStatus.paid: _StatusConfig(label: 'Paid', chipStatus: MitumbaChipStatus.active),
  OrderCardStatus.confirmed: _StatusConfig(label: 'Confirmed', chipStatus: MitumbaChipStatus.active),
  OrderCardStatus.shipped: _StatusConfig(label: 'Shipped', chipStatus: MitumbaChipStatus.active),
  OrderCardStatus.delivered: _StatusConfig(label: 'Delivered', chipStatus: MitumbaChipStatus.success),
  OrderCardStatus.completed: _StatusConfig(label: 'Completed', chipStatus: MitumbaChipStatus.success),
  OrderCardStatus.cancelled: _StatusConfig(label: 'Cancelled', chipStatus: MitumbaChipStatus.danger),
  OrderCardStatus.disputed: _StatusConfig(label: 'Disputed', chipStatus: MitumbaChipStatus.danger),
};

/// OrderCard — compact order summary card for order history lists.
class OrderCard extends StatefulWidget {
  const OrderCard({
    super.key,
    required this.orderShortId,
    required this.title,
    this.imageUrl,
    required this.totalKes,
    this.deliveryFeeKes,
    required this.status,
    required this.createdAt,
    this.onClick,
  });

  final String orderShortId;
  final String title;
  final String? imageUrl;
  final double totalKes;
  final double? deliveryFeeKes;
  final OrderCardStatus status;
  final String createdAt;
  final VoidCallback? onClick;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final statusConfig = _statusConfigs[widget.status] ??
        const _StatusConfig(label: 'Pending', chipStatus: MitumbaChipStatus.incomplete);

    final formattedTotal = widget.totalKes.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onClick,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()
            ..translate(0.0, (_isHovered && widget.onClick != null) ? -2.0 : 0.0),
          decoration: BoxDecoration(
            color: MitumbaColors.surface,
            borderRadius: BorderRadius.circular(MitumbaRadius.lg),
            border: Border.all(color: MitumbaColors.divider),
            boxShadow: (_isHovered && widget.onClick != null)
                ? MitumbaShadows.elevated
                : MitumbaShadows.card,
          ),
          padding: const EdgeInsets.all(MitumbaSpacing.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              if (widget.imageUrl != null) ...[
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: MitumbaColors.background,
                    borderRadius: BorderRadius.circular(MitumbaRadius.md),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(MitumbaRadius.md),
                    child: Image.network(
                      widget.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        color: MitumbaColors.textDisabled,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: MitumbaSpacing.base),
              ],

              // Content Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: ID + Status chip
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ORDER #${widget.orderShortId.toUpperCase()}',
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: MitumbaTypography.fontSizeXs,
                            fontWeight: FontWeight.w700,
                            color: MitumbaColors.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        MitumbaChip(
                          label: statusConfig.label,
                          status: statusConfig.chipStatus,
                          size: 'small',
                          variant: MitumbaChipVariant.solid,
                          rounding: MitumbaChipRounding.pill,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Title
                    Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: MitumbaTypography.fontSizeBase,
                        fontWeight: FontWeight.w700,
                        color: MitumbaColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),

                    // Created Date
                    Text(
                      widget.createdAt,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: MitumbaTypography.fontSizeXs,
                        color: MitumbaColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: MitumbaSpacing.base),

                    // Cost & Action row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Price
                        Text(
                          'KES $formattedTotal',
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: MitumbaTypography.fontSizeMd,
                            fontWeight: FontWeight.w900,
                            color: MitumbaColors.textPrimary,
                          ),
                        ),

                        // Shipping fee info
                        if (widget.deliveryFeeKes != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            '+KES ${widget.deliveryFeeKes!.toStringAsFixed(0)} delivery',
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: MitumbaTypography.fontSizeXs,
                              color: MitumbaColors.textSecondary,
                            ),
                          ),
                        ],

                        // Track button if actionable
                        if (widget.onClick != null) ...[
                          const Spacer(),
                          SizedBox(
                            height: 28,
                            child: MitumbaPrimaryButton(
                              label: 'Track Package',
                              onPressed: () {},
                              size: ButtonSize.small,
                              icon: Icons.local_shipping,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
