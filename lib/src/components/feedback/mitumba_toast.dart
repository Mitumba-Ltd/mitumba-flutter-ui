import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Toast severity variants.
enum ToastVariant { success, error, warning, info }

Color _variantColor(ToastVariant variant) {
  switch (variant) {
    case ToastVariant.success:
      return MitumbaColors.success;
    case ToastVariant.error:
      return MitumbaColors.error;
    case ToastVariant.warning:
      return MitumbaColors.warning;
    case ToastVariant.info:
      return MitumbaColors.info;
  }
}

IconData _variantIcon(ToastVariant variant) {
  switch (variant) {
    case ToastVariant.success:
      return Icons.check_circle_outline;
    case ToastVariant.error:
      return Icons.error_outline;
    case ToastVariant.warning:
      return Icons.warning_amber_outlined;
    case ToastVariant.info:
      return Icons.info_outline;
  }
}

/// Tactile toast/snackbar for feedback — shows status with icon, message, and optional action.
///
/// Mirrors the web `MitumbaToast` from `@mitumba/ui`.
///
/// Use [showMitumbaToast] to display via ScaffoldMessenger.
///
/// ```dart
/// showMitumbaToast(
///   context,
///   message: 'Item added to cart',
///   variant: ToastVariant.success,
/// );
/// ```
class MitumbaToast extends StatelessWidget {
  /// Creates a toast widget (typically used inside a SnackBar).
  const MitumbaToast({
    super.key,
    required this.message,
    this.variant = ToastVariant.info,
    this.actionLabel,
    this.onAction,
    this.onDismiss,
  });

  /// Toast message text.
  final String message;

  /// Severity variant.
  final ToastVariant variant;

  /// Optional action button label.
  final String? actionLabel;

  /// Called when the action button is tapped.
  final VoidCallback? onAction;

  /// Called when the toast is dismissed.
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final color = _variantColor(variant);
    final icon = _variantIcon(variant);

    return Semantics(
      liveRegion: true,
      label: '$message, ${variant.name}',
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MitumbaSpacing.lg,
          vertical: MitumbaSpacing.base,
        ),
        decoration: BoxDecoration(
          color: MitumbaColors.textPrimary,
          borderRadius: BorderRadius.circular(MitumbaRadius.md),
          border: Border(left: BorderSide(color: color, width: 4)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            SizedBox(width: MitumbaSpacing.base),
            Expanded(
              child: Text(
                message,
                style: MitumbaTypography.body2.copyWith(color: MitumbaColors.white),
              ),
            ),
            if (actionLabel != null) ...[
              SizedBox(width: MitumbaSpacing.md),
              GestureDetector(
                onTap: onAction,
                child: Text(
                  actionLabel!,
                  style: MitumbaTypography.caption.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
            if (onDismiss != null) ...[
              SizedBox(width: MitumbaSpacing.md),
              GestureDetector(
                onTap: onDismiss,
                child: Icon(Icons.close, size: 18, color: MitumbaColors.white.withAlpha(180)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Shows a [MitumbaToast] via ScaffoldMessenger.
void showMitumbaToast(
  BuildContext context, {
  required String message,
  ToastVariant variant = ToastVariant.info,
  String? actionLabel,
  VoidCallback? onAction,
  Duration duration = const Duration(seconds: 4),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: MitumbaToast(
        message: message,
        variant: variant,
        actionLabel: actionLabel,
        onAction: () {
          onAction?.call();
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
        onDismiss: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      duration: duration,
      padding: EdgeInsets.zero,
    ),
  );
}
