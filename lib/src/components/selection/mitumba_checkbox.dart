import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Premium custom Checkbox widget matching Web Mitumba design tokens.
class MitumbaCheckbox extends StatefulWidget {
  const MitumbaCheckbox({
    super.key,
    required this.checked,
    this.onChange,
    this.label,
    this.disabled = false,
    this.indeterminate = false,
  });

  /// Is the checkbox currently checked.
  final bool checked;

  /// Triggered when the checked state changes.
  final ValueChanged<bool>? onChange;

  /// Optional text label positioned beside the checkbox.
  final String? label;

  /// Prevents user interaction and shifts styling to disabled mode.
  final bool disabled;

  /// Displays an indeterminate minus state instead of checkmark.
  final bool indeterminate;

  @override
  State<MitumbaCheckbox> createState() => _MitumbaCheckboxState();
}

class _MitumbaCheckboxState extends State<MitumbaCheckbox> {
  bool _isHovered = false;
  bool _isPressed = false;

  void _handleTap() {
    if (widget.disabled || widget.onChange == null) return;
    widget.onChange!(!widget.checked);
  }

  @override
  Widget build(BuildContext context) {
    // Select visual color representation
    Color boxColor = MitumbaColors.border;
    IconData? checkIcon;

    if (widget.disabled) {
      boxColor = MitumbaColors.divider;
    } else if (widget.checked || widget.indeterminate) {
      boxColor = MitumbaColors.green;
    } else if (_isHovered) {
      boxColor = MitumbaColors.textDisabled;
    }

    if (widget.indeterminate) {
      checkIcon = Icons.remove;
    } else if (widget.checked) {
      checkIcon = Icons.check;
    }

    // Bounce interaction transformations
    double currentScale = 1.0;
    if (widget.disabled) {
      currentScale = 1.0;
    } else if (_isPressed) {
      currentScale = 0.9;
    } else if (_isHovered) {
      currentScale = 1.1;
    }

    final checkboxNode = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          width: 24,
          height: 24,
          transform: Matrix4.identity()..scale(currentScale),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: (widget.checked || widget.indeterminate) && !widget.disabled
                ? MitumbaColors.green
                : Colors.transparent,
            borderRadius: BorderRadius.circular(MitumbaRadius.xs),
            border: Border.all(
              color: boxColor,
              width: 2.0,
            ),
          ),
          alignment: Alignment.center,
          child: checkIcon != null
              ? Icon(
                  checkIcon,
                  size: 16,
                  color: widget.disabled ? MitumbaColors.textDisabled : MitumbaColors.white,
                )
              : null,
        ),
      ),
    );

    if (widget.label == null) {
      return Opacity(
        opacity: widget.disabled ? 0.5 : 1.0,
        child: checkboxNode,
      );
    }

    return Opacity(
      opacity: widget.disabled ? 0.5 : 1.0,
      child: GestureDetector(
        onTap: _handleTap,
        child: MouseRegion(
          cursor: widget.disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              checkboxNode,
              const SizedBox(width: MitumbaSpacing.sm),
              Text(
                widget.label!,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: MitumbaTypography.fontSizeBase,
                  fontWeight: FontWeight.w600,
                  color: widget.disabled
                      ? MitumbaColors.textDisabled
                      : MitumbaColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
