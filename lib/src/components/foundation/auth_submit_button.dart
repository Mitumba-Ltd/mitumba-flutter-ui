import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';

/// Submit button for auth forms. Handles validation-aware disabling,
/// loading states, and premium micro-animations (translate/scale on hover/press).
class AuthSubmitButton extends StatefulWidget {
  const AuthSubmitButton({
    super.key,
    required this.label,
    this.loading = false,
    this.disabled = false,
    this.fullWidth = false,
    required this.onClick,
  });

  final String label;
  final bool loading;
  final bool disabled;
  final bool fullWidth;
  final VoidCallback onClick;

  @override
  State<AuthSubmitButton> createState() => _AuthSubmitButtonState();
}

class _AuthSubmitButtonState extends State<AuthSubmitButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isInactive = widget.disabled || widget.loading;

    double scale = 1.0;
    double translationY = 0.0;

    if (!isInactive) {
      if (_isPressed) {
        scale = 0.98;
      } else if (_isHovered) {
        scale = 1.02;
        translationY = -2.0;
      }
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: isInactive ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: isInactive ? null : (_) => setState(() => _isPressed = true),
        onTapUp: isInactive ? null : (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: isInactive ? null : widget.onClick,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          transform: Matrix4.identity()
            ..translate(0.0, translationY)
            ..scale(scale),
          alignment: Alignment.center,
          width: widget.fullWidth ? double.infinity : null,
          height: 42.0,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: isInactive ? MitumbaColors.green.withOpacity(0.5) : MitumbaColors.green,
            borderRadius: BorderRadius.circular(MitumbaRadius.md),
          ),
          child: widget.loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  widget.label,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
