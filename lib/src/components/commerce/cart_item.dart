import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/shadows.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../foundation/mitumba_select.dart';

/// Cart Item component showing a single product in checkout/cart.
class CartItem extends StatefulWidget {
  const CartItem({
    super.key,
    required this.imageUrl,
    required this.title,
    this.subtitle,
    this.status = 'IN STOCK',
    required this.priceKes,
    required this.size,
    required this.availableSizes,
    required this.quantity,
    this.maxQuantity = 10,
    required this.onRemove,
    required this.onQuantityChange,
    required this.onSizeChange,
  });

  final String imageUrl;
  final String title;
  final String? subtitle;
  final String status;
  final double priceKes;
  final String size;
  final List<String> availableSizes;
  final int quantity;
  final int maxQuantity;
  final VoidCallback onRemove;
  final ValueChanged<int> onQuantityChange;
  final ValueChanged<String> onSizeChange;

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  bool _isHovered = false;
  bool _isCloseHovered = false;

  @override
  Widget build(BuildContext context) {
    final formattedPrice = widget.priceKes.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered ? -2.0 : 0.0),
        decoration: BoxDecoration(
          color: MitumbaColors.surface,
          borderRadius: BorderRadius.circular(MitumbaRadius.lg),
          border: Border.all(color: MitumbaColors.divider),
          boxShadow: _isHovered
              ? MitumbaShadows.elevated
              : MitumbaShadows.card,
        ),
        padding: const EdgeInsets.all(MitumbaSpacing.lg),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: MitumbaColors.background,
                    borderRadius: BorderRadius.circular(MitumbaRadius.md),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(MitumbaRadius.md),
                    child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        color: MitumbaColors.textDisabled,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: MitumbaSpacing.base),

                // Content Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Padding(
                        padding: const EdgeInsets.only(right: 28.0),
                        child: Text(
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
                      ),

                      // Subtitle
                      if (widget.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          widget.subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: MitumbaTypography.fontSizeXs,
                            color: MitumbaColors.textSecondary,
                          ),
                        ),
                      ],

                      // Status
                      const SizedBox(height: 4),
                      Text(
                        widget.status,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: MitumbaColors.green,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: MitumbaSpacing.base),

                      // Selectors + Price Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Size Selector
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'SIZE',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: MitumbaColors.textDisabled,
                                ),
                              ),
                              const SizedBox(height: 2),
                              SizedBox(
                                width: 72,
                                child: MitumbaSelect(
                                  value: widget.size,
                                  options: widget.availableSizes.map((s) {
                                    return MitumbaSelectOption(value: s, label: s);
                                  }).toList(),
                                  onChange: (val) => widget.onSizeChange(val as String),
                                  size: MitumbaSelectSize.small,
                                  rounding: MitumbaSelectRounding.rounded,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: MitumbaSpacing.md),

                          // Qty Selector
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'QTY',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: MitumbaColors.textDisabled,
                                ),
                              ),
                              const SizedBox(height: 2),
                              SizedBox(
                                width: 72,
                                child: MitumbaSelect(
                                  value: widget.quantity,
                                  options: List.generate(widget.maxQuantity, (i) {
                                    final val = i + 1;
                                    return MitumbaSelectOption(value: val, label: '$val');
                                  }),
                                  onChange: (val) => widget.onQuantityChange(val as int),
                                  size: MitumbaSelectSize.small,
                                  rounding: MitumbaSelectRounding.rounded,
                                ),
                              ),
                            ],
                          ),

                          // Price - right aligned
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                'KES $formattedPrice',
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: MitumbaTypography.fontSizeMd,
                                  fontWeight: FontWeight.w900,
                                  color: MitumbaColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Remove Button (Close Icon) - Top Right
            Positioned(
              top: 0,
              right: 0,
              child: MouseRegion(
                onEnter: (_) => setState(() => _isCloseHovered = true),
                onExit: (_) => setState(() => _isCloseHovered = false),
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: widget.onRemove,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _isCloseHovered
                          ? MitumbaColors.error.withValues(alpha: 0.1)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    transform: Matrix4.identity()
                      ..rotateZ(_isCloseHovered ? 0.2 : 0.0),
                    transformAlignment: Alignment.center,
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: _isCloseHovered
                          ? MitumbaColors.error
                          : MitumbaColors.textDisabled,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
