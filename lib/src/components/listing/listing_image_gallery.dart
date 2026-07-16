import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/shadows.dart';

/// Premium Listing Image Gallery with interactive swipe transitions and thumbnail selectors.
class ListingImageGallery extends StatefulWidget {
  const ListingImageGallery({
    super.key,
    required this.images,
    required this.title,
  });

  /// Array of image URLs for the listing.
  final List<String> images;

  /// Descriptive title of the listing for accessibility.
  final String title;

  @override
  State<ListingImageGallery> createState() => _ListingImageGalleryState();
}

class _ListingImageGalleryState extends State<ListingImageGallery> {
  int _activeIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _activeIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    if (index < 0 || index >= widget.images.length) return;
    setState(() => _activeIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: MitumbaColors.background,
            borderRadius: BorderRadius.circular(MitumbaRadius.lg),
            border: Border.all(color: MitumbaColors.divider),
          ),
          alignment: Alignment.center,
          child: const Text(
            'No images available',
            style: TextStyle(
              color: MitumbaColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Primary Image (1:1 Aspect Ratio PageView)
        AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            decoration: BoxDecoration(
              color: MitumbaColors.background,
              borderRadius: BorderRadius.circular(MitumbaRadius.lg),
              boxShadow: MitumbaShadows.card,
            ),
            clipBehavior: Clip.antiAlias,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() => _activeIndex = index);
              },
              itemBuilder: (context, index) {
                return Image.network(
                  widget.images[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: MitumbaColors.divider,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.broken_image_outlined,
                        color: MitumbaColors.textSecondary,
                        size: 40,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),

        // Thumbnails Row
        if (widget.images.length > 1) ...[
          const SizedBox(height: MitumbaSpacing.base),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(widget.images.length, (index) {
                final String img = widget.images[index];
                final bool isActive = index == _activeIndex;

                Widget thumb = _ThumbnailItem(
                  imageUrl: img,
                  isActive: isActive,
                  onTap: () => _goTo(index),
                );

                if (index == 0) return thumb;
                return Padding(
                  padding: const EdgeInsets.only(left: 12.0), // gap: 1.5 * 8 = 12
                  child: thumb,
                );
              }),
            ),
          ),
        ],
      ],
    );
  }
}

class _ThumbnailItem extends StatefulWidget {
  const _ThumbnailItem({
    required this.imageUrl,
    required this.isActive,
    required this.onTap,
  });

  final String imageUrl;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_ThumbnailItem> createState() => _ThumbnailItemState();
}

class _ThumbnailItemState extends State<_ThumbnailItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool active = widget.isActive;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(MitumbaRadius.md),
            border: Border.all(
              color: active ? MitumbaColors.green : Colors.transparent,
              width: 2,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered && !active ? -2.0 : 0.0)
            ..scale(active ? 1.05 : 1.0),
          transformAlignment: Alignment.center,
          child: Opacity(
            opacity: active || _isHovered ? 1.0 : 0.6,
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: MitumbaColors.divider,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    size: 16,
                    color: MitumbaColors.textSecondary,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
