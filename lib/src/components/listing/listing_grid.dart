import 'package:flutter/material.dart';

import '../../tokens/spacing.dart';

/// Responsive column configuration for [ListingGrid].
class ListingGridColumns {
  /// Creates a responsive column config.
  const ListingGridColumns({
    this.xs = 2,
    this.sm = 2,
    this.md = 3,
    this.lg = 4,
  });

  /// Columns at < 600px.
  final int xs;

  /// Columns at 600–899px.
  final int sm;

  /// Columns at 900–1199px.
  final int md;

  /// Columns at >= 1200px.
  final int lg;

  /// Returns the column count for the given width.
  int forWidth(double width) {
    if (width >= 1200) return lg;
    if (width >= 900) return md;
    if (width >= 600) return sm;
    return xs;
  }
}

/// Responsive grid specifically tuned for listing cards.
///
/// Mirrors the web `ListingGrid` from `@mitumba/ui`.
///
/// ```dart
/// ListingGrid(
///   children: listings.map((l) => ListingCard(...)).toList(),
/// )
/// ```
class ListingGrid extends StatelessWidget {
  /// Creates a listing grid.
  const ListingGrid({
    super.key,
    required this.children,
    this.columns = const ListingGridColumns(),
    this.gap,
    this.isLoading = false,
    this.skeletonCount = 8,
    this.skeletonBuilder,
  });

  /// Grid cells — typically ListingCard widgets.
  final List<Widget> children;

  /// Responsive column configuration.
  final ListingGridColumns columns;

  /// Gap between grid cells. Defaults to [MitumbaSpacing.lg].
  final double? gap;

  /// Whether the grid is in a loading state.
  final bool isLoading;

  /// Number of skeleton placeholders to show when loading.
  final int skeletonCount;

  /// Custom skeleton builder. If null, uses a default shimmer box.
  final Widget Function(BuildContext context, int index)? skeletonBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final colCount = columns.forWidth(constraints.maxWidth);
      final spacing = gap ?? MitumbaSpacing.lg;

      final items = isLoading
          ? List.generate(skeletonCount, (i) =>
              skeletonBuilder?.call(context, i) ?? const _DefaultSkeleton())
          : children;

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: items.map((child) {
          final itemWidth = (constraints.maxWidth - (colCount - 1) * spacing) / colCount;
          return SizedBox(
            width: itemWidth,
            child: child,
          );
        }).toList(),
      );
    });
  }
}

class _DefaultSkeleton extends StatelessWidget {
  const _DefaultSkeleton();

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 3 / 4,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xFFF0F0ED),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}
