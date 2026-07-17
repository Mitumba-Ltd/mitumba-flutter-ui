import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../foundation/mitumba_primary_button.dart';
import '../foundation/mitumba_glass.dart';
import 'vazi_showcase.dart'; // To reuse VAZIShowcaseItem

/// An outfit displayed in the [VAZIHeroSpotlight].
class VAZIHeroOutfit {
  const VAZIHeroOutfit({
    required this.id,
    required this.modelMediaUrl,
    required this.modelMediaType,
    required this.modelAlt,
    required this.name,
    required this.items,
    required this.totalPrice,
  });

  final String id;
  final String modelMediaUrl;
  final String modelMediaType; // 'video' | 'image'
  final String modelAlt;
  final String name;
  final List<VAZIShowcaseItem> items;
  final double totalPrice;
}

/// Premium VAZIHeroSpotlight - row of living models standing side by side.
/// Tap/click a model -> floating popover shows outfit details + "Shop" CTA.
class VAZIHeroSpotlight extends StatefulWidget {
  const VAZIHeroSpotlight({
    super.key,
    required this.outfits,
    this.title = 'VAZI Featured',
    this.onShopLook,
    this.onItemClick,
    this.onSeeAll,
  });

  final List<VAZIHeroOutfit> outfits;
  final String title;
  final ValueChanged<String>? onShopLook;
  final ValueChanged<String>? onItemClick;
  final VoidCallback? onSeeAll;

  @override
  State<VAZIHeroSpotlight> createState() => _VAZIHeroSpotlightState();
}

class _VAZIHeroSpotlightState extends State<VAZIHeroSpotlight> {
  String? _activeId;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _hidePopover() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() {
        _activeId = null;
      });
    }
  }

  void _showPopover(BuildContext context, VAZIHeroOutfit outfit, Offset tapPosition) {
    _hidePopover();

    setState(() {
      _activeId = outfit.id;
    });

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Click-away listener
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _hidePopover,
                child: const SizedBox.shrink(),
              ),
            ),
            Positioned(
              left: tapPosition.dx - 130, // Centered on click
              top: tapPosition.dy + 10,  // Slightly below click
              child: Material(
                color: Colors.transparent,
                child: MitumbaGlass(
                  rounding: MitumbaGlassRounding.rounded,
                  child: Container(
                    width: 260,
                    padding: const EdgeInsets.all(MitumbaSpacing.lg),
                    decoration: BoxDecoration(
                      border: Border.all(color: MitumbaColors.white.withValues(alpha: 0.6)),
                      borderRadius: BorderRadius.circular(MitumbaRadius.lg),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          outfit.name,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: MitumbaTypography.fontSizeBase,
                            fontWeight: FontWeight.w700,
                            color: MitumbaColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: MitumbaSpacing.md),
                        // Item thumbnails
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: outfit.items.length,
                            itemBuilder: (context, index) {
                              final item = outfit.items[index];
                              return GestureDetector(
                                onTap: () {
                                  _hidePopover();
                                  widget.onItemClick?.call(item.id);
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  margin: const EdgeInsets.only(right: MitumbaSpacing.sm),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(MitumbaRadius.sm),
                                    border: Border.all(color: Colors.black12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(MitumbaRadius.sm),
                                    child: Image.network(
                                      item.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: MitumbaColors.background,
                                        alignment: Alignment.center,
                                        child: const Icon(Icons.broken_image, size: 16, color: MitumbaColors.textDisabled),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: MitumbaSpacing.lg),
                        // Price + CTA
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${outfit.items.length} items',
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 11,
                                    color: MitumbaColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  'KES ${outfit.totalPrice.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: MitumbaTypography.fontSizeMd,
                                    fontWeight: FontWeight.w800,
                                    color: MitumbaColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            MitumbaPrimaryButton(
                              label: 'Shop',
                              size: ButtonSize.small,
                              onPressed: () {
                                _hidePopover();
                                widget.onShopLook?.call(outfit.id);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: MitumbaTypography.fontSizeLg,
                fontWeight: FontWeight.w800,
                color: MitumbaColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            if (widget.onSeeAll != null)
              GestureDetector(
                onTap: widget.onSeeAll,
                child: const Text(
                  'See all',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: MitumbaColors.green,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: MitumbaSpacing.lg),

        // Grid / Row
        Container(
          height: 380,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF0F4F5), Color(0xFFE8EEF0)],
            ),
            borderRadius: BorderRadius.circular(MitumbaRadius.xl),
          ),
          child: CompositedTransformTarget(
            link: _layerLink,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(MitumbaSpacing.md),
              itemCount: widget.outfits.length,
              itemBuilder: (context, index) {
                final outfit = widget.outfits[index];
                final isActive = _activeId == outfit.id;

                return GestureDetector(
                  onTapUp: (details) {
                    _showPopover(context, outfit, details.globalPosition);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: MitumbaSpacing.md),
                    width: 200,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(MitumbaRadius.lg),
                      boxShadow: isActive
                          ? const [BoxShadow(color: Colors.black12, blurRadius: 24, offset: Offset(0, 8))]
                          : null,
                    ),
                    transform: Matrix4.identity()..scale(isActive ? 1.02 : 1.0),
                    transformAlignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(MitumbaRadius.lg),
                      child: Image.network(
                        outfit.modelMediaUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: MitumbaColors.background,
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image, color: MitumbaColors.textDisabled),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
