import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/shadows.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Item condition values for a listing.
enum ListingCondition { newItem, likeNew, good, fair }

/// Returns true if the URL points to a video file.
bool _isVideoUrl(String url) {
  return RegExp(r'\.(mp4|webm|mov)(\?|$)', caseSensitive: false).hasMatch(url);
}

const _conditionLabels = {
  ListingCondition.newItem: 'New',
  ListingCondition.likeNew: 'Like New',
  ListingCondition.good: 'Good',
  ListingCondition.fair: 'Fair',
};

/// A listing card — Pinterest/Depop-style. Supports multi-image media carousel,
/// wishlist toggle, add-to-cart, and condition chip.
///
/// Mirrors the web `ListingCard` component from `@mitumba/ui`.
///
/// ```dart
/// ListingCard(
///   id: '123',
///   title: 'Vintage Leather Jacket',
///   price: 3500,
///   media: ['https://example.com/img.jpg'],
///   onTap: (id) => print(id),
/// )
/// ```
class ListingCard extends StatefulWidget {
  /// Creates a listing card.
  const ListingCard({
    super.key,
    required this.id,
    required this.title,
    required this.price,
    required this.media,
    this.storeName,
    this.condition,
    this.isSaved = false,
    this.onSaveToggle,
    this.onTap,
    this.onAddToCart,
    this.originalPrice,
  });

  /// Unique listing identifier.
  final String id;

  /// Listing title — truncated to 2 lines.
  final String title;

  /// Price in KES.
  final int price;

  /// Media URLs — first shown by default, swipeable.
  final List<String> media;

  /// Seller/store name shown as caption.
  final String? storeName;

  /// Item condition.
  final ListingCondition? condition;

  /// Whether the buyer has saved/wishlisted this item.
  final bool isSaved;

  /// Called when the heart icon is toggled.
  final ValueChanged<String>? onSaveToggle;

  /// Called when the card is tapped.
  final ValueChanged<String>? onTap;

  /// Called when "Add to cart" is tapped.
  final ValueChanged<String>? onAddToCart;

  /// Original price before discount (shown with strikethrough).
  final int? originalPrice;

  @override
  State<ListingCard> createState() => _ListingCardState();
}

class _ListingCardState extends State<ListingCard> with SingleTickerProviderStateMixin {
  int _activeIndex = 0;
  bool _cartAdded = false;
  bool _imageLoaded = false;
  bool _pressed = false;
  bool _hovered = false;
  late final AnimationController _shimmerCtrl;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  void _handleCart() {
    if (_cartAdded) return;
    setState(() => _cartAdded = true);
    widget.onAddToCart?.call(widget.id);
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _cartAdded = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasMultiple = widget.media.length > 1;

    return MouseRegion(
      onEnter: widget.onTap != null ? (_) => setState(() => _hovered = true) : null,
      onExit: widget.onTap != null ? (_) => setState(() => _hovered = false) : null,
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: Semantics(
        label: '${widget.title}, KES ${_formatPrice(widget.price)}${widget.storeName != null ? ', ${widget.storeName}' : ''}',
        button: widget.onTap != null,
        image: true,
        child: GestureDetector(
        onTap: widget.onTap != null ? () => widget.onTap!(widget.id) : null,
        onTapDown: widget.onTap != null ? (_) => setState(() => _pressed = true) : null,
        onTapUp: widget.onTap != null ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: widget.onTap != null ? () => setState(() => _pressed = false) : null,
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(0, _hovered ? -2 : 0, 0),
            decoration: BoxDecoration(
              color: MitumbaColors.surface,
              borderRadius: BorderRadius.circular(MitumbaRadius.lg),
              border: Border.all(
                color: _hovered ? MitumbaColors.green : MitumbaColors.border,
              ),
              boxShadow: _hovered ? MitumbaShadows.elevated : null,
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMedia(hasMultiple),
                _buildContent(),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildMedia(bool hasMultiple) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 3 / 4,
          child: hasMultiple
              ? PageView.builder(
                  itemCount: widget.media.length,
                  onPageChanged: (i) => setState(() {
                    _activeIndex = i;
                    _imageLoaded = false;
                  }),
                  itemBuilder: (_, i) => _mediaItem(widget.media[i]),
                )
              : _mediaItem(widget.media.first),
        ),
        // Dots
        if (hasMultiple)
          Positioned(
            bottom: MitumbaSpacing.md,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.media.length, (i) {
                final active = i == _activeIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: active ? 12 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: MitumbaColors.white.withAlpha(active ? 255 : 140),
                    borderRadius: BorderRadius.circular(MitumbaRadius.full),
                  ),
                );
              }),
            ),
          ),
        // Heart
        if (widget.onSaveToggle != null)
          Positioned(
            top: MitumbaSpacing.md,
            right: MitumbaSpacing.md,
            child: Semantics(
              button: true,
              label: widget.isSaved ? 'Remove from wishlist' : 'Save to wishlist',
              child: _IconOverlayButton(
                onTap: () => widget.onSaveToggle!(widget.id),
                child: Icon(
                  widget.isSaved ? Icons.favorite : Icons.favorite_border,
                  size: 18,
                  color: widget.isSaved ? MitumbaColors.error : MitumbaColors.textSecondary,
                ),
              ),
            ),
          ),
        // Condition chip
        if (widget.condition != null)
          Positioned(
            bottom: hasMultiple ? MitumbaSpacing.xl : MitumbaSpacing.md,
            left: MitumbaSpacing.md,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: MitumbaColors.white.withAlpha(235),
                borderRadius: BorderRadius.circular(MitumbaRadius.sm),
              ),
              child: Text(
                _conditionLabels[widget.condition]!,
                style: MitumbaTypography.caption.copyWith(
                  fontSize: MitumbaTypography.fontSizeXs,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _mediaItem(String url) {
    if (_isVideoUrl(url)) {
      return _videoPlaceholder(url);
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Shimmer placeholder — visible until image loads
        if (!_imageLoaded)
          AnimatedBuilder(
            animation: _shimmerCtrl,
            builder: (_, __) => Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-1.0 + 2.0 * _shimmerCtrl.value, 0),
                  end: Alignment(-1.0 + 2.0 * _shimmerCtrl.value + 1.0, 0),
                  colors: const [
                    MitumbaColors.background,
                    MitumbaColors.divider,
                    MitumbaColors.background,
                  ],
                ),
              ),
            ),
          ),
        AnimatedOpacity(
          opacity: _imageLoaded ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          child: Image.network(
            url,
            fit: BoxFit.cover,
            frameBuilder: (_, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) {
                _imageLoaded = true;
                return child;
              }
              if (frame != null && !_imageLoaded) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) setState(() => _imageLoaded = true);
                });
              }
              return child;
            },
            errorBuilder: (_, __, ___) => Container(
              color: MitumbaColors.background,
              child: const Icon(Icons.image_not_supported_outlined, color: MitumbaColors.textDisabled),
            ),
          ),
        ),
      ],
    );
  }

  /// Renders a video media placeholder with play icon overlay.
  Widget _videoPlaceholder(String url) {
    return Container(
      color: MitumbaColors.backgroundDark,
      child: Center(
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: MitumbaColors.white.withAlpha(200),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.play_arrow_rounded,
            size: 28,
            color: MitumbaColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(MitumbaSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: MitumbaTypography.body2.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: MitumbaSpacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KES ${_formatPrice(widget.price)}',
                      style: MitumbaTypography.body1.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (widget.originalPrice != null)
                      Padding(
                        padding: EdgeInsets.only(top: MitumbaSpacing.xxs),
                        child: Text(
                          'KES ${_formatPrice(widget.originalPrice!)}',
                          style: MitumbaTypography.caption.copyWith(
                            color: MitumbaColors.textDisabled,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                    if (widget.storeName != null)
                      Padding(
                        padding: EdgeInsets.only(top: MitumbaSpacing.xxs),
                        child: Text(
                          widget.storeName!,
                          style: MitumbaTypography.caption.copyWith(
                            fontSize: MitumbaTypography.fontSizeXs,
                            color: MitumbaColors.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (widget.onAddToCart != null)
                _CartButton(added: _cartAdded, onTap: _handleCart),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPrice(int price) {
    final s = price.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

class _IconOverlayButton extends StatelessWidget {
  const _IconOverlayButton({required this.onTap, required this.child});
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: MitumbaColors.white.withAlpha(235),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

class _CartButton extends StatelessWidget {
  const _CartButton({required this.added, required this.onTap});
  final bool added;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: added ? 'Added to cart' : 'Add to cart',
      child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: const Cubic(0.34, 1.56, 0.64, 1),
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: MitumbaColors.green,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: added
              ? const Icon(Icons.check, key: ValueKey('check'), size: 18, color: MitumbaColors.white)
              : const Icon(Icons.add_shopping_cart, key: ValueKey('cart'), size: 16, color: MitumbaColors.white),
        ),
      ),
      ),
    );
  }
}


/// Skeleton loading placeholder for [ListingCard].
class ListingCardSkeleton extends StatefulWidget {
  const ListingCardSkeleton({super.key});

  @override
  State<ListingCardSkeleton> createState() => _ListingCardSkeletonState();
}

class _ListingCardSkeletonState extends State<ListingCardSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Container(
        decoration: BoxDecoration(
          color: MitumbaColors.surface,
          borderRadius: BorderRadius.circular(MitumbaRadius.lg),
          border: Border.all(color: MitumbaColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              child: _shimmerBox(),
            ),
            Padding(
              padding: EdgeInsets.all(MitumbaSpacing.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _shimmerBox(height: 14, width: double.infinity),
                  SizedBox(height: MitumbaSpacing.sm),
                  _shimmerBox(height: 14, width: 120),
                  SizedBox(height: MitumbaSpacing.md),
                  _shimmerBox(height: 18, width: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox({double? height, double? width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MitumbaRadius.sm),
        gradient: LinearGradient(
          begin: Alignment(-1.0 + 2.0 * _ctrl.value, 0),
          end: Alignment(-1.0 + 2.0 * _ctrl.value + 1.0, 0),
          colors: const [
            MitumbaColors.background,
            MitumbaColors.divider,
            MitumbaColors.background,
          ],
        ),
      ),
    );
  }
}
