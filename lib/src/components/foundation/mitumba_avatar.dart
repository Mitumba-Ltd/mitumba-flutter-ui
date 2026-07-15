import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

enum MitumbaAvatarSize { xs, sm, md, lg, xl }

enum MitumbaAvatarStatus { online, offline }

enum MitumbaAvatarTextAlignment { side, bottom }

/// A premium, living avatar component with status indicators, badges, and concentric rings.
class MitumbaAvatar extends StatelessWidget {
  const MitumbaAvatar({
    super.key,
    this.name,
    this.imageUrl,
    this.size = MitumbaAvatarSize.md,
    this.badge,
    this.status,
    this.actionIcon,
    this.notificationCount,
    this.notificationColor,
    this.subtitle,
    this.textAlignment,
    this.hasNewEvent = false,
    this.progress,
    this.selected = false,
    this.isStacked = false,
    this.isCTA = false,
    this.overflowCount,
    this.onClick,
  });

  /// Display name for initials fallback.
  final String? name;

  /// URL of the profile image.
  final String? imageUrl;

  /// Size of the avatar: xs(24), sm(32), md(44), lg(64), xl(80).
  final MitumbaAvatarSize size;

  /// Optional element rendered as a badge on the bottom-right corner.
  final Widget? badge;

  /// Presence status dot (bottom-right).
  final MitumbaAvatarStatus? status;

  /// Action icon overlay (bottom-right). Overrides status if both provided.
  final Widget? actionIcon;

  /// Numeric/text notification badge (top-right).
  final dynamic notificationCount;

  /// Custom color for notification badge. Defaults to error red.
  final Color? notificationColor;

  /// Supporting text for side-alignment metadata.
  final String? subtitle;

  /// Alignment of name/subtitle text.
  final MitumbaAvatarTextAlignment? textAlignment;

  /// Trigger the "new event" spinning border animation.
  final bool hasNewEvent;

  /// Progress percentage (0 to 100) for concentric progress stroke.
  final double? progress;

  /// Show selected state with tick icon at bottom-right.
  final bool selected;

  /// Internal prop for stacked styling (e.g. border outline).
  final bool isStacked;

  /// Internal prop for stacked CTA button.
  final bool isCTA;

  /// Internal prop for numeric overflow circle.
  final int? overflowCount;

  /// Called when the avatar/content is clicked.
  final VoidCallback? onClick;

  static const Map<MitumbaAvatarSize, double> _sizeMap = {
    MitumbaAvatarSize.xs: 24,
    MitumbaAvatarSize.sm: 32,
    MitumbaAvatarSize.md: 44,
    MitumbaAvatarSize.lg: 64,
    MitumbaAvatarSize.xl: 80,
  };

  static const Map<MitumbaAvatarSize, double> _fontSizeMap = {
    MitumbaAvatarSize.xs: 10,
    MitumbaAvatarSize.sm: 12,
    MitumbaAvatarSize.md: 16,
    MitumbaAvatarSize.lg: 20,
    MitumbaAvatarSize.xl: 24,
  };

  double get _dimension => _sizeMap[size]!;
  double get _fontSize => _fontSizeMap[size]!;

  String get _initials {
    if (name == null || name!.trim().isEmpty) return '';
    final words = name!.trim().split(RegExp(r'\s+'));
    if (words.length == 1) {
      return words[0].substring(0, words[0].length.clamp(0, 2)).toUpperCase();
    }
    return (words[0][0] + words[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    Widget avatarCircle;
    if (isCTA) {
      avatarCircle = Container(
        width: _dimension,
        height: _dimension,
        decoration: BoxDecoration(
          color: MitumbaColors.background,
          shape: BoxShape.circle,
          border: Border.all(
            color: MitumbaColors.border,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Center(
          child: actionIcon ?? const Icon(Icons.add, color: MitumbaColors.textSecondary),
        ),
      );
    } else if (overflowCount != null) {
      avatarCircle = Container(
        width: _dimension,
        height: _dimension,
        decoration: BoxDecoration(
          color: MitumbaColors.divider,
          shape: BoxShape.circle,
          border: Border.all(color: MitumbaColors.surface, width: 2),
        ),
        child: Center(
          child: Text(
            '+$overflowCount',
            style: TextStyle(
              fontSize: _fontSize,
              fontWeight: FontWeight.bold,
              color: MitumbaColors.textPrimary,
            ),
          ),
        ),
      );
    } else {
      avatarCircle = Container(
        width: _dimension,
        height: _dimension,
        decoration: BoxDecoration(
          color: MitumbaColors.divider,
          shape: BoxShape.circle,
          border: isStacked ? Border.all(color: MitumbaColors.surface, width: 2) : null,
          image: imageUrl != null
              ? DecorationImage(
                  image: NetworkImage(imageUrl!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: imageUrl == null
            ? Center(
                child: Text(
                  _initials.isNotEmpty ? _initials : '?',
                  style: TextStyle(
                    fontSize: _fontSize,
                    fontWeight: FontWeight.bold,
                    color: MitumbaColors.textSecondary,
                  ),
                ),
              )
            : null,
      );
    }

    if (onClick != null) {
      avatarCircle = GestureDetector(
        onTap: onClick,
        behavior: HitTestBehavior.opaque,
        child: avatarCircle,
      );
    }

    return avatarCircle;
  }
}
