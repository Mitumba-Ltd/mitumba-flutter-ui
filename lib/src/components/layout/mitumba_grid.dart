import 'package:flutter/material.dart';
import '../../tokens/spacing.dart';

/// Column configurations per breakpoint for [MitumbaGrid].
class MitumbaGridColumns {
  const MitumbaGridColumns({
    this.xs = 4,
    this.sm = 8,
    this.md = 8,
    this.lg = 12,
  });

  final int xs;
  final int sm;
  final int md;
  final int lg;
}

/// A responsive grid system matching Web CSS Grid properties.
class MitumbaGrid extends StatelessWidget {
  const MitumbaGrid({
    super.key,
    required this.children,
    this.columns = const MitumbaGridColumns(),
    this.gap,
  });

  /// The list of widgets to lay out.
  final List<Widget> children;

  /// Number of columns per breakpoint.
  final MitumbaGridColumns columns;

  /// Custom spacing gap between cells.
  final double? gap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        // Determine column count and gap based on breakpoints
        int colCount = columns.xs;
        double spacingGap = MitumbaSpacing.base; // 12.0

        if (width < 600) {
          colCount = columns.xs;
          spacingGap = gap ?? MitumbaSpacing.base;
        } else if (width < 900) {
          colCount = columns.sm;
          spacingGap = gap ?? MitumbaSpacing.base;
        } else if (width < 1200) {
          colCount = columns.md;
          spacingGap = gap ?? MitumbaSpacing.lg; // 16.0
        } else {
          colCount = columns.lg;
          spacingGap = gap ?? MitumbaSpacing.lg; // 16.0
        }

        // Calculate item width based on available constraints
        final double totalGapWidth = (colCount - 1) * spacingGap;
        final double itemWidth = (width - totalGapWidth) / colCount;

        return Wrap(
          spacing: spacingGap,
          runSpacing: spacingGap,
          children: children.map((child) {
            return SizedBox(
              width: itemWidth,
              child: child,
            );
          }).toList(),
        );
      },
    );
  }
}
