import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/shadows.dart';
import '../../tokens/spacing.dart';
import '../feedback/mitumba_skeleton.dart';
import '../foundation/mitumba_glass.dart';
import '../foundation/mitumba_primary_button.dart';
import 'vazi_badge.dart';

/// Media type for VAZI model display.
enum VAZIMediaType { image, video }

/// A single item in a VAZI outfit.
class VAZIShowcaseItem {
  const VAZIShowcaseItem({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

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

/// VAZIShowcase — high-fashion vertical/depth swipe carousel of AI-curated outfits.
/// Engineered with atmospheric spotlights, floating glass panels, and living model float physics.
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

class _VAZIShowcaseState extends State<VAZIShowcase> with TickerProviderStateMixin {
  late PageController _pageCtrl;
  late int _current;
  bool _isAnimating = false;
  late AnimationController _floatController;
  late AnimationController _heartController;
  bool _showHeart = false;

  @override
  void initState() {
    super.initState();
    _current = widget.activeIndex;
    _pageCtrl = PageController(initialPage: _current);
    _floatController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _heartController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _floatController.dispose();
    _heartController.dispose();
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

  void _triggerHeartPop() {
    if (widget.onSaveLook != null) {
      widget.onSaveLook!(widget.outfits[_current].id);
    }
    setState(() {
      _showHeart = true;
    });
    _heartController.forward(from: 0.0).then((_) {
      if (mounted) {
        setState(() {
          _showHeart = false;
        });
      }
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

  // ═══ DESKTOP — High Fashion Spotlight Stage ═══
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
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF070B08), // deep forest green-black
                Color(0xFF111210), // rich charcoal-black
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Ambient soft Earth glow behind Left Editorial Panel
              Positioned(
                left: -150,
                top: -150,
                child: Container(
                  width: 500,
                  height: 500,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        MitumbaColors.earth.withOpacity(0.06),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Ambient Glowing Spotlight Circle behind active model (breathing)
              Positioned.fill(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _floatController,
                    builder: (context, child) {
                      final pulse = _floatController.value;
                      final size = 350.0 + pulse * 60.0;
                      final opacity = 0.12 + pulse * 0.08;
                      return Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              MitumbaColors.green.withOpacity(opacity),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Runway Glossy Floor Shadow Reflection overlay
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 140,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        const Color(0xFF070B08).withOpacity(0.8),
                        const Color(0xFF070B08),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              // UI Content Layer
              Row(
                children: [
                  // Left — Editorial Info Section
                  SizedBox(
                    width: 280,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: MitumbaSpacing.huge,
                        horizontal: MitumbaSpacing.xxl,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(
                                    Icons.auto_awesome,
                                    size: 16,
                                    color: MitumbaColors.earth,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'VAZI STYLIST',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      color: MitumbaColors.earth,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: MitumbaSpacing.lg),
                              const Text(
                                'AI-curated outfit lookbook matching the perfect designer taste.',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 13,
                                  color: MitumbaColors.textDisabled,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'LOOK ${(_current + 1).toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 32,
                                  fontWeight: FontWeight.w300,
                                  color: MitumbaColors.white,
                                  letterSpacing: 4,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Sleek Progress Line
                              Stack(
                                children: [
                                  Container(
                                    width: 140,
                                    height: 2,
                                    color: MitumbaColors.divider.withOpacity(0.1),
                                  ),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: (140 / widget.outfits.length) * (_current + 1),
                                    height: 2,
                                    color: MitumbaColors.green,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '${_current + 1} of ${widget.outfits.length}',
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 11,
                                  color: MitumbaColors.textDisabled,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Center — 3D Living Model Carousel
                  Expanded(
                    flex: 2,
                    child: _Desktop3DCarousel(
                      outfits: widget.outfits,
                      current: _current,
                      onNavigate: _navigateTo,
                      floatAnimation: _floatController,
                      onDoubleTap: _triggerHeartPop,
                    ),
                  ),

                  // Right — Floating Glassmorphism Outfit Panel
                  SizedBox(
                    width: 320,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: _OutfitPanel(
                          outfit: activeOutfit,
                          onItemClick: widget.onItemClick,
                          onShopAll: widget.onShopAll,
                          onSaveLook: widget.onSaveLook,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Heart Pop overlay
              if (_showHeart)
                IgnorePointer(
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _heartController,
                      builder: (context, child) {
                        final scale = TweenSequence<double>([
                          TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.3), weight: 40),
                          TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 20),
                          TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 40),
                        ]).evaluate(_heartController);

                        final opacity = TweenSequence<double>([
                          TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 45),
                          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 15),
                          TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 40),
                        ]).evaluate(_heartController);

                        return Opacity(
                          opacity: opacity,
                          child: Transform.scale(
                            scale: scale,
                            child: const Icon(
                              Icons.favorite,
                              color: Color(0xFFE74C3C),
                              size: 100,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══ MOBILE — Vertical Swipe Feed ═══
  Widget _buildMobile() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF070B08),
            Color(0xFF111210),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          // Spotlight glow in background (breathing)
          Positioned.fill(
            child: Center(
              child: AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) {
                  final pulse = _floatController.value;
                  return Container(
                    width: 260 + pulse * 50,
                    height: 260 + pulse * 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MitumbaColors.green.withOpacity(0.08 + pulse * 0.04),
                    ),
                  );
                },
              ),
            ),
          ),

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
              onDoubleTap: _triggerHeartPop,
            ),
          ),

          // Right vertical progress dots
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
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    width: 4,
                    height: active ? 28 : 8,
                    decoration: BoxDecoration(
                      color: active ? MitumbaColors.green : MitumbaColors.textDisabled.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(MitumbaRadius.full),
                    ),
                  );
                }),
              ),
            ),
          ),

          // VAZI Branding overlay
          Positioned(
            top: MitumbaSpacing.lg,
            left: MitumbaSpacing.lg,
            child: const VAZIBadge(size: VAZIBadgeSize.small),
          ),

          // Heart Pop overlay (mobile)
          if (_showHeart)
            IgnorePointer(
              child: Center(
                child: AnimatedBuilder(
                  animation: _heartController,
                  builder: (context, child) {
                    final scale = TweenSequence<double>([
                      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.3), weight: 40),
                      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 20),
                      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 40),
                    ]).evaluate(_heartController);

                    final opacity = TweenSequence<double>([
                      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 45),
                      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 15),
                      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 40),
                    ]).evaluate(_heartController);

                    return Opacity(
                      opacity: opacity,
                      child: Transform.scale(
                        scale: scale,
                        child: const Icon(
                          Icons.favorite,
                          color: Color(0xFFE74C3C),
                          size: 80,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Desktop 3D perspective carousel — models arranged in depth with blur/scale falloff and float physics.
class _Desktop3DCarousel extends StatelessWidget {
  const _Desktop3DCarousel({
    required this.outfits,
    required this.current,
    required this.onNavigate,
    required this.floatAnimation,
    this.onDoubleTap,
  });

  final List<VAZIShowcaseOutfit> outfits;
  final int current;
  final ValueChanged<int> onNavigate;
  final Animation<double> floatAnimation;
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: List.generate(outfits.length, (i) {
        final diff = i - current;
        final absDiff = diff.abs();
        if (absDiff > 3) return const SizedBox.shrink();

        final isActive = diff == 0;
        final scale = isActive ? 1.0 : (0.7 - absDiff * 0.12).clamp(0.4, 0.75);
        final xOffset = diff * 180.0;
        final opacity = isActive ? 1.0 : (0.5 - (absDiff - 1) * 0.15).clamp(0.0, 0.5);
        final blur = isActive ? 0.0 : (absDiff * 3.0).clamp(0.0, 10.0);

        Widget modelImg = Image.network(
          outfits[i].modelMediaUrl,
          height: 520,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const SizedBox(
              width: 240,
              height: 480,
              child: MitumbaSkeleton(variant: MitumbaSkeletonVariant.rectangular),
            );
          },
          errorBuilder: (_, __, ___) => const SizedBox(
            width: 240,
            height: 480,
            child: MitumbaSkeleton(variant: MitumbaSkeletonVariant.rectangular),
          ),
        );

        // Apply dynamic float animation to active model
        if (isActive) {
          modelImg = AnimatedBuilder(
            animation: floatAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, floatAnimation.value * 12.0 - 6.0),
                child: child,
              );
            },
            child: modelImg,
          );
        }

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
              onDoubleTap: isActive ? onDoubleTap : null,
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
                    child: modelImg,
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

/// Slideshow item containing vertical full-page view for mobile layout.
class _OutfitSlide extends StatelessWidget {
  const _OutfitSlide({
    required this.outfit,
    this.onItemClick,
    this.onShopAll,
    this.onSaveLook,
    this.onDoubleTap,
  });

  final VAZIShowcaseOutfit outfit;
  final ValueChanged<String>? onItemClick;
  final ValueChanged<String>? onShopAll;
  final ValueChanged<String>? onSaveLook;
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Model Media Background
        GestureDetector(
          onDoubleTap: onDoubleTap,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 220),
              child: Image.network(
                outfit.modelMediaUrl,
                fit: BoxFit.contain,
                height: double.infinity,
                errorBuilder: (_, __, ___) => const SizedBox(
                  width: 200,
                  height: 400,
                  child: MitumbaSkeleton(variant: MitumbaSkeletonVariant.rectangular),
                ),
              ),
            ),
          ),
        ),

        // Bottom Outfit floating panel overlay
        Positioned(
          left: 12,
          right: 12,
          bottom: 12,
          child: _OutfitPanel(
            outfit: outfit,
            onItemClick: onItemClick,
            onShopAll: onShopAll,
            onSaveLook: onSaveLook,
          ),
        ),
      ],
    );
  }
}

/// Premium Glassmorphic floating outfit display container.
class _OutfitPanel extends StatelessWidget {
  const _OutfitPanel({
    required this.outfit,
    this.onItemClick,
    this.onShopAll,
    this.onSaveLook,
  });

  final VAZIShowcaseOutfit outfit;
  final ValueChanged<String>? onItemClick;
  final ValueChanged<String>? onShopAll;
  final ValueChanged<String>? onSaveLook;

  @override
  Widget build(BuildContext context) {
    return MitumbaGlass(
      rounding: MitumbaGlassRounding.large,
      opacity: 0.1, // very sleek dark glass
      blur: 24,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Look Header Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TOTAL LOOK PRICE',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: MitumbaColors.textDisabled,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'KES ${outfit.totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: MitumbaColors.white,
                      ),
                    ),
                  ],
                ),
                if (onSaveLook != null)
                  IconButton(
                    icon: const Icon(
                      Icons.favorite_border,
                      size: 20,
                      color: MitumbaColors.white,
                    ),
                    onPressed: () => onSaveLook!(outfit.id),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Stylist items thumbs row
            SizedBox(
              height: 64,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: outfit.items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) => _ItemThumb(
                  item: outfit.items[i],
                  onTap: onItemClick,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Action Primary Button
            if (onShopAll != null)
              SizedBox(
                width: double.infinity,
                child: MitumbaPrimaryButton(
                  label: 'Shop this look',
                  variant: ButtonVariant.earth,
                  size: ButtonSize.medium,
                  onPressed: () => onShopAll!(outfit.id),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Floating list item thumbnail.
class _ItemThumb extends StatefulWidget {
  const _ItemThumb({
    required this.item,
    this.onTap,
  });

  final VAZIShowcaseItem item;
  final ValueChanged<String>? onTap;

  @override
  State<_ItemThumb> createState() => _ItemThumbState();
}

class _ItemThumbState extends State<_ItemThumb> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap != null ? () => widget.onTap!(widget.item.id) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 64,
          height: 64,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(MitumbaRadius.md),
            border: Border.all(
              color: _isHovered ? MitumbaColors.earth : MitumbaColors.white.withOpacity(0.15),
              width: 2,
            ),
            boxShadow: _isHovered ? MitumbaShadows.card : null,
          ),
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered ? -4.0 : 0.0)
            ..scale(_isHovered ? 1.05 : 1.0),
          transformAlignment: Alignment.center,
          child: Image.network(
            widget.item.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: MitumbaColors.divider.withOpacity(0.2),
              child: const Icon(
                Icons.image_not_supported_outlined,
                size: 16,
                color: MitumbaColors.textDisabled,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
