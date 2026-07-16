import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../../tokens/shadows.dart';

/// Reusable card wrapper for form pages. Icon + title header, error alert, and padded content area.
class FormCard extends StatefulWidget {
  const FormCard({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    required this.child,
    this.error,
  });

  /// Optional icon displayed before the title.
  final Widget? icon;

  /// Form title.
  final String title;

  /// Optional subtitle below the title.
  final String? subtitle;

  /// Form body content.
  final Widget child;

  /// Error message shown above the card body.
  final String? error;

  @override
  State<FormCard> createState() => _FormCardState();
}

class _FormCardState extends State<FormCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 600),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                IconTheme(
                  data: const IconThemeData(
                    size: 28,
                    color: MitumbaColors.green,
                  ),
                  child: widget.icon!,
                ),
                const SizedBox(width: MitumbaSpacing.base),
              ],
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontFamily: MitumbaTypography.fontFamily,
                        fontSize: MitumbaTypography.fontSizeXl,
                        fontWeight: MitumbaTypography.extrabold,
                        color: MitumbaColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        widget.subtitle!,
                        style: const TextStyle(
                          fontFamily: MitumbaTypography.fontFamily,
                          fontSize: MitumbaTypography.fontSizeSm,
                          color: MitumbaColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: MitumbaSpacing.xl),

          // Error Alert Box
          if (widget.error != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(MitumbaSpacing.base),
              decoration: BoxDecoration(
                color: MitumbaColors.errorLight,
                borderRadius: BorderRadius.circular(MitumbaRadius.md),
                border: Border.all(color: MitumbaColors.error.withValues(alpha: 0.15)),
              ),
              child: Text(
                widget.error!,
                style: const TextStyle(
                  fontFamily: MitumbaTypography.fontFamily,
                  fontSize: MitumbaTypography.fontSizeSm,
                  fontWeight: MitumbaTypography.medium,
                  color: MitumbaColors.error,
                ),
              ),
            ),
            const SizedBox(height: MitumbaSpacing.lg),
          ],

          // Card Body
          MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              decoration: BoxDecoration(
                color: MitumbaColors.surface,
                borderRadius: BorderRadius.circular(MitumbaRadius.lg),
                border: Border.all(color: MitumbaColors.divider),
                boxShadow: _isHovered ? MitumbaShadows.elevated : MitumbaShadows.card,
              ),
              padding: const EdgeInsets.all(MitumbaSpacing.xxl),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
