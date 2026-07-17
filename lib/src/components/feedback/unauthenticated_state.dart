import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../foundation/mitumba_primary_button.dart';

/// Supporting data class representing a secondary action text link.
class MitumbaSecondaryAction {
  const MitumbaSecondaryAction({
    required this.label,
    required this.onClick,
  });

  final String label;
  final VoidCallback onClick;
}

/// UnauthenticatedState — shown on pages that require login when the user
/// is not authenticated. Centered on page with icon, title, subtitle, and
/// sign-in CTA. Follows EmptyState visual pattern.
class UnauthenticatedState extends StatelessWidget {
  const UnauthenticatedState({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
    this.signInLabel = 'Sign In',
    required this.onSignIn,
    this.secondaryAction,
  });

  final String title;
  final String subtitle;
  final Widget? icon;
  final String signInLabel;
  final VoidCallback onSignIn;
  final MitumbaSecondaryAction? secondaryAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: MitumbaSpacing.xl,
          vertical: MitumbaSpacing.xxxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon Container
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: MitumbaColors.background,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: icon ??
                  const Icon(
                    Icons.lock_outline,
                    size: 32,
                    color: MitumbaColors.textDisabled,
                  ),
            ),
            const SizedBox(height: MitumbaSpacing.xl),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: MitumbaTypography.fontSizeLg,
                fontWeight: FontWeight.w800,
                color: MitumbaColors.textPrimary,
                height: 1.2,
              ),
            ),
            const SizedBox(height: MitumbaSpacing.sm),

            // Subtitle
            Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: MitumbaTypography.fontSizeBase,
                  color: MitumbaColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: MitumbaSpacing.xxl),

            // Sign In Button
            Container(
              constraints: const BoxConstraints(maxWidth: 300),
              width: double.infinity,
              child: MitumbaPrimaryButton(
                label: signInLabel,
                onPressed: onSignIn,
              ),
            ),

            // Secondary Action link
            if (secondaryAction != null) ...[
              const SizedBox(height: MitumbaSpacing.lg),
              GestureDetector(
                onTap: secondaryAction!.onClick,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Text(
                    secondaryAction!.label,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: MitumbaTypography.fontSizeBase,
                      fontWeight: FontWeight.w600,
                      color: MitumbaColors.green,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
