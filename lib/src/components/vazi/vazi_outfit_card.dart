import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/shadows.dart';
import '../../tokens/typography.dart';
import '../foundation/mitumba_glass.dart';
import '../foundation/mitumba_primary_button.dart';
import 'vazi_badge.dart';

/// Models a garment item in a VAZI outfit.
class VAZIOutfitItem {
  const VAZIOutfitItem({
    required this.listingId,
    required this.imageUrl,
    required this.garmentType,
    required this.priceKes,
    required this.sellerName,
  });

  final String listingId;
  final String imageUrl;
  final String garmentType;
  final int priceKes;
  final String sellerName;
}

/// An extraordinary, high-depth Pinterest-style Collage Outfit Card.
class VAZIOutfitCard extends StatefulWidget {
  const VAZIOutfitCard({
    super.key,
    required this.outfitName,
    required this.items,
    required this.totalPriceKes,
    required this.sellersCount,
    this.isMultiCity = false,
    this.onTap,
    this.onBuyAll,
  });

  /// Name of the outfit (e.g. "Weekend Chill").
  final String outfitName;

  /// Items that make up the outfit (2–4 items).
  final List<VAZIOutfitItem> items;

  /// Total price of all items in Kenyan Shillings.
  final int totalPriceKes;

  /// Number of unique sellers involved.
  final int sellersCount;

  /// Whether items ship from multiple cities.
  final bool isMultiCity;

  /// Triggered when the card body is tapped.
  final VoidCallback? onTap;

  /// Triggered when "Buy entire look" is clicked.
  final VoidCallback? onBuyAll;

  @override
  State<VAZIOutfitCard> createState() => _VAZIOutfitCardState();
}

class _VAZIOutfitCardState extends State<VAZIOutfitCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Collage items: up to 3 are shown in the main stack
    final List<VAZIOutfitItem> stackItems = widget.items.take(3).toList();
    final bool hasMore = widget.items.length > 3;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: MitumbaColors.surface,
            borderRadius: BorderRadius.circular(MitumbaRadius.lg),
            boxShadow: _isHovered ? MitumbaShadows.deep : MitumbaShadows.card,
          ),
          clipBehavior: Clip.antiAlias,
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered ? -8.0 : 0.0)
            ..scale(_isHovered ? 1.01 : 1.0),
          transformAlignment: Alignment.center,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Collage Section
                  Container(
                    height: 280,
                    width: double.infinity,
                    color: MitumbaColors.background,
                    padding: const EdgeInsets.all(24.0),
                    child: Stack(
                      children: [
                        // Light leak background overlay
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  Color(0x0DA06235), // earth color light leak
                                  Colors.transparent,
                                ],
                                radius: 0.7,
                              ),
                            ),
                          ),
                        ),

                        // overlapping stack items
                        Center(
                          child: SizedBox(
                            width: 140,
                            height: 180,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: List.generate(stackItems.length, (index) {
                                // Stack order: index 0 (main) must be on top (highest Z-index).
                                // Flutter stack renders last item on top.
                                // So we reverse the item indices: Z-order 0 is last, Z-order 2 is first.
                                final int itemIndex = stackItems.length - 1 - index;
                                final VAZIOutfitItem item = stackItems[itemIndex];
                                final bool isMain = itemIndex == 0;

                                double rotation = 0.0;
                                double leftOffset = 0.0;

                                if (itemIndex == 1) {
                                  rotation = _isHovered ? 4.0 : -4.0;
                                  leftOffset = _isHovered ? 20.0 : -12.0; // translate right when hovered
                                } else if (itemIndex == 2) {
                                  rotation = _isHovered ? -4.0 : 4.0;
                                  leftOffset = _isHovered ? -20.0 : 12.0; // translate left when hovered
                                }

                                return AnimatedPositioned(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeOutBack,
                                  top: isMain ? 0 : 4,
                                  left: isMain ? 0 : leftOffset,
                                  width: 140,
                                  height: 180,
                                  child: AnimatedRotation(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeOutBack,
                                    turns: rotation / 360.0,
                                    alignment: Alignment.center,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: MitumbaColors.surface,
                                        borderRadius: BorderRadius.circular(MitumbaRadius.md),
                                        border: Border.all(color: MitumbaColors.white, width: 2),
                                        boxShadow: MitumbaShadows.card,
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.network(
                                        item.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: MitumbaColors.divider,
                                            alignment: Alignment.center,
                                            child: const Icon(
                                              Icons.broken_image_outlined,
                                              color: MitumbaColors.textSecondary,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),

                        // More Items Count Badge overlay
                        if (hasMore)
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: MitumbaGlass(
                              rounding: MitumbaGlassRounding.full,
                              opacity: 0.8,
                              blur: 12,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                                child: Text(
                                  '+${widget.items.length - 3} MORE',
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: MitumbaColors.earth,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Content Section
                  Padding(
                    padding: const EdgeInsets.all(20.0), // p: 2.5 * 8 = 20px
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          widget.outfitName,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: MitumbaTypography.fontSizeLg,
                            fontWeight: FontWeight.w900,
                            color: MitumbaColors.textPrimary,
                            height: 1.1,
                            letterSpacing: -0.01,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),

                        // Subtitle Meta Row
                        Row(
                          children: [
                            Text(
                              '${widget.sellersCount} SELLERS',
                              style: const TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: MitumbaColors.textSecondary,
                                letterSpacing: 0.05,
                              ),
                            ),
                            if (widget.isMultiCity) ...[
                              const SizedBox(width: 8),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(
                                  color: MitumbaColors.divider,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.local_shipping_outlined,
                                size: 14,
                                color: MitumbaColors.earth,
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'MULTI-CITY',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: MitumbaColors.earth,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Footer Action Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'TOTAL LOOK',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: MitumbaColors.textDisabled,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'KES ${widget.totalPriceKes.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: MitumbaTypography.fontSizeXl,
                                    fontWeight: FontWeight.w900,
                                    color: MitumbaColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            if (widget.onBuyAll != null)
                              MitumbaPrimaryButton(
                                label: 'Buy entire look',
                                variant: ButtonVariant.earth,
                                size: ButtonSize.small,
                                onPressed: widget.onBuyAll!,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Float VAZI badge top-left
              const Positioned(
                top: 12,
                left: 12,
                child: VAZIBadge(size: VAZIBadgeSize.small),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
