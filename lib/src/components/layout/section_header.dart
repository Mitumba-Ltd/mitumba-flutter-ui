import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../foundation/mitumba_primary_button.dart';

/// Alignment for [SectionHeader].
enum SectionHeaderAlign {
  left,
  center,
}

/// Visual variant for [SectionHeader].
enum SectionHeaderVariant {
  standard,
  large,
}

/// A premium layout Section Header widget with flexible alignment and brand typography.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.overline,
    this.action,
    this.align = SectionHeaderAlign.left,
    this.variant = SectionHeaderVariant.standard,
    this.actionLabel,
    this.onAction,
  });

  /// Main section title.
  final String title;

  /// Supporting descriptive text.
  final String? subtitle;

  /// Secondary small label displayed above the title.
  final String? overline;

  /// Primary action element (e.g., custom button or badge).
  final Widget? action;

  /// Horizontal alignment. Defaults to [SectionHeaderAlign.left].
  final SectionHeaderAlign align;

  /// Visual scale. Defaults to [SectionHeaderVariant.standard].
  final SectionHeaderVariant variant;

  /// Label for standard ghost action button.
  final String? actionLabel;

  /// Callback when the standard action button is pressed.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final bool isCentered = align == SectionHeaderAlign.center;
    final bool isLarge = variant == SectionHeaderVariant.large;

    final Widget textBlock = Column(
      crossAxisAlignment: isCentered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (overline != null) ...[
          Text(
            overline!.toUpperCase(),
            style: const TextStyle(
              fontFamily: MitumbaTypography.fontFamily,
              fontSize: MitumbaTypography.fontSizeSm,
              fontWeight: MitumbaTypography.extrabold,
              color: MitumbaColors.green,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
        ],
        Text(
          title,
          style: TextStyle(
            fontFamily: MitumbaTypography.fontFamily,
            fontSize: isLarge ? MitumbaTypography.fontSizeDisplay : MitumbaTypography.fontSizeXxl,
            fontWeight: FontWeight.w900,
            color: MitumbaColors.textPrimary,
            letterSpacing: -0.28,
            height: 1.1,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              subtitle!,
              textAlign: isCentered ? TextAlign.center : TextAlign.left,
              style: TextStyle(
                fontFamily: MitumbaTypography.fontFamily,
                fontSize: isLarge ? MitumbaTypography.fontSizeMd : MitumbaTypography.fontSizeBase,
                fontWeight: MitumbaTypography.regular,
                color: MitumbaColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ],
    );

    final Widget? actionWidget = action ??
        (actionLabel != null
            ? MitumbaPrimaryButton(
                label: actionLabel!,
                onPressed: onAction ?? () {},
                variant: ButtonVariant.ghost,
                size: ButtonSize.small,
              )
            : null);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        bottom: isLarge ? MitumbaSpacing.xxxl : MitumbaSpacing.xxl,
      ),
      child: isCentered
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                textBlock,
                if (actionWidget != null) ...[
                  const SizedBox(height: MitumbaSpacing.base),
                  actionWidget,
                ],
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: textBlock),
                if (actionWidget != null) ...[
                  const SizedBox(width: MitumbaSpacing.base),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: actionWidget,
                  ),
                ],
              ],
            ),
    );
  }
}
