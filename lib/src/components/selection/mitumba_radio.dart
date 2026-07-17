import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Premium custom Radio widget matching Web Mitumba design tokens.
class MitumbaRadio extends StatefulWidget {
  const MitumbaRadio({
    super.key,
    required this.selected,
    required this.value,
    this.label,
    this.onChange,
    this.disabled = false,
  });

  /// Is this radio item currently selected.
  final bool selected;

  /// Underlying raw value represented by this radio button.
  final dynamic value;

  /// Optional label text.
  final String? label;

  /// Triggered when the radio button is selected.
  final ValueChanged<dynamic>? onChange;

  /// Disables user interaction.
  final bool disabled;

  @override
  State<MitumbaRadio> createState() => _MitumbaRadioState();
}

class _MitumbaRadioState extends State<MitumbaRadio> {
  bool _isHovered = false;
  bool _isPressed = false;

  void _handleTap() {
    if (widget.disabled || widget.onChange == null) return;
    widget.onChange!(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    Color boxColor = MitumbaColors.border;

    if (widget.disabled) {
      boxColor = MitumbaColors.divider;
    } else if (widget.selected) {
      boxColor = MitumbaColors.green;
    } else if (_isHovered) {
      boxColor = MitumbaColors.textDisabled;
    }

    // Interaction scales
    double currentScale = 1.0;
    if (widget.disabled) {
      currentScale = 1.0;
    } else if (_isPressed) {
      currentScale = 0.9;
    } else if (_isHovered) {
      currentScale = 1.1;
    }

    final radioNode = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          width: 24,
          height: 24,
          transform: Matrix4.identity()..scale(currentScale),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: boxColor,
              width: 2.0,
            ),
          ),
          alignment: Alignment.center,
          child: AnimatedScale(
            scale: widget.selected ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: MitumbaColors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.label == null) {
      return Opacity(
        opacity: widget.disabled ? 0.5 : 1.0,
        child: radioNode,
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
              radioNode,
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
