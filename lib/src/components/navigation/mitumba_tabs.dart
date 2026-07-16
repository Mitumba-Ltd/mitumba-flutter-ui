import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../../tokens/shadows.dart';

/// Variant style for [MitumbaTabs].
enum MitumbaTabsVariant {
  primary,
  secondary,
}

/// Tab item configuration for [MitumbaTabs].
class MitumbaTabOption {
  const MitumbaTabOption({
    required this.label,
    required this.value,
    this.icon,
    this.disabled = false,
  });

  /// Display label for the tab.
  final String label;

  /// Technical value for the tab.
  final dynamic value;

  /// Optional leading icon.
  final Widget? icon;

  /// Whether the tab is disabled.
  final bool disabled;
}

/// A premium, living Tabs widget with tactile transitions and solid/underline variants.
class MitumbaTabs extends StatelessWidget {
  const MitumbaTabs({
    super.key,
    required this.value,
    required this.onChange,
    required this.tabs,
    this.variant = MitumbaTabsVariant.primary,
  });

  /// The value of the currently selected tab.
  final dynamic value;

  /// Callback fired when the value changes.
  final ValueChanged<dynamic> onChange;

  /// Array of tab configurations.
  final List<MitumbaTabOption> tabs;

  /// Visual variant. Defaults to [MitumbaTabsVariant.primary].
  final MitumbaTabsVariant variant;

  @override
  Widget build(BuildContext context) {
    final bool isPrimary = variant == MitumbaTabsVariant.primary;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(tabs.length, (index) {
          final tab = tabs[index];
          final bool isSelected = tab.value == value;

          Widget tabWidget = _MitumbaTabItem(
            tab: tab,
            isSelected: isSelected,
            variant: variant,
            onTap: tab.disabled ? null : () => onChange(tab.value),
          );

          if (index == 0) return tabWidget;

          // Gap spacing
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: isPrimary ? MitumbaSpacing.md : MitumbaSpacing.xxxl), // gap 1 (8px) vs gap 4 (32px)
              tabWidget,
            ],
          );
        }),
      ),
    );
  }
}

class _MitumbaTabItem extends StatefulWidget {
  const _MitumbaTabItem({
    required this.tab,
    required this.isSelected,
    required this.variant,
    this.onTap,
  });

  final MitumbaTabOption tab;
  final bool isSelected;
  final MitumbaTabsVariant variant;
  final VoidCallback? onTap;

  @override
  State<_MitumbaTabItem> createState() => _MitumbaTabItemState();
}

class _MitumbaTabItemState extends State<_MitumbaTabItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final tab = widget.tab;
    final bool selected = widget.isSelected;
    final bool isPrimary = widget.variant == MitumbaTabsVariant.primary;

    // Sizing/Padding
    final double horizPadding = isPrimary ? 24.0 : 8.0;

    // Text Style
    Color getTextColor() {
      if (tab.disabled) return MitumbaColors.textDisabled.withValues(alpha: 0.4);
      if (isPrimary) {
        return selected ? MitumbaColors.white : (_isHovered ? MitumbaColors.textPrimary : MitumbaColors.textSecondary);
      } else {
        return selected ? MitumbaColors.green : (_isHovered ? MitumbaColors.textPrimary : MitumbaColors.textSecondary);
      }
    }

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (tab.icon != null) ...[
          IconTheme(
            data: IconThemeData(
              size: 20,
              color: getTextColor(),
            ),
            child: tab.icon!,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          tab.label,
          style: TextStyle(
            fontFamily: MitumbaTypography.fontFamily,
            fontSize: MitumbaTypography.fontSizeBase,
            fontWeight: FontWeight.bold,
            color: getTextColor(),
          ),
        ),
      ],
    );

    Widget itemWidget;

    if (isPrimary) {
      itemWidget = AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: horizPadding, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? MitumbaColors.green : MitumbaColors.transparent,
          borderRadius: BorderRadius.circular(MitumbaRadius.md),
          boxShadow: selected ? MitumbaShadows.card : null,
        ),
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered && !selected ? -1.0 : 0.0),
        transformAlignment: Alignment.center,
        child: content,
      );
    } else {
      itemWidget = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizPadding, vertical: 10),
            child: content,
          ),
          // Underline Indicator
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: 48, // matching text width approx
            decoration: BoxDecoration(
              color: selected ? MitumbaColors.green : MitumbaColors.transparent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(3),
                topRight: Radius.circular(3),
              ),
            ),
          ),
        ],
      );
    }

    if (tab.disabled) {
      return Opacity(
        opacity: 0.4,
        child: itemWidget,
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: itemWidget,
      ),
    );
  }
}
