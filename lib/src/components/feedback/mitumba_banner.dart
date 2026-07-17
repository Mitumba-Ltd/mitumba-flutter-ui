import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

enum MitumbaBannerSeverity { success, error, warning, info, neutral }

/// Premium "Passive Alert" Banner primitive.
/// Engineered for high-fidelity notifications with systematic status colors and precision geometry.
class MitumbaBanner extends StatelessWidget {
  const MitumbaBanner({
    super.key,
    required this.title,
    this.message,
    this.severity = MitumbaBannerSeverity.info,
    this.icon,
    this.onClose,
    this.action,
  });

  final String title;
  final String? message;
  final MitumbaBannerSeverity severity;
  final Widget? icon;
  final VoidCallback? onClose;
  final Widget? action;

  _BannerConfig _getConfig() {
    switch (severity) {
      case MitumbaBannerSeverity.success:
        return _BannerConfig(
          color: MitumbaColors.green,
          bgColor: MitumbaColors.green.withValues(alpha: 0.1),
          icon: const Icon(Icons.check_circle, color: MitumbaColors.green),
        );
      case MitumbaBannerSeverity.error:
        return _BannerConfig(
          color: MitumbaColors.error,
          bgColor: MitumbaColors.error.withValues(alpha: 0.1),
          icon: const Icon(Icons.error, color: MitumbaColors.error),
        );
      case MitumbaBannerSeverity.warning:
        return _BannerConfig(
          color: MitumbaColors.warning,
          bgColor: MitumbaColors.warning.withValues(alpha: 0.1),
          icon: const Icon(Icons.warning, color: MitumbaColors.warning),
        );
      case MitumbaBannerSeverity.neutral:
        return _BannerConfig(
          color: MitumbaColors.textSecondary,
          bgColor: MitumbaColors.background,
          icon: const Icon(Icons.help, color: MitumbaColors.textSecondary),
        );
      case MitumbaBannerSeverity.info:
        return _BannerConfig(
          color: MitumbaColors.info,
          bgColor: MitumbaColors.info.withValues(alpha: 0.1),
          icon: const Icon(Icons.info, color: MitumbaColors.info),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();

    return ClipRRect(
      borderRadius: BorderRadius.circular(MitumbaRadius.md),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: config.bgColor,
          border: Border.all(color: MitumbaColors.divider),
          borderRadius: BorderRadius.circular(MitumbaRadius.md),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 4,
              width: double.infinity,
              color: config.color,
            ),
            Padding(
              padding: const EdgeInsets.all(MitumbaSpacing.lg),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  icon ?? config.icon,
                  const SizedBox(width: MitumbaSpacing.md),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: MitumbaTypography.fontSizeBase,
                            fontWeight: FontWeight.w800,
                            color: MitumbaColors.textPrimary,
                            height: 1.2,
                          ),
                        ),
                        if (message != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            message!,
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: MitumbaTypography.fontSizeSm,
                              color: MitumbaColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Action / Close row
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (action != null) action!,
                      if (onClose != null)
                        IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          color: MitumbaColors.textDisabled,
                          onPressed: onClose,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          splashRadius: 16,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerConfig {
  const _BannerConfig({
    required this.color,
    required this.bgColor,
    required this.icon,
  });

  final Color color;
  final Color bgColor;
  final Widget icon;
}
