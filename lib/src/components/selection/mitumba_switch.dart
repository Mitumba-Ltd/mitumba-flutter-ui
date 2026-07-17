import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/shadows.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Premium custom Switch / Toggle widget matching Web Mitumba design tokens.
class MitumbaSwitch extends StatefulWidget {
  const MitumbaSwitch({
    super.key,
    required this.on,
    this.onChange,
    this.label,
    this.disabled = false,
  });

  /// Is the switch active (on).
  final bool on;

  /// Triggered when the switch toggles on/off.
  final ValueChanged<bool>? onChange;

  /// Optional descriptive label.
  final String? label;

  /// Prevents interaction.
  final bool disabled;

  @override
  State<MitumbaSwitch> createState() => _MitumbaSwitchState();
}

class _MitumbaSwitchState extends State<MitumbaSwitch> {
  bool _isHovered = false;
  bool _isPressed = false;

  void _handleTap() {
    if (widget.disabled || widget.onChange == null) return;
    widget.onChange!(!widget.on);
  }

  @override
  Widget build(BuildContext context) {
    Color trackColor = MitumbaColors.divider;

    if (widget.disabled) {
      trackColor = MitumbaColors.divider.withValues(alpha: 0.5);
    } else if (widget.on) {
      trackColor = MitumbaColors.green;
    } else if (_isHovered) {
      trackColor = MitumbaColors.textDisabled;
    }

    final double thumbDiameter = _isPressed ? 24.0 : 20.0;
    final double offsetLeft = widget.on ? (44.0 - thumbDiameter - 2.0) : 2.0;

    final switchNode = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 44,
          height: 24,
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(24.0 / 2.0),
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: const Cubic(0.34, 1.56, 0.64, 1.0), // Bounce curve
                left: offsetLeft,
                child: Container(
                  width: thumbDiameter,
                  height: 20,
                  decoration: BoxDecoration(
                    color: MitumbaColors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: MitumbaShadows.card,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (widget.label == null) {
      return Opacity(
        opacity: widget.disabled ? 0.5 : 1.0,
        child: switchNode,
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
              switchNode,
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
