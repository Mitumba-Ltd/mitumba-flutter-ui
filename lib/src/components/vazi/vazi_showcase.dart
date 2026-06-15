import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// A single item in a VAZI outfit.
class VAZIShowcaseItem {
  const VAZIShowcaseItem({required this.id, required this.title, required this.price, required this.imageUrl});

  /// Listing ID.
  final String id;

  /// Item title.
  final String title;

  /// Price in KES.
  final int price;

  /// Thumbnail URL.
  final String imageUrl;
}

/// A complete outfit in the VAZI showcase.
class VAZIShowcaseOutfit {
  const VAZIShowcaseOutfit({
    required this.id,
    required this.modelMediaUrl,
    this.modelMediaType = VAZIMediaType.image,
    this.modelAlt = '',
    required this.items,
    required this.totalPrice,
  });

  /// Unique outfit ID.
  final String id;

  /// Model media URL (image or video).
  final String modelMediaUrl;

  /// Media type.
  final VAZIMediaType modelMediaType;

  /// Alt text for accessibility.
  final String modelAlt;

  /// Items in this outfit.
  final List<VAZIShowcaseItem> items;

  /// Total outfit price in KES.
  final int totalPrice;
}

/// Media type for VAZI model display.
enum VAZIMediaType { image, video }

/// VAZIShowcase — vertical swipe carousel of AI-curated outfits.
///
/// Mirrors the web `VAZIShowcase` from `@mitumba/ui`.
///
/// ```dart
/// VAZIShowcase(
///   outfits: [outfit1, outfit2],
///   onItemClick: (id) => navigateToListing(id),
///   onShopAll: (outfitId) => addAllToCart(outfitId),
/// )
/// ```
class VAZIShowcase extends StatefulWidget {
  const VAZIShowcase({
    super.key,
    required this.outfits,
    this.activeIndex = 0,
    this.onIndexChange,
    this.onItemClick,
    this.onShopAll,
    this.onSaveLook,
  });

  /// Outfits to display.
  final List<VAZIShowcaseOutfit> outfits;

  /// Initial active index.
  final int activeIndex;

  /// Called when the active outfit changes.
  final ValueChanged<int>? onIndexChange;

  /// Called when a listing item is tapped.
  final ValueChanged<String>? onItemClick;

  /// Called when "Shop this look" is tapped.
  final ValueChanged<String>? onShopAll;

  /// Called when user saves a look.
  final ValueChanged<String>? onSaveLook;

  @override
  State<VAZIShowcase> createState() => _VAZIShowcaseState();
}

class _VAZIShowcaseState extends State<VAZIShowcase> {
  late PageController _pageCtrl;
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.activeIndex;
    _pageCtrl = PageController(initialPage: _current);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.outfits.isEmpty) return const SizedBox.shrink();

    return Container(
      color: const Color(0xFFE8F0F2),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageCtrl,
            scrollDirection: Axis.vertical,
            itemCount: widget.outfits.length,
            onPageChanged: (i) {
              setState(() => _current = i);
              widget.onIndexChange?.call(i);
            },
            itemBuilder: (_, i) => _OutfitSlide(
              outfit: widget.outfits[i],
              onItemClick: widget.onItemClick,
              onShopAll: widget.onShopAll,
              onSaveLook: widget.onSaveLook,
            ),
          ),
          // Progress indicator
          Positioned(
            right: MitumbaSpacing.lg,
            top: 0,
            bottom: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(widget.outfits.length, (i) {
                  final active = i == _current;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    width: 4,
                    height: active ? 24 : 8,
                    decoration: BoxDecoration(
                      color: active ? MitumbaColors.green : MitumbaColors.border,
                      borderRadius: BorderRadius.circular(MitumbaRadius.full),
                    ),
                  );
                }),
              ),
            ),
          ),
          // Look counter
          Positioned(
            top: MitumbaSpacing.xxl,
            left: MitumbaSpacing.lg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('VAZI', style: MitumbaTypography.caption.copyWith(
                  letterSpacing: 2,
                  color: MitumbaColors.textSecondary,
                )),
                SizedBox(height: MitumbaSpacing.xs),
                Text(
                  'LOOK ${(_current + 1).toString().padLeft(2, '0')}',
                  style: MitumbaTypography.h3.copyWith(fontWeight: FontWeight.w300, letterSpacing: 2),
                ),
                Text(
                  '${_current + 1} of ${widget.outfits.length}',
                  style: MitumbaTypography.caption.copyWith(color: MitumbaColors.textDisabled, letterSpacing: 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OutfitSlide extends StatelessWidget {
  const _OutfitSlide({required this.outfit, this.onItemClick, this.onShopAll, this.onSaveLook});
  final VAZIShowcaseOutfit outfit;
  final ValueChanged<String>? onItemClick;
  final ValueChanged<String>? onShopAll;
  final ValueChanged<String>? onSaveLook;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Model media
        Center(
          child: Image.network(
            outfit.modelMediaUrl,
            fit: BoxFit.contain,
            height: double.infinity,
            errorBuilder: (_, __, ___) => Icon(Icons.person, size: 120, color: MitumbaColors.textDisabled),
          ),
        ),
        // Bottom outfit panel
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _OutfitPanel(outfit: outfit, onItemClick: onItemClick, onShopAll: onShopAll, onSaveLook: onSaveLook),
        ),
      ],
    );
  }
}

class _OutfitPanel extends StatelessWidget {
  const _OutfitPanel({required this.outfit, this.onItemClick, this.onShopAll, this.onSaveLook});
  final VAZIShowcaseOutfit outfit;
  final ValueChanged<String>? onItemClick;
  final ValueChanged<String>? onShopAll;
  final ValueChanged<String>? onSaveLook;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(MitumbaSpacing.lg),
      padding: EdgeInsets.all(MitumbaSpacing.lg),
      decoration: BoxDecoration(
        color: MitumbaColors.surface.withAlpha(230),
        borderRadius: BorderRadius.circular(MitumbaRadius.xl),
        border: Border.all(color: MitumbaColors.divider),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'KES ${_formatPrice(outfit.totalPrice)}',
                  style: MitumbaTypography.h5,
                ),
              ),
              if (onSaveLook != null)
                IconButton(
                  icon: const Icon(Icons.favorite_border, size: 20),
                  onPressed: () => onSaveLook!(outfit.id),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          SizedBox(height: MitumbaSpacing.md),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: outfit.items.length,
              separatorBuilder: (_, __) => SizedBox(width: MitumbaSpacing.md),
              itemBuilder: (_, i) => _ItemThumb(item: outfit.items[i], onTap: onItemClick),
            ),
          ),
          SizedBox(height: MitumbaSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onShopAll != null ? () => onShopAll!(outfit.id) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: MitumbaColors.green,
                foregroundColor: MitumbaColors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MitumbaRadius.md)),
              ),
              child: const Text('Shop this look'),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
  }
}

class _ItemThumb extends StatelessWidget {
  const _ItemThumb({required this.item, this.onTap});
  final VAZIShowcaseItem item;
  final ValueChanged<String>? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null ? () => onTap!(item.id) : null,
      child: Container(
        width: 64,
        height: 64,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MitumbaRadius.md),
          border: Border.all(color: MitumbaColors.border),
        ),
        child: Image.network(
          item.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(color: MitumbaColors.background),
        ),
      ),
    );
  }
}
