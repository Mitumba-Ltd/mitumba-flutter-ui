import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/typography.dart';

enum MitumbaTextFieldSize { small, medium, large }
enum MitumbaTextFieldStatus { success, warning, error }
enum MitumbaTextFieldRounding { pill, rounded }

/// A premium, living text field component with precision scaling and tactile states.
class MitumbaTextField extends StatefulWidget {
  const MitumbaTextField({
    super.key,
    this.label,
    required this.hint,
    required this.value,
    required this.onChange,
    this.helperText,
    this.error,
    this.size = MitumbaTextFieldSize.medium,
    this.rounding = MitumbaTextFieldRounding.rounded,
    this.status,
    this.prefix,
    this.suffix,
    this.endButton,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.disabled = false,
    this.multiline = false,
    this.rows = 4,
    this.readOnly = false,
    this.focusNode,
    this.controller,
  });

  /// Optional label text displayed above the field.
  final String? label;

  /// Placeholder text shown when the field is empty.
  final String hint;

  /// Controlled value of the input.
  final String value;

  /// Callback fired when the value changes.
  final ValueChanged<String> onChange;

  /// Supporting text displayed below the field.
  final String? helperText;

  /// Error message displayed below the field. If provided, sets status to 'error'.
  final String? error;

  /// Scale standard: small(32), medium(42), large(52).
  final MitumbaTextFieldSize size;

  /// Corner geometry: rounded(8), pill(9999).
  final MitumbaTextFieldRounding rounding;

  /// Validation status treatment.
  final MitumbaTextFieldStatus? status;

  /// Leading icon or content.
  final Widget? prefix;

  /// Trailing icon or content.
  final Widget? suffix;

  /// Integrated button at the end of the input.
  final Widget? endButton;

  /// Keyboard type.
  final TextInputType keyboardType;

  /// Whether to obscure text (e.g. for passwords).
  final bool obscureText;

  /// Whether the field is disabled.
  final bool disabled;

  /// Renders a multi-line textarea instead of a single-line input.
  final bool multiline;

  /// Number of visible rows for a multi-line textarea.
  final int rows;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Optional focus node to control focus behavior.
  final FocusNode? focusNode;

  /// Optional controller to manage text value.
  final TextEditingController? controller;

  @override
  State<MitumbaTextField> createState() => _MitumbaTextFieldState();
}

class _MitumbaTextFieldState extends State<MitumbaTextField> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? TextEditingController(text: widget.value);

    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant MitumbaTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Basic setup for structure — to be refined in subsequent commits
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4, left: 4),
            child: Text(
              widget.label!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        TextField(
          focusNode: _focusNode,
          controller: _controller,
          onChanged: widget.onChange,
          decoration: InputDecoration(
            hintText: widget.hint,
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
