import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';

/// Item model for [MitumbaBreadcrumb].
class MitumbaBreadcrumbItem {
  const MitumbaBreadcrumbItem({
    required this.label,
    this.onTap,
  });

  /// The text label to display.
  final String label;

  /// Called when the item is tapped.
  final VoidCallback? onTap;
}

/// A premium, living Breadcrumb widget for hierarchy visualization.
class MitumbaBreadcrumb extends StatelessWidget {
  const MitumbaBreadcrumb({
    super.key,
    required this.items,
  });

  /// The breadcrumb trail items.
  final List<MitumbaBreadcrumbItem> items;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final bool isLast = index == items.length - 1;

          // Render item
          final Widget itemWidget;
          if (isLast || item.onTap == null) {
            itemWidget = Text(
              item.label,
              style: TextStyle(
                fontFamily: MitumbaTypography.fontFamily,
                fontSize: MitumbaTypography.fontSizeSm,
                fontWeight: isLast ? MitumbaTypography.extrabold : MitumbaTypography.semibold,
                color: isLast ? MitumbaColors.textPrimary : MitumbaColors.textSecondary,
              ),
            );
          } else {
            itemWidget = _MitumbaBreadcrumbLink(
              item: item,
            );
          }

          if (isLast) {
            return itemWidget;
          }

          // Separator
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              itemWidget,
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.0),
                child: Text(
                  '/',
                  style: TextStyle(
                    fontFamily: MitumbaTypography.fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: MitumbaColors.divider,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _MitumbaBreadcrumbLink extends StatefulWidget {
  const _MitumbaBreadcrumbLink({
    required this.item,
  });

  final MitumbaBreadcrumbItem item;

  @override
  State<_MitumbaBreadcrumbLink> createState() => _MitumbaBreadcrumbLinkState();
}

class _MitumbaBreadcrumbLinkState extends State<_MitumbaBreadcrumbLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.item.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: TextStyle(
            fontFamily: MitumbaTypography.fontFamily,
            fontSize: MitumbaTypography.fontSizeSm,
            fontWeight: MitumbaTypography.semibold,
            color: _isHovered ? MitumbaColors.green : MitumbaColors.textSecondary,
          ),
          child: Text(widget.item.label),
        ),
      ),
    );
  }
}
