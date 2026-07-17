import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/shadows.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../foundation/mitumba_avatar.dart';

/// StoreCard - clickable store selector card for the seller dashboard.
/// Shows initials fallback avatar, name, subtitle, and trailing chevron icon.
class StoreCard extends StatefulWidget {
  const StoreCard({
    super.key,
    required this.name,
    this.avatarUrl,
    this.subtitle,
    this.onClick,
  });

  /// Name of the store.
  final String name;

  /// Optional URL to store avatar.
  final String? avatarUrl;

  /// Optional subtitle shown below name.
  final String? subtitle;

  /// Optional tap callback. If provided, card hover animations are enabled.
  final VoidCallback? onClick;

  @override
  State<StoreCard> createState() => _StoreCardState();
}

class _StoreCardState extends State<StoreCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final hasClick = widget.onClick != null;

    final decoration = BoxDecoration(
      color: MitumbaColors.surface,
      borderRadius: BorderRadius.circular(MitumbaRadius.lg),
      border: Border.all(
        color: _isHovered && hasClick
            ? MitumbaColors.green
            : MitumbaColors.divider,
      ),
      boxShadow: _isHovered && hasClick
          ? MitumbaShadows.elevated
          : MitumbaShadows.card,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: hasClick ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onClick,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered && hasClick ? -2.0 : 0.0),
          padding: const EdgeInsets.all(MitumbaSpacing.lg),
          decoration: decoration,
          child: Row(
            children: [
              // Avatar
              MitumbaAvatar(
                name: widget.name,
                imageUrl: widget.avatarUrl,
                size: MitumbaAvatarSize.md,
              ),
              const SizedBox(width: MitumbaSpacing.base),

              // Info details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: MitumbaTypography.fontSizeBase,
                        fontWeight: FontWeight.w700,
                        color: MitumbaColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        widget.subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: MitumbaTypography.fontSizeXs,
                          color: MitumbaColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Trailing chevron
              if (hasClick)
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: MitumbaColors.textDisabled,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
