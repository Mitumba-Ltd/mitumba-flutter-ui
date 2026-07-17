import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

enum UploadedImageStatus { uploading, done, error }

/// Represents an uploaded image in the uploader.
class UploadedImage {
  const UploadedImage({
    required this.id,
    required this.url,
    required this.status,
    required this.isPrimary,
  });

  /// Unique identifier.
  final String id;

  /// Preview URL (local file path or network URL).
  final String url;

  /// Upload status.
  final UploadedImageStatus status;

  /// Whether this is the cover/primary photo (first slot).
  final bool isPrimary;
}

enum ImageUploaderVariant { grid, single }

/// Image uploader — Depop/Vinted-style grid with cover photo emphasis.
/// Supports drag-to-reorder, tap-to-add, and single/grid variants.
class MitumbaImageUploader extends StatelessWidget {
  const MitumbaImageUploader({
    super.key,
    required this.images,
    this.onAddTap,
    this.onRemove,
    this.onReorder,
    this.maxImages = 6,
    this.variant = ImageUploaderVariant.grid,
    this.aspectRatio = 1.0,
    this.hint = 'Add photo',
  });

  /// Current images.
  final List<UploadedImage> images;

  /// Called when user taps the empty slot to add photos.
  final VoidCallback? onAddTap;

  /// Called when an image is removed.
  final ValueChanged<String>? onRemove;

  /// Called when images are reordered (returns new ID list).
  final ValueChanged<List<String>>? onReorder;

  /// Max images allowed — defaults to 6.
  final int maxImages;

  /// Layout variant — grid for listings (default), single for profile/logo.
  final ImageUploaderVariant variant;

  /// Aspect ratio for image slots — defaults to 1.0 (square).
  final double aspectRatio;

  /// Hint text shown on empty slots.
  final String hint;

  @override
  Widget build(BuildContext context) {
    final canAdd = images.length < maxImages;
    final isSingle = variant == ImageUploaderVariant.single;

    if (isSingle) {
      return _buildSingle(context);
    }

    return _buildGrid(context, canAdd);
  }

  Widget _buildSingle(BuildContext context) {
    final hasImg = images.isNotEmpty;
    final img = hasImg ? images.first : null;

    Widget content;
    if (img != null) {
      content = Stack(
        fit: StackFit.expand,
        children: [
          // Image
          Image.network(
            img.url,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: MitumbaColors.background,
              alignment: Alignment.center,
              child: const Icon(
                Icons.broken_image_outlined,
                size: 24,
                color: MitumbaColors.textDisabled,
              ),
            ),
          ),
          // Loading spinner overlay
          if (img.status == UploadedImageStatus.uploading)
            Container(
              color: Colors.white70,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(MitumbaColors.green),
              ),
            ),
          // Error overlay
          if (img.status == UploadedImageStatus.error)
            Container(
              color: MitumbaColors.error.withOpacity(0.1),
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: MitumbaColors.error,
                  borderRadius: BorderRadius.circular(MitumbaRadius.sm),
                ),
                child: const Text(
                  'FAILED',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          // Remove button
          Positioned(
            top: MitumbaSpacing.sm,
            right: MitumbaSpacing.sm,
            child: GestureDetector(
              onTap: () => onRemove?.call(img.id),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      content = InkWell(
        onTap: onAddTap,
        borderRadius: BorderRadius.circular(MitumbaRadius.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_a_photo_outlined,
              color: MitumbaColors.textDisabled,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              hint,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: MitumbaColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: MitumbaColors.background,
          borderRadius: BorderRadius.circular(MitumbaRadius.lg),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(MitumbaRadius.lg),
          child: CustomPaint(
            painter: !hasImg
                ? DashedBorderPainter(
                    color: MitumbaColors.divider,
                    radius: MitumbaRadius.lg,
                  )
                : null,
            child: Container(
              decoration: hasImg
                  ? BoxDecoration(
                      border: Border.all(
                        color: img?.status == UploadedImageStatus.error
                            ? MitumbaColors.error
                            : MitumbaColors.green,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(MitumbaRadius.lg),
                    )
                  : null,
              child: content,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, bool canAdd) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: MitumbaSpacing.sm,
            mainAxisSpacing: MitumbaSpacing.sm,
            childAspectRatio: aspectRatio,
          ),
          itemCount: maxImages,
          itemBuilder: (context, index) {
            final hasImg = index < images.length;
            final img = hasImg ? images[index] : null;

            Widget slotContent;
            if (img != null) {
              slotContent = DragTarget<int>(
                onWillAccept: (fromIndex) => fromIndex != null,
                onAccept: (fromIndex) {
                  if (fromIndex != index) {
                    final reordered = [...images.map((img) => img.id)];
                    final moved = reordered.removeAt(fromIndex);
                    reordered.insert(index, moved);
                    onReorder?.call(reordered);
                  }
                },
                builder: (context, candidateData, rejectedData) {
                  return LongPressDraggable<int>(
                    data: index,
                    feedback: SizedBox(
                      width: 100,
                      height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(MitumbaRadius.md),
                        child: Material(
                          elevation: 8,
                          child: Image.network(img.url, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: MitumbaColors.background,
                          borderRadius: BorderRadius.circular(MitumbaRadius.md),
                        ),
                      ),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Image
                        Image.network(
                          img.url,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: MitumbaColors.background,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.broken_image_outlined,
                              size: 20,
                              color: MitumbaColors.textDisabled,
                            ),
                          ),
                        ),

                        // Cover badge
                        if (index == 0)
                          Positioned(
                            top: 4,
                            left: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: MitumbaColors.green,
                                borderRadius: BorderRadius.circular(MitumbaRadius.sm),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.star, size: 8, color: Colors.white),
                                  SizedBox(width: 2),
                                  Text(
                                    'COVER',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 8,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // Upload progress
                        if (img.status == UploadedImageStatus.uploading)
                          Container(
                            color: Colors.white70,
                            alignment: Alignment.center,
                            child: const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(MitumbaColors.green),
                              ),
                            ),
                          ),

                        // Error overlay
                        if (img.status == UploadedImageStatus.error)
                          Container(
                            color: MitumbaColors.error.withOpacity(0.2),
                            alignment: Alignment.center,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: MitumbaColors.error,
                                borderRadius: BorderRadius.circular(MitumbaRadius.sm),
                              ),
                              child: const Text(
                                'FAILED',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                        // Remove button
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => onRemove?.call(img.id),
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              slotContent = InkWell(
                onTap: canAdd ? onAddTap : null,
                borderRadius: BorderRadius.circular(MitumbaRadius.md),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo_outlined,
                      color: canAdd ? MitumbaColors.textDisabled : MitumbaColors.divider,
                      size: 20,
                    ),
                    if (index == 0) ...[
                      const SizedBox(height: 2),
                      Text(
                        'COVER',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 8,
                          color: canAdd ? MitumbaColors.textSecondary : MitumbaColors.divider,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }

            final isCoverBorder = index == 0 && hasImg;

            return Container(
              decoration: BoxDecoration(
                color: MitumbaColors.background,
                borderRadius: BorderRadius.circular(MitumbaRadius.md),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(MitumbaRadius.md),
                child: CustomPaint(
                  painter: !hasImg
                      ? DashedBorderPainter(
                          color: MitumbaColors.divider,
                          radius: MitumbaRadius.md,
                        )
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                      border: hasImg
                          ? Border.all(
                              color: isCoverBorder
                                  ? MitumbaColors.green
                                  : MitumbaColors.divider,
                              width: isCoverBorder ? 2.0 : 1.0,
                            )
                          : null,
                      borderRadius: BorderRadius.circular(MitumbaRadius.md),
                    ),
                    child: slotContent,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Text(
          '${images.length}/$maxImages photos · Long press & drag to reorder · First photo is the cover',
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: MitumbaColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  DashedBorderPainter({
    required this.color,
    required this.radius,
    this.strokeWidth = 1.0,
    this.gap = 4.0,
    this.dash = 4.0,
  });

  final Color color;
  final double radius;
  final double strokeWidth;
  final double gap;
  final double dash;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ));

    final dashPath = Path();
    double distance = 0.0;
    for (final metric in path.computeMetrics()) {
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + dash),
          Offset.zero,
        );
        distance += dash + gap;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
