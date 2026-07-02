import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Visual variant for [MitumbaPrimaryButton].
enum ButtonVariant { primary, earth, outline, ghost, danger }

/// Size variant for [MitumbaPrimaryButton].
enum ButtonSize { small, medium, large }

/// Standard button for all primary/secondary actions.
///
/// Mirrors the web `MitumbaPrimaryButton` from `@mitumba/ui`.
///
/// ```dart
/// MitumbaPrimaryButton(
///   label: 'Add to Cart',
///   onPressed: () {},
///   variant: ButtonVariant.primary,
/// )
/// ```
class MitumbaPrimaryButton extends StatelessWidget {
  /// Creates a Mitumba primary button.
  const MitumbaPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.disabled = false,
    this.loading = false,
    this.fullWidth = false,
    this.icon,
    this.iconPosition = IconPosition.left,
  });

  /// Button label text.
  final String label;

  /// Called when the button is tapped.
  final VoidCallback onPressed;

  /// Visual variant.
  final ButtonVariant variant;

  /// Size variant.
  final ButtonSize size;

  /// Whether the button is disabled.
  final bool disabled;

  /// Whether to show a loading spinner.
  final bool loading;

  /// Whether the button takes full width.
  final bool fullWidth;

  /// Optional leading or trailing icon.
  final IconData? icon;

  /// Position of the icon relative to the label.
  final IconPosition iconPosition;

  @override
  Widget build(BuildContext context) {
    final config = _variantConfig(variant);
    final sizeConfig = _sizeConfig(size);
    final isDisabled = disabled || loading;

    final child = _buildChild(sizeConfig);

    final buttonStyle = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return config.background.withAlpha(100);
        return config.background;
      }),
      foregroundColor: WidgetStateProperty.all(config.foreground),
      side: config.border != null
          ? WidgetStateProperty.all(BorderSide(color: config.border!))
          : null,
      padding: WidgetStateProperty.all(sizeConfig.padding),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(MitumbaRadius.md)),
      ),
      textStyle: WidgetStateProperty.all(sizeConfig.textStyle),
      minimumSize: fullWidth
          ? WidgetStateProperty.all(const Size(double.infinity, 0))
          : null,
    );

    return Semantics(
      button: true,
      label: loading ? '$label, loading' : label,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: buttonStyle,
        child: child,
      ),
    );
  }

  Widget _buildChild(_SizeConfig sizeConfig) {
    if (loading) {
      return SizedBox(
        width: sizeConfig.spinnerSize,
        height: sizeConfig.spinnerSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: _variantConfig(variant).foreground,
        ),
      );
    }

    if (icon == null) {
      return Text(label);
    }

    final iconWidget = Icon(icon, size: sizeConfig.iconSize);
    final gap = SizedBox(width: MitumbaSpacing.sm);

    if (iconPosition == IconPosition.right) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [Text(label), gap, iconWidget],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [iconWidget, gap, Text(label)],
    );
  }
}

/// Icon position relative to button label.
enum IconPosition { left, right }

class _VariantConfig {
  const _VariantConfig({required this.background, required this.foreground, this.border});
  final Color background;
  final Color foreground;
  final Color? border;
}

_VariantConfig _variantConfig(ButtonVariant variant) {
  switch (variant) {
    case ButtonVariant.primary:
      return const _VariantConfig(
        background: MitumbaColors.green,
        foreground: MitumbaColors.white,
      );
    case ButtonVariant.earth:
      return const _VariantConfig(
        background: MitumbaColors.earth,
        foreground: MitumbaColors.white,
      );
    case ButtonVariant.outline:
      return const _VariantConfig(
        background: Color(0x00000000),
        foreground: MitumbaColors.textPrimary,
        border: MitumbaColors.border,
      );
    case ButtonVariant.ghost:
      return const _VariantConfig(
        background: Color(0x00000000),
        foreground: MitumbaColors.green,
      );
    case ButtonVariant.danger:
      return const _VariantConfig(
        background: MitumbaColors.error,
        foreground: MitumbaColors.white,
      );
  }
}

class _SizeConfig {
  const _SizeConfig({required this.padding, required this.textStyle, required this.iconSize, required this.spinnerSize});
  final EdgeInsets padding;
  final TextStyle textStyle;
  final double iconSize;
  final double spinnerSize;
}

_SizeConfig _sizeConfig(ButtonSize size) {
  switch (size) {
    case ButtonSize.small:
      return _SizeConfig(
        padding: EdgeInsets.symmetric(horizontal: MitumbaSpacing.base, vertical: MitumbaSpacing.sm),
        textStyle: MitumbaTypography.caption.copyWith(fontWeight: FontWeight.w600),
        iconSize: 16,
        spinnerSize: 14,
      );
    case ButtonSize.medium:
      return _SizeConfig(
        padding: EdgeInsets.symmetric(horizontal: MitumbaSpacing.lg, vertical: MitumbaSpacing.base),
        textStyle: MitumbaTypography.button,
        iconSize: 18,
        spinnerSize: 18,
      );
    case ButtonSize.large:
      return _SizeConfig(
        padding: EdgeInsets.symmetric(horizontal: MitumbaSpacing.xl, vertical: MitumbaSpacing.lg),
        textStyle: MitumbaTypography.button.copyWith(fontSize: MitumbaTypography.fontSizeMd),
        iconSize: 20,
        spinnerSize: 20,
      );
  }
}
