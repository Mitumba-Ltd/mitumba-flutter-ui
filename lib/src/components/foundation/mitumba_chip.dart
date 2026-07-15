import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';

enum MitumbaChipVariant { solid, outline, soft, ghost }
enum MitumbaChipRounding { rounded, pill, square }
enum MitumbaChipStatus { defaultStatus, active, incomplete, danger, success, common, special }

/// A premium, living Chip primitive with systematic status-aware styling and tactile feedback.
class MitumbaChip extends StatefulWidget {
  const MitumbaChip({
    super.key,
    required this.label,
    this.onClick,
    this.onDelete,
    this.selected = false,
    this.disabled = false,
    this.icon,
    this.avatar,
    this.badge,
    this.variant = MitumbaChipVariant.outline,
    this.status = MitumbaChipStatus.defaultStatus,
    this.rounding = MitumbaChipRounding.rounded,
    this.size = 'medium',
    this.color,
  });

  /// Text label displayed inside the chip.
  final String label;

  /// Called when the chip is clicked.
  final VoidCallback? onClick;

  /// Called when the delete icon is clicked.
  final VoidCallback? onDelete;

  /// Whether the chip is in a selected/active state.
  final bool selected;

  /// Prevents user interaction.
  final bool disabled;

  /// Leading icon.
  final Widget? icon;

  /// Custom avatar element.
  final Widget? avatar;

  /// Numeric or text badge appended to the end.
  final dynamic badge;

  /// Visual treatment: solid, outline, soft, ghost.
  final MitumbaChipVariant variant;

  /// Category archetype for auto-styling.
  final MitumbaChipStatus status;

  /// Corner geometry: rounded, pill, square.
  final MitumbaChipRounding rounding;

  /// Size standard: 'small' (height 22) or 'medium' (height 28).
  final String size;

  /// Base color theme.
  final Color? color;

  @override
  State<MitumbaChip> createState() => _MitumbaChipState();
}

class _MitumbaChipState extends State<MitumbaChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final _StatusConfig statusConfig;
    switch (widget.status) {
      case MitumbaChipStatus.defaultStatus:
        statusConfig = const _StatusConfig(
          color: MitumbaColors.textSecondary,
          bgColor: MitumbaColors.transparent,
          borderColor: MitumbaColors.divider,
        );
        break;
      case MitumbaChipStatus.active:
        statusConfig = const _StatusConfig(
          color: MitumbaColors.info,
          bgColor: Color(0x1A2E86C1),
          borderColor: MitumbaColors.info,
          icon: Icon(Icons.circle, size: 6, color: MitumbaColors.info),
        );
        break;
      case MitumbaChipStatus.incomplete:
        statusConfig = const _StatusConfig(
          color: MitumbaColors.warning,
          bgColor: Color(0x1AE67E22),
          borderColor: MitumbaColors.warning,
        );
        break;
      case MitumbaChipStatus.danger:
        statusConfig = const _StatusConfig(
          color: MitumbaColors.error,
          bgColor: Color(0x1AD93025),
          borderColor: MitumbaColors.error,
        );
        break;
      case MitumbaChipStatus.success:
        statusConfig = const _StatusConfig(
          color: MitumbaColors.green,
          bgColor: Color(0x1A3D9A52),
          borderColor: MitumbaColors.green,
        );
        break;
      case MitumbaChipStatus.common:
        statusConfig = const _StatusConfig(
          color: MitumbaColors.textPrimary,
          bgColor: MitumbaColors.transparent,
          borderColor: MitumbaColors.divider,
        );
        break;
      case MitumbaChipStatus.special:
        statusConfig = const _StatusConfig(
          color: MitumbaColors.white,
          bgColor: MitumbaColors.earth,
          borderColor: MitumbaColors.transparent,
        );
        break;
    }

    final activeColor = widget.color ?? statusConfig.color;
    final isClickable = (widget.onClick != null || widget.onDelete != null) && !widget.disabled;
    final height = widget.size == 'small' ? 22.0 : 28.0;

    double radiusValue = MitumbaRadius.md;
    if (widget.rounding == MitumbaChipRounding.pill) {
      radiusValue = MitumbaRadius.full;
    } else if (widget.rounding == MitumbaChipRounding.square) {
      radiusValue = MitumbaRadius.xs;
    }

    Color activeBg = MitumbaColors.transparent;
    if (widget.variant == MitumbaChipVariant.solid || widget.selected) {
      activeBg = activeColor;
    } else if (widget.variant == MitumbaChipVariant.soft) {
      activeBg = activeColor.withOpacity(0.15);
    } else {
      activeBg = statusConfig.bgColor;
    }

    Color borderCol = MitumbaColors.transparent;
    if (widget.variant == MitumbaChipVariant.outline && !widget.selected) {
      borderCol = widget.color ?? statusConfig.borderColor;
    }

    final activeTextColor = (widget.variant == MitumbaChipVariant.solid || widget.selected)
        ? MitumbaColors.white
        : activeColor;

    final List<Widget> rowChildren = [];

    // 1. Icon or Avatar
    final leadingIcon = widget.icon ?? statusConfig.icon;
    if (widget.avatar != null) {
      rowChildren.add(widget.avatar!);
      rowChildren.add(const SizedBox(width: 6));
    } else if (leadingIcon != null) {
      rowChildren.add(IconTheme(
        data: IconThemeData(size: widget.size == 'small' ? 12 : 14, color: activeTextColor),
        child: leadingIcon,
      ));
      rowChildren.add(const SizedBox(width: 6));
    }

    // 2. Label
    rowChildren.add(
      Text(
        widget.label.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: widget.size == 'small' ? 9.0 : 10.0,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
          color: activeTextColor,
        ),
      ),
    );

    // 3. Badge
    if (widget.badge != null) {
      rowChildren.add(const SizedBox(width: 4));
      rowChildren.add(
        Text(
          '${widget.badge}',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 9.0,
            fontWeight: FontWeight.w900,
            color: activeTextColor.withOpacity(0.8),
          ),
        ),
      );
    }

    // 4. Delete Icon
    if (widget.onDelete != null) {
      rowChildren.add(const SizedBox(width: 6));
      rowChildren.add(
        GestureDetector(
          onTap: widget.disabled ? null : widget.onDelete,
          child: Opacity(
            opacity: 0.7,
            child: Icon(
              Icons.close,
              size: widget.size == 'small' ? 12.0 : 14.0,
              color: activeTextColor,
            ),
          ),
        ),
      );
    }

    return Opacity(
      opacity: widget.disabled ? 0.5 : 1.0,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: GestureDetector(
          onTapDown: isClickable ? (_) => setState(() => _isPressed = true) : null,
          onTapUp: isClickable ? (_) => setState(() => _isPressed = false) : null,
          onTapCancel: isClickable ? () => setState(() => _isPressed = false) : null,
          onTap: isClickable ? widget.onClick : null,
          child: Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: activeBg,
              borderRadius: BorderRadius.circular(radiusValue),
              border: borderCol != MitumbaColors.transparent
                  ? Border.all(color: borderCol, width: 1.5)
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: rowChildren,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusConfig {
  const _StatusConfig({
    required this.color,
    required this.bgColor,
    required this.borderColor,
    this.icon,
  });

  final Color color;
  final Color bgColor;
  final Color borderColor;
  final Widget? icon;
}
