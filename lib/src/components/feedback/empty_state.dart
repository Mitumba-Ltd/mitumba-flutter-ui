import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/shadows.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Layout variant for [EmptyState].
enum EmptyStateVariant { standard, compact, elevated }

/// Empty state — communicates absence of content and guides users to action.
///
/// Mirrors the web `EmptyState` from `@mitumba/ui`.
///
/// ```dart
/// EmptyState(
///   icon: Icons.inbox_outlined,
///   title: 'No messages yet',
///   subtitle: 'Start a conversation with a seller.',
///   actionLabel: 'Browse listings',
///   onAction: () {},
/// )
/// ```
class EmptyState extends StatelessWidget {
  /// Creates an empty state.
  const EmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
    this.illustration,
    this.actionLabel,
    this.onAction,
    this.variant = EmptyStateVariant.standard,
  });

  /// Primary headline.
  final String title;

  /// Supporting description.
  final String subtitle;

  /// Icon displayed in a circular container.
  final IconData? icon;

  /// Custom illustration widget (takes precedence over [icon]).
  final Widget? illustration;

  /// CTA button label.
  final String? actionLabel;

  /// Called when the action button is tapped.
  final VoidCallback? onAction;

  /// Layout variant.
  final EmptyStateVariant variant;

  bool get _isCompact => variant == EmptyStateVariant.compact;
  bool get _isElevated => variant == EmptyStateVariant.elevated;

  @override
  Widget build(BuildContext context) {
    final displayIcon = illustration ??
        (icon != null
            ? Icon(icon, size: _isCompact ? 24 : 32, color: MitumbaColors.textDisabled)
            : null);

    final content = _isCompact ? _buildCompact(displayIcon) : _buildStandard(displayIcon);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: _isCompact ? MitumbaSpacing.xl : MitumbaSpacing.huge,
        horizontal: _isCompact ? MitumbaSpacing.xl : MitumbaSpacing.xxxl,
      ),
      decoration: BoxDecoration(
        color: _isElevated ? MitumbaColors.surface : Colors.transparent,
        borderRadius: BorderRadius.circular(MitumbaRadius.xl),
        border: _isElevated ? null : Border.all(color: MitumbaColors.divider),
        boxShadow: _isElevated ? MitumbaShadows.card : null,
      ),
      child: content,
    );
  }

  Widget _buildStandard(Widget? displayIcon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (displayIcon != null) _iconCircle(displayIcon, 72),
        if (displayIcon != null) SizedBox(height: MitumbaSpacing.md),
        Text(
          title,
          textAlign: TextAlign.center,
          style: MitumbaTypography.h5,
        ),
        SizedBox(height: MitumbaSpacing.xs),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: MitumbaTypography.body2.copyWith(color: MitumbaColors.textSecondary),
          ),
        ),
        if (actionLabel != null) ...[
          SizedBox(height: MitumbaSpacing.xl),
          ElevatedButton(
            onPressed: onAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: MitumbaColors.green,
              foregroundColor: MitumbaColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MitumbaRadius.md)),
            ),
            child: Text(actionLabel!),
          ),
        ],
      ],
    );
  }

  Widget _buildCompact(Widget? displayIcon) {
    return Row(
      children: [
        if (displayIcon != null) ...[
          _iconCircle(displayIcon, 48),
          SizedBox(width: MitumbaSpacing.lg),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: MitumbaTypography.body2.copyWith(fontWeight: FontWeight.w700)),
              SizedBox(height: MitumbaSpacing.xs),
              Text(subtitle, style: MitumbaTypography.caption.copyWith(color: MitumbaColors.textSecondary)),
              if (actionLabel != null) ...[
                SizedBox(height: MitumbaSpacing.md),
                ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MitumbaColors.green,
                    foregroundColor: MitumbaColors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MitumbaRadius.md)),
                  ),
                  child: Text(actionLabel!, style: const TextStyle(fontSize: 12)),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _iconCircle(Widget child, double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: MitumbaColors.background,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
