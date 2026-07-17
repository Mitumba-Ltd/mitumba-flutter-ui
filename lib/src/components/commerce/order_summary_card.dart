import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/shadows.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../foundation/mitumba_primary_button.dart';

class OrderSummaryItem {
  const OrderSummaryItem({
    required this.label,
    required this.amountKes,
    this.isDiscount = false,
  });

  final String label;
  final double amountKes;
  final bool isDiscount;
}

/// OrderSummaryCard displays order cost details, discount line items, and Checkout CTA.
class OrderSummaryCard extends StatefulWidget {
  const OrderSummaryCard({
    super.key,
    required this.items,
    required this.totalKes,
    this.actionLabel = 'Checkout',
    this.onAction,
    this.loading = false,
    this.disabled = false,
    this.trustLine,
  });

  final List<OrderSummaryItem> items;
  final double totalKes;
  final String actionLabel;
  final VoidCallback? onAction;
  final bool loading;
  final bool disabled;
  final String? trustLine;

  @override
  State<OrderSummaryCard> createState() => _OrderSummaryCardState();
}

class _OrderSummaryCardState extends State<OrderSummaryCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final formattedTotal = widget.totalKes.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: MitumbaColors.surface,
          borderRadius: BorderRadius.circular(MitumbaRadius.lg),
          border: Border.all(color: MitumbaColors.divider),
          boxShadow: _isHovered
              ? MitumbaShadows.elevated
              : MitumbaShadows.card,
        ),
        padding: const EdgeInsets.all(MitumbaSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            const Text(
              'Order Summary',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: MitumbaTypography.fontSizeLg,
                fontWeight: FontWeight.w700,
                color: MitumbaColors.textPrimary,
              ),
            ),
            const SizedBox(height: MitumbaSpacing.xl),

            // Line items
            Column(
              children: widget.items.map((item) {
                final formattedAmount = item.amountKes.toStringAsFixed(0).replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (Match m) => '${m[1]},',
                );

                return Padding(
                  padding: const EdgeInsets.only(bottom: MitumbaSpacing.base),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.label,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: MitumbaTypography.fontSizeSm,
                          color: MitumbaColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${item.isDiscount ? '−' : ''}KES $formattedAmount',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: MitumbaTypography.fontSizeSm,
                          fontWeight: FontWeight.w700,
                          color: item.isDiscount
                              ? MitumbaColors.green
                              : MitumbaColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: MitumbaSpacing.base),
            const Divider(color: MitumbaColors.divider, height: 1),
            const SizedBox(height: MitumbaSpacing.xl),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: MitumbaTypography.fontSizeLg,
                    fontWeight: FontWeight.w800,
                    color: MitumbaColors.textPrimary,
                  ),
                ),
                Text(
                  'KES $formattedTotal',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: MitumbaTypography.fontSizeXl,
                    fontWeight: FontWeight.w800,
                    color: MitumbaColors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: MitumbaSpacing.xxl),

            // Action button
            if (widget.onAction != null)
              MitumbaPrimaryButton(
                label: widget.loading ? 'Processing...' : widget.actionLabel,
                onPressed: widget.onAction!,
                disabled: widget.disabled || widget.loading,
                size: ButtonSize.large,
              ),

            // Trust line
            if (widget.trustLine != null) ...[
              const SizedBox(height: MitumbaSpacing.base),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shield_outlined,
                    size: 14,
                    color: MitumbaColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.trustLine!,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: MitumbaTypography.fontSizeXs,
                      color: MitumbaColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
