import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// 6-digit OTP entry field with auto-advance and paste support.
class MitumbaOTPInput extends StatefulWidget {
  const MitumbaOTPInput({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onComplete,
    this.error = false,
    this.loading = false,
  });

  /// The current OTP value (6 digits).
  final String value;

  /// Called when the OTP value changes.
  final ValueChanged<String> onChanged;

  /// Called when all 6 digits are entered.
  final ValueChanged<String> onComplete;

  /// Whether the input has an error (triggers shake animation).
  final bool error;

  /// Whether the input is in a loading state.
  final bool loading;

  @override
  State<MitumbaOTPInput> createState() => _MitumbaOTPInputState();
}

class _MitumbaOTPInputState extends State<MitumbaOTPInput> with SingleTickerProviderStateMixin {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(6, (_) => FocusNode());
    _controllers = List.generate(6, (i) => TextEditingController(
      text: i < widget.value.length ? widget.value[i] : '',
    ));

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut));

    if (widget.error) {
      _shakeController.forward(from: 0.0);
    }
  }

  @override
  void didUpdateWidget(covariant MitumbaOTPInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.error && !oldWidget.error) {
      _shakeController.forward(from: 0.0);
    }

    // Sync controllers with external value changes
    final val = widget.value;
    for (int i = 0; i < 6; i++) {
      final expectedChar = i < val.length ? val[i] : '';
      if (_controllers[i].text != expectedChar) {
        _controllers[i].text = expectedChar;
      }
    }
  }

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    for (final ctrl in _controllers) {
      ctrl.dispose();
    }
    _shakeController.dispose();
    super.dispose();
  }

  String _getOTPFromControllers() {
    return _controllers.map((c) => c.text).join('');
  }

  void _handleChanged(int index, String val) {
    final digitsOnly = val.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length > 1) {
      // Handle paste
      final pasteVal = digitsOnly.substring(0, digitsOnly.length > 6 ? 6 : digitsOnly.length);
      for (int i = 0; i < 6; i++) {
        _controllers[i].text = i < pasteVal.length ? pasteVal[i] : '';
      }
      final newOTP = _getOTPFromControllers();
      widget.onChanged(newOTP);
      if (newOTP.length == 6) {
        widget.onComplete(newOTP);
        _focusNodes[5].requestFocus();
      } else {
        _focusNodes[newOTP.length].requestFocus();
      }
      return;
    }

    _controllers[index].text = digitsOnly;
    final newOTP = _getOTPFromControllers();
    widget.onChanged(newOTP);

    if (digitsOnly.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (newOTP.length == 6) {
      widget.onComplete(newOTP);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: child,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(6, (index) {
          return Container(
            width: 44,
            height: 48,
            margin: EdgeInsets.symmetric(
              horizontal: index == 0 ? 0 : MitumbaSpacing.xs,
            ),
            child: KeyboardListener(
              focusNode: FocusNode(), // Dummy focus node for keyboard events
              onKeyEvent: (KeyEvent event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.backspace) {
                  final text = _controllers[index].text;
                  if (text.isEmpty && index > 0) {
                    _controllers[index - 1].text = '';
                    final newOTP = _getOTPFromControllers();
                    widget.onChanged(newOTP);
                    _focusNodes[index - 1].requestFocus();
                  } else if (text.isNotEmpty) {
                    _controllers[index].text = '';
                    final newOTP = _getOTPFromControllers();
                    widget.onChanged(newOTP);
                  }
                }
              },
              child: TextField(
                focusNode: _focusNodes[index],
                controller: _controllers[index],
                enabled: !widget.loading,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: MitumbaTypography.fontSizeXl,
                  fontWeight: FontWeight.w700,
                  color: MitumbaColors.textPrimary,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.error ? MitumbaColors.error : MitumbaColors.divider,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(MitumbaRadius.md),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.error ? MitumbaColors.error : MitumbaColors.green,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(MitumbaRadius.md),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: MitumbaColors.divider,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(MitumbaRadius.md),
                  ),
                  fillColor: MitumbaColors.surface,
                  filled: true,
                ),
                onChanged: (val) => _handleChanged(index, val),
              ),
            ),
          );
        }),
      ),
    );
  }
}
