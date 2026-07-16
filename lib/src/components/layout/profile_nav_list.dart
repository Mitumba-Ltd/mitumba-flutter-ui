import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../../tokens/shadows.dart';

/// Navigation item model for [ProfileNavList].
class ProfileNavItem {
  const ProfileNavItem({
    required this.label,
    required this.icon,
    this.onClick,
    this.badge,
  });

  /// Display label.
  final String label;

  /// Leading icon.
  final Widget icon;

  /// Called when tapped.
  final VoidCallback? onClick;

  /// Badge count (e.g. unread, pending).
  final int? badge;
}

/// ProfileNavList — navigation list with icons, labels, chevrons, and optional badges.
class ProfileNavList extends StatelessWidget {
  const ProfileNavList({
    super.key,
    required this.items,
  });

  /// Navigation items to display.
  final List<ProfileNavItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MitumbaColors.surface,
        borderRadius: BorderRadius.circular(MitumbaRadius.lg),
        border: Border.all(color: MitumbaColors.divider),
        boxShadow: MitumbaShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final bool isLast = index == items.length - 1;

          return _ProfileNavListItem(
            item: item,
            showDivider: !isLast,
          );
        }),
      ),
    );
  }
}

class _ProfileNavListItem extends StatefulWidget {
  const _ProfileNavListItem({
    required this.item,
    required this.showDivider,
  });

  final ProfileNavItem item;
  final bool showDivider;

  @override
  State<_ProfileNavListItem> createState() => _ProfileNavListItemState();
}

class _ProfileNavListItemState extends State<_ProfileNavListItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    Widget content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: MitumbaSpacing.lg,
        vertical: MitumbaSpacing.base,
      ),
      child: Row(
        children: [
          // Icon
          IconTheme(
            data: const IconThemeData(
              size: 22,
              color: MitumbaColors.textSecondary,
            ),
            child: item.icon,
          ),
          const SizedBox(width: MitumbaSpacing.base),

          // Label
          Expanded(
            child: Text(
              item.label,
              style: const TextStyle(
                fontFamily: MitumbaTypography.fontFamily,
                fontSize: MitumbaTypography.fontSizeBase,
                fontWeight: MitumbaTypography.semibold,
                color: MitumbaColors.textPrimary,
              ),
            ),
          ),

          // Badge
          if (item.badge != null && item.badge! > 0) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: MitumbaColors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              alignment: Alignment.center,
              child: Text(
                '${item.badge}',
                style: const TextStyle(
                  fontFamily: MitumbaTypography.fontFamily,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: MitumbaColors.white,
                ),
              ),
            ),
            const SizedBox(width: MitumbaSpacing.sm),
          ],

          // Chevron
          if (item.onClick != null) ...[
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: MitumbaColors.textDisabled,
            ),
          ],
        ],
      ),
    );

    // Apply divider
    if (widget.showDivider) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          content,
          const Divider(
            height: 1,
            thickness: 1,
            color: MitumbaColors.divider,
            indent: 0,
            endIndent: 0,
          ),
        ],
      );
    }

    if (item.onClick == null) {
      return content;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: item.onClick,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          color: _isHovered ? MitumbaColors.background : MitumbaColors.transparent,
          child: content,
        ),
      ),
    );
  }
}
