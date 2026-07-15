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
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? TextEditingController(text: widget.value);
    _obscureText = widget.obscureText;

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
    final currentStatus = widget.error != null ? MitumbaTextFieldStatus.error : widget.status;

    final double? height = widget.multiline ? null : (widget.size == MitumbaTextFieldSize.small ? 32.0 : (widget.size == MitumbaTextFieldSize.large ? 52.0 : 42.0));
    final double fontSize = widget.size == MitumbaTextFieldSize.small ? 12.0 : (widget.size == MitumbaTextFieldSize.large ? 16.0 : 14.0);
    final double iconSize = widget.size == MitumbaTextFieldSize.small ? 18.0 : (widget.size == MitumbaTextFieldSize.large ? 24.0 : 20.0);

    double radiusValue = MitumbaRadius.md;
    if (widget.rounding == MitumbaTextFieldRounding.pill) {
      radiusValue = MitumbaRadius.full;
    }

    Color statusColor = MitumbaColors.textSecondary;
    if (currentStatus == MitumbaTextFieldStatus.success) {
      statusColor = MitumbaColors.success;
    } else if (currentStatus == MitumbaTextFieldStatus.error) {
      statusColor = MitumbaColors.error;
    } else if (currentStatus == MitumbaTextFieldStatus.warning) {
      statusColor = MitumbaColors.warning;
    }

    Color activeBorderColor = MitumbaColors.divider;
    if (currentStatus != null) {
      activeBorderColor = statusColor;
    } else if (_isFocused) {
      activeBorderColor = MitumbaColors.green;
    }

    final double borderWidth = (currentStatus != null || _isFocused) ? 2.0 : 1.0;

    final List<BoxShadow> shadows = (_isFocused && currentStatus == null)
        ? [
            BoxShadow(
              color: MitumbaColors.green.withOpacity(0.08),
              blurRadius: 4,
              spreadRadius: 2,
            )
          ]
        : [];

    final Widget? trailingIcon;
    if (widget.obscureText) {
      trailingIcon = GestureDetector(
        onTap: () => setState(() => _obscureText = !_obscureText),
        child: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: iconSize,
          color: MitumbaColors.textSecondary,
        ),
      );
    } else if (currentStatus == MitumbaTextFieldStatus.success) {
      trailingIcon = Icon(Icons.check_circle_outline, size: iconSize, color: MitumbaColors.success);
    } else if (currentStatus == MitumbaTextFieldStatus.error) {
      trailingIcon = Icon(Icons.error_outline, size: iconSize, color: MitumbaColors.error);
    } else if (currentStatus == MitumbaTextFieldStatus.warning) {
      trailingIcon = Icon(Icons.warning_amber_outlined, size: iconSize, color: MitumbaColors.warning);
    } else {
      trailingIcon = widget.suffix;
    }

    final hasLabel = widget.label != null;
    final hasHelper = widget.helperText != null || widget.error != null;

    final inputDecoration = InputDecoration(
      isCollapsed: true,
      hintText: widget.hint,
      hintStyle: const TextStyle(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w500,
        color: MitumbaColors.textDisabled,
      ),
      border: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(
        vertical: widget.multiline ? 12 : (height! - fontSize) / 2 - borderWidth,
      ),
    );

    Widget inputContainer = Container(
      height: height,
      decoration: BoxDecoration(
        color: widget.disabled ? MitumbaColors.background : MitumbaColors.surface,
        borderRadius: widget.endButton != null
            ? BorderRadius.horizontal(left: Radius.circular(radiusValue))
            : BorderRadius.circular(radiusValue),
        border: Border.all(color: activeBorderColor, width: borderWidth),
        boxShadow: shadows,
      ),
      padding: EdgeInsets.only(
        left: widget.rounding == MitumbaTextFieldRounding.pill ? 16 : 12,
        right: widget.rounding == MitumbaTextFieldRounding.pill ? 16 : 12,
      ),
      child: Row(
        children: [
          if (widget.prefix != null) ...[
            IconTheme(
              data: IconThemeData(size: iconSize, color: MitumbaColors.textSecondary),
              child: widget.prefix!,
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              controller: _controller,
              onChanged: widget.onChange,
              obscureText: _obscureText,
              disabled: widget.disabled,
              readOnly: widget.readOnly,
              maxLines: widget.multiline ? widget.rows : 1,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: MitumbaColors.textPrimary,
              ),
              decoration: inputDecoration,
            ),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: 8),
            IconTheme(
              data: IconThemeData(size: iconSize, color: MitumbaColors.textSecondary),
              child: trailingIcon,
            ),
          ],
        ],
      ),
    );

    if (widget.endButton != null) {
      inputContainer = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: inputContainer),
          ClipRRect(
            borderRadius: BorderRadius.horizontal(right: Radius.circular(radiusValue)),
            child: SizedBox(
              height: height,
              child: widget.endButton!,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasLabel) ...[
          Padding(
            padding: EdgeInsets.only(
              bottom: 4,
              left: widget.rounding == MitumbaTextFieldRounding.pill ? 16 : 8,
            ),
            child: Text(
              widget.label!.toUpperCase(),
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: currentStatus != null ? statusColor : MitumbaColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
        inputContainer,
        if (hasHelper) ...[
          Padding(
            padding: EdgeInsets.only(
              top: 4,
              left: widget.rounding == MitumbaTextFieldRounding.pill ? 16 : 8,
            ),
            child: Text(
              widget.error ?? widget.helperText!,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: currentStatus != null ? statusColor : MitumbaColors.textSecondary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
