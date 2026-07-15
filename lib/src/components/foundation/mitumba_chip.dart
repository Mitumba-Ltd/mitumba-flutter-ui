import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/typography.dart';

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
    // Basic chip setup — to be refined in subsequent commits
    final isClickable = (widget.onClick != null || widget.onDelete != null) && !widget.disabled;
    final height = widget.size == 'small' ? 22.0 : 28.0;

    double radiusValue = MitumbaRadius.md;
    if (widget.rounding == MitumbaChipRounding.pill) {
      radiusValue = MitumbaRadius.full;
    } else if (widget.rounding == MitumbaChipRounding.square) {
      radiusValue = MitumbaRadius.xs;
    }

    return AnimatedScale(
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
            borderRadius: BorderRadius.circular(radiusValue),
            border: Border.all(color: MitumbaColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
