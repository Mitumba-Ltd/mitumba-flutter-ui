import 'dart:ui';

import 'package:flutter/gestures.dart';
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
  bool _isAnimating = false;

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

  void _navigateTo(int index) {
    if (index < 0 || index >= widget.outfits.length || index == _current || _isAnimating) return;
    setState(() {
      _isAnimating = true;
      _current = index;
    });
    widget.onIndexChange?.call(index);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _isAnimating = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.outfits.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= 900) {
        return _buildDesktop(constraints);
      }
      return _buildMobile();
    });
  }

  // ═══ DESKTOP — 3D perspective carousel ═══
  Widget _buildDesktop(BoxConstraints constraints) {
    final activeOutfit = widget.outfits[_current];

    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity == null) return;
        if (details.primaryVelocity! < -200) {
          _navigateTo(_current + 1);
        } else if (details.primaryVelocity! > 200) {
          _navigateTo(_current - 1);
        }
      },
      child: Listener(
        onPointerSignal: (event) {
          if (event is PointerScrollEvent) {
            if (event.scrollDelta.dy.abs() < 30) return;
            if (event.scrollDelta.dy > 0) {
              _navigateTo(_current + 1);
            } else {
              _navigateTo(_current - 1);
            }
          }
        },
        child: Container(
        width: double.infinity,
        height: constraints.maxHeight > 0 ? constraints.maxHeight : 700,
        color: const Color(0xFFE8F0F2),
        child: Row(
          children: [
          // Left — collection info
          SizedBox(
            width: 240,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: MitumbaSpacing.huge, horizontal: MitumbaSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('VAZI Collection', style: MitumbaTypography.caption.copyWith(
                        letterSpacing: 2,
                        color: MitumbaColors.textSecondary,
                      )),
                      SizedBox(height: MitumbaSpacing.lg),
                      Text(
                        'AI-curated outfit combinations from verified Mitumba sellers.',
                        style: MitumbaTypography.body2.copyWith(color: MitumbaColors.textSecondary),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LOOK ${(_current + 1).toString().padLeft(2, '0')}',
                        style: MitumbaTypography.h2.copyWith(fontWeight: FontWeight.w300, letterSpacing: 4),
                      ),
                      Text(
                        '${_current + 1} of ${widget.outfits.length}',
                        style: MitumbaTypography.caption.copyWith(
                          letterSpacing: 3,
                          color: MitumbaColors.textDisabled,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Center — 3D perspective model carousel
          Expanded(
            flex: 2,
            child: _Desktop3DCarousel(
              outfits: widget.outfits,
              current: _current,
              onNavigate: _navigateTo,
            ),
          ),

          // Right — outfit panel (will be enhanced in glassmorphism task)
          SizedBox(
            width: 300,
            child: _OutfitPanel(
              outfit: activeOutfit,
              onItemClick: widget.onItemClick,
              onShopAll: widget.onShopAll,
              onSaveLook: widget.onSaveLook,
            ),
          ),
        ],
      ),
      ),
      ),
    );
  }

  // ═══ MOBILE — vertical swipe (existing behavior, kept here) ═══
  Widget _buildMobile() {
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
          // Look counter — glassmorphism pill
          Positioned(
            top: MitumbaSpacing.lg,
            left: MitumbaSpacing.lg,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(MitumbaRadius.full),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: MitumbaSpacing.md, vertical: MitumbaSpacing.xs),
                  decoration: BoxDecoration(
                    color: MitumbaColors.white.withAlpha(200),
                    borderRadius: BorderRadius.circular(MitumbaRadius.full),
                  ),
                  child: Text(
                    '${_current + 1} / ${widget.outfits.length}',
                    style: MitumbaTypography.caption.copyWith(fontWeight: FontWeight.w700, color: MitumbaColors.textPrimary),
                  ),
                ),
              ),
            ),
          ),
          // VAZI pill — top right
          Positioned(
            top: MitumbaSpacing.lg,
            right: MitumbaSpacing.lg,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(MitumbaRadius.full),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: MitumbaSpacing.md, vertical: MitumbaSpacing.xs),
                  decoration: BoxDecoration(
                    color: MitumbaColors.white.withAlpha(200),
                    borderRadius: BorderRadius.circular(MitumbaRadius.full),
                  ),
                  child: Text(
                    'VAZI',
                    style: MitumbaTypography.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: MitumbaColors.earth,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Desktop 3D perspective carousel — models arranged in depth with blur/scale falloff.
class _Desktop3DCarousel extends StatelessWidget {
  const _Desktop3DCarousel({
    required this.outfits,
    required this.current,
    required this.onNavigate,
  });

  final List<VAZIShowcaseOutfit> outfits;
  final int current;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: List.generate(outfits.length, (i) {
        final diff = i - current;
        final absDiff = diff.abs();
        if (absDiff > 3) return const SizedBox.shrink();

        final isActive = diff == 0;
        final scale = isActive ? 1.0 : (0.7 - absDiff * 0.15).clamp(0.3, 0.7);
        final xOffset = diff * 140.0;
        final opacity = isActive ? 1.0 : (0.6 - (absDiff - 1) * 0.2).clamp(0.0, 0.6);
        final blur = isActive ? 0.0 : (absDiff * 4.0).clamp(0.0, 12.0);

        return AnimatedPositioned(
          duration: const Duration(milliseconds: 800),
          curve: const Cubic(0.25, 0.46, 0.45, 0.94),
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: Center(
            child: GestureDetector(
              onTap: !isActive ? () => onNavigate(i) : null,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 800),
                curve: const Cubic(0.25, 0.46, 0.45, 0.94),
                opacity: opacity,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  curve: const Cubic(0.25, 0.46, 0.45, 0.94),
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..translate(xOffset, 0.0, isActive ? 200.0 : -200.0 * absDiff)
                    ..scale(scale),
                  transformAlignment: Alignment.center,
                  child: ImageFiltered(
                    imageFilter: blur > 0
                        ? ImageFilter.blur(sigmaX: blur, sigmaY: blur)
                        : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Image.network(
                      outfits[i].modelMediaUrl,
                      height: 500,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.person,
                        size: 120,
                        color: MitumbaColors.textDisabled,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(MitumbaRadius.xl),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          margin: EdgeInsets.all(MitumbaSpacing.lg),
          padding: EdgeInsets.all(MitumbaSpacing.lg),
          decoration: BoxDecoration(
            color: MitumbaColors.white.withAlpha(64),
            borderRadius: BorderRadius.circular(MitumbaRadius.xl),
            border: Border.all(color: MitumbaColors.white.withAlpha(102)),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 8),
                blurRadius: 32,
                color: Color(0x0D000000),
              ),
            ],
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
        ),
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
