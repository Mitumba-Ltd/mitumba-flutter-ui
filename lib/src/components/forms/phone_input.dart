import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/shadows.dart';

/// Kenya-specific phone number input with +254 prefix.
/// Formats as 7XX XXX XXX on blur.
class MitumbaPhoneInput extends StatefulWidget {
  const MitumbaPhoneInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.error,
    this.disabled = false,
    this.focusNode,
  });

  /// The current phone number value (raw 9 digits, e.g. "712345678").
  final String value;

  /// Called when the phone number changes (receives raw 9 digits).
  final ValueChanged<String> onChanged;

  /// Optional label text displayed above the input.
  final String? label;

  /// Optional error message to display below the input.
  final String? error;

  /// Whether the input is disabled.
  final bool disabled;

  /// Optional focus node.
  final FocusNode? focusNode;

  @override
  State<MitumbaPhoneInput> createState() => _MitumbaPhoneInputState();
}

class _MitumbaPhoneInputState extends State<MitumbaPhoneInput> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = TextEditingController(text: _getDisplayText(widget.value, _focusNode.hasFocus));

    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant MitumbaPhoneInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    final expectedText = _getDisplayText(widget.value, _isFocused);
    if (_controller.text != expectedText) {
      _controller.text = expectedText;
    }
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });

    final expectedText = _getDisplayText(widget.value, _isFocused);
    if (_controller.text != expectedText) {
      _controller.text = expectedText;
      if (_isFocused) {
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
      }
    }
  }

  String _getDisplayText(String val, bool focused) {
    if (focused) return val;
    return _formatDisplay(val);
  }

  String _formatDisplay(String val) {
    if (val.isEmpty) return '';
    // Format into groups: 3 - 3 - 3
    final length = val.length;
    if (length <= 3) return val;
    if (length <= 6) {
      return '${val.substring(0, 3)} ${val.substring(3)}';
    }
    return '${val.substring(0, 3)} ${val.substring(3, 6)} ${val.substring(6, Math.min(length, 9))}';
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.error != null;
    Color borderColor = hasError
        ? MitumbaColors.error
        : (_isFocused ? MitumbaColors.green : MitumbaColors.divider);

    final double borderWidth = (_isFocused || hasError) ? 2.0 : 1.0;

    final List<BoxShadow> shadows = (_isFocused && !hasError)
        ? [
            BoxShadow(
              color: MitumbaColors.green.withOpacity(0.08),
              blurRadius: 4,
              spreadRadius: 2,
            )
          ]
        : [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 4, left: 8),
            child: Text(
              widget.label!.toUpperCase(),
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: hasError ? MitumbaColors.error : MitumbaColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
        Container(
          height: 42.0,
          decoration: BoxDecoration(
            color: widget.disabled ? MitumbaColors.background : MitumbaColors.surface,
            borderRadius: BorderRadius.circular(MitumbaRadius.md),
            border: Border.all(color: borderColor, width: borderWidth),
            boxShadow: shadows,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              // Prefix "+254"
              Text(
                '+254',
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: MitumbaColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              // Vertical Divider Line
              Container(
                width: 1,
                height: 20,
                color: MitumbaColors.divider,
              ),
              const SizedBox(width: 12),
              // Input Field
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  controller: _controller,
                  enabled: !widget.disabled,
                  keyboardType: TextInputType.phone,
                  inputFormatters: _isFocused
                      ? [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(9),
                        ]
                      : [],
                  onChanged: (val) {
                    final raw = val.replaceAll(RegExp(r'\D'), '');
                    widget.onChanged(raw);
                  },
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: MitumbaColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    hintText: '7XX XXX XXX',
                    hintStyle: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w500,
                      color: MitumbaColors.textDisabled,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (hasError) ...[
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 8),
            child: Text(
              widget.error!,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: MitumbaColors.error,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class Math {
  static int min(int a, int b) => a < b ? a : b;
}
