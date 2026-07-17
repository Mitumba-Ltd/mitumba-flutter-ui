import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../foundation/mitumba_primary_button.dart';

enum MitumbaErrorType { general, e404, e500, network, forbidden }
enum MitumbaErrorVariant { standard, elevated, compact }

class MitumbaErrorState extends StatelessWidget {
  const MitumbaErrorState({
    super.key,
    this.title = 'Something went wrong',
    this.subtitle = 'Please try again',
    this.type = MitumbaErrorType.general,
    this.variant = MitumbaErrorVariant.standard,
    this.onRetry,
    this.retryLabel = 'Try again',
    this.onBack,
    this.illustration,
  });

  /// Main heading.
  final String title;

  /// Supporting description.
  final String subtitle;

  /// Error type (general, 404, 500, network, forbidden).
  final MitumbaErrorType type;

  /// Layout variant.
  final MitumbaErrorVariant variant;

  /// Primary retry action.
  final VoidCallback? onRetry;

  /// Retry action label.
  final String retryLabel;

  /// Secondary go back action.
  final VoidCallback? onBack;

  /// Custom icon/illustration to override the default.
  final Widget? illustration;

  IconData _getTypeIcon(MitumbaErrorType type) {
    switch (type) {
      case MitumbaErrorType.general:
        return Icons.bug_report_outlined;
      case MitumbaErrorType.e404:
        return Icons.sentiment_very_dissatisfied;
      case MitumbaErrorType.e500:
        return Icons.error_outline;
      case MitumbaErrorType.network:
        return Icons.wifi_off;
      case MitumbaErrorType.forbidden:
        return Icons.gpp_bad_outlined;
    }
  }

  Color _getTypeColor(MitumbaErrorType type) {
    switch (type) {
      case MitumbaErrorType.general:
      case MitumbaErrorType.e500:
      case MitumbaErrorType.forbidden:
        return MitumbaColors.error;
      case MitumbaErrorType.e404:
        return MitumbaColors.earth;
      case MitumbaErrorType.network:
        return MitumbaColors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = variant == MitumbaErrorVariant.compact;
    final isElevated = variant == MitumbaErrorVariant.elevated;
    final color = _getTypeColor(type);
    final icon = _getTypeIcon(type);

    final widgetIcon = illustration ??
        Icon(
          icon,
          size: isCompact ? 24 : 32,
          color: color,
        );

    final content = Column(
      crossAxisAlignment:
          isCompact ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          textAlign: isCompact ? TextAlign.left : TextAlign.center,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: isCompact ? MitumbaTypography.fontSizeBase : MitumbaTypography.fontSizeLg,
            fontWeight: FontWeight.w700,
            color: MitumbaColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          textAlign: isCompact ? TextAlign.left : TextAlign.center,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: isCompact ? MitumbaTypography.fontSizeXs : MitumbaTypography.fontSizeBase,
            color: MitumbaColors.textSecondary,
          ),
        ),
        if (onRetry != null || onBack != null) ...[
          const SizedBox(height: MitumbaSpacing.base),
          Row(
            mainAxisAlignment:
                isCompact ? MainAxisAlignment.start : MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onBack != null) ...[
                MitumbaPrimaryButton(
                  label: 'Go back',
                  variant: ButtonVariant.outline,
                  size: isCompact ? ButtonSize.small : ButtonSize.medium,
                  onPressed: onBack!,
                ),
                const SizedBox(width: 8),
              ],
              if (onRetry != null)
                MitumbaPrimaryButton(
                  label: retryLabel,
                  variant: ButtonVariant.primary,
                  size: isCompact ? ButtonSize.small : ButtonSize.medium,
                  onPressed: onRetry!,
                ),
            ],
          ),
        ],
      ],
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? MitumbaSpacing.xl : MitumbaSpacing.xxxl,
        vertical: isCompact ? MitumbaSpacing.xl : MitumbaSpacing.huge,
      ),
      decoration: BoxDecoration(
        color: isElevated ? MitumbaColors.surface : color.withOpacity(0.02),
        borderRadius: BorderRadius.circular(MitumbaRadius.xl),
        border: isElevated ? null : Border.all(color: color.withOpacity(0.08)),
        boxShadow: isElevated
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: isCompact
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widgetIcon,
                const SizedBox(width: MitumbaSpacing.lg),
                Expanded(child: content),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                widgetIcon,
                const SizedBox(height: MitumbaSpacing.md),
                content,
              ],
            ),
    );
  }
}
