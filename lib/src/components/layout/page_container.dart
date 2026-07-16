import 'package:flutter/material.dart';
import '../../tokens/spacing.dart';

/// Maximum width constraint types for [PageContainer].
enum PageContainerMaxWidth {
  sm,
  md,
  lg,
  xl,
}

/// A responsive page content wrapper that centers content and controls page layout width and side gutters.
class PageContainer extends StatelessWidget {
  const PageContainer({
    super.key,
    required this.child,
    this.maxWidth = PageContainerMaxWidth.lg,
    this.noPadding = false,
  });

  /// Content rendered inside the container.
  final Widget child;

  /// Maximum width constraint. Defaults to [PageContainerMaxWidth.lg].
  final PageContainerMaxWidth maxWidth;

  /// If true, removes horizontal padding.
  final bool noPadding;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    // Responsive padding based on viewport size (matching tokens.spacing)
    double horizontalPadding = 0.0;
    if (!noPadding) {
      if (screenWidth < 600) {
        horizontalPadding = MitumbaSpacing.base; // 12.0
      } else if (screenWidth < 1200) {
        horizontalPadding = MitumbaSpacing.lg; // 16.0
      } else {
        horizontalPadding = MitumbaSpacing.xl; // 20.0
      }
    }

    // Max width values
    double maxWidthVal = 1280.0;
    switch (maxWidth) {
      case PageContainerMaxWidth.sm:
        maxWidthVal = 640.0;
        break;
      case PageContainerMaxWidth.md:
        maxWidthVal = 900.0;
        break;
      case PageContainerMaxWidth.lg:
        maxWidthVal = 1280.0;
        break;
      case PageContainerMaxWidth.xl:
        maxWidthVal = 1536.0;
        break;
    }

    return Center(
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: maxWidthVal,
        ),
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: child,
      ),
    );
  }
}
