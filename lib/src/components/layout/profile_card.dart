import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../../tokens/shadows.dart';
import '../foundation/mitumba_chip.dart';
import '../foundation/mitumba_primary_button.dart';

/// Role chip data model for [ProfileCard].
class ProfileCardRole {
  const ProfileCardRole({
    required this.label,
    this.icon,
    this.color = 'primary',
  });

  /// Role label (e.g. "Buyer", "Seller").
  final String label;

  /// Optional leading icon widget.
  final Widget? icon;

  /// Color variant. Can be 'primary' or 'secondary'.
  final String color;
}

/// ProfileCard — user identity card with avatar, name, role chips, and action button.
class ProfileCard extends StatefulWidget {
  const ProfileCard({
    super.key,
    required this.name,
    this.avatarUrl,
    this.roles = const [],
    this.actionLabel,
    this.onAction,
    this.subtitle,
  });

  /// Display name.
  final String name;

  /// Avatar image URL.
  final String? avatarUrl;

  /// Role chips list.
  final List<ProfileCardRole> roles;

  /// Action button label (e.g. "Edit Profile").
  final String? actionLabel;

  /// Called when the action button is pressed.
  final VoidCallback? onAction;

  /// Supporting subtitle text below the name (e.g. county, member since).
  final String? subtitle;

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Generate initials (up to 2 chars)
    String initials = '';
    final nameParts = widget.name.trim().split(RegExp(r'\s+'));
    if (nameParts.isNotEmpty) {
      initials += nameParts[0][0].toUpperCase();
      if (nameParts.length > 1) {
        initials += nameParts[1][0].toUpperCase();
      }
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: MitumbaColors.surface,
          borderRadius: BorderRadius.circular(MitumbaRadius.lg),
          border: Border.all(color: MitumbaColors.divider),
          boxShadow: _isHovered ? MitumbaShadows.elevated : MitumbaShadows.card,
        ),
        padding: const EdgeInsets.all(MitumbaSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            CircleAvatar(
              radius: 48,
              backgroundColor: MitumbaColors.green,
              backgroundImage: widget.avatarUrl != null ? NetworkImage(widget.avatarUrl!) : null,
              child: widget.avatarUrl == null
                  ? Text(
                      initials,
                      style: const TextStyle(
                        fontFamily: MitumbaTypography.fontFamily,
                        fontSize: 32,
                        fontWeight: MitumbaTypography.extrabold,
                        color: MitumbaColors.white,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: MitumbaSpacing.lg),

            // Name
            Text(
              widget.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: MitumbaTypography.fontFamily,
                fontSize: MitumbaTypography.fontSizeXl,
                fontWeight: MitumbaTypography.extrabold,
                color: MitumbaColors.textPrimary,
                height: 1.2,
              ),
            ),

            // Subtitle
            if (widget.subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                widget.subtitle!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: MitumbaTypography.fontFamily,
                  fontSize: MitumbaTypography.fontSizeSm,
                  color: MitumbaColors.textSecondary,
                ),
              ),
            ],

            // Role chips
            if (widget.roles.isNotEmpty) ...[
              const SizedBox(height: MitumbaSpacing.base),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: MitumbaSpacing.sm,
                runSpacing: MitumbaSpacing.sm,
                children: widget.roles.map((role) {
                  return MitumbaChip(
                    label: role.label,
                    icon: role.icon,
                    size: 'small',
                    variant: MitumbaChipVariant.solid,
                    rounding: MitumbaChipRounding.pill,
                    status: role.color == 'secondary' ? MitumbaChipStatus.special : MitumbaChipStatus.active,
                  );
                }).toList(),
              ),
            ],

            // Action Button
            if (widget.actionLabel != null && widget.onAction != null) ...[
              const SizedBox(height: MitumbaSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: MitumbaPrimaryButton(
                  label: widget.actionLabel!,
                  onPressed: widget.onAction!,
                  variant: ButtonVariant.outline,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
