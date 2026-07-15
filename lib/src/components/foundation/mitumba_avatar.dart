import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';

enum MitumbaAvatarSize { xs, sm, md, lg, xl }

enum MitumbaAvatarStatus { online, offline }

enum MitumbaAvatarTextAlignment { side, bottom }

/// A premium, living avatar component with status indicators, badges, and concentric rings.
class MitumbaAvatar extends StatefulWidget {
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

  @override
  State<MitumbaAvatar> createState() => _MitumbaAvatarState();
}

class _MitumbaAvatarState extends State<MitumbaAvatar> with TickerProviderStateMixin {
  late AnimationController _spinController;
  late AnimationController _solidifyController;
  late AnimationController _progressController;

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

  double get _dimension => _sizeMap[widget.size]!;
  double get _fontSize => _fontSizeMap[widget.size]!;

  String get _initials {
    if (widget.name == null || widget.name!.trim().isEmpty) return '';
    final words = widget.name!.trim().split(RegExp(r'\s+'));
    if (words.length == 1) {
      return words[0].substring(0, words[0].length.clamp(0, 2)).toUpperCase();
    }
    return (words[0][0] + words[1][0]).toUpperCase();
  }

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _solidifyController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _updateAnimationState();
  }

  @override
  void didUpdateWidget(covariant MitumbaAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateAnimationState();
  }

  void _updateAnimationState() {
    if (widget.hasNewEvent) {
      if (!_spinController.isAnimating) {
        _spinController.repeat();
      }
      _solidifyController.forward();
    } else {
      _spinController.stop();
      _solidifyController.reset();
    }

    if (widget.progress != null) {
      _progressController.animateTo(widget.progress! / 100.0, curve: Curves.easeOutCubic);
    } else {
      _progressController.reset();
    }
  }

  @override
  void dispose() {
    _spinController.dispose();
    _solidifyController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasBorderDecorator = widget.hasNewEvent || widget.progress != null;

    Widget avatarCircle;
    if (widget.isCTA) {
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
          child: widget.actionIcon ?? const Icon(Icons.add, color: MitumbaColors.textSecondary),
        ),
      );
    } else if (widget.overflowCount != null) {
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
            '+${widget.overflowCount}',
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
          border: widget.isStacked ? Border.all(color: MitumbaColors.surface, width: 2) : null,
          image: widget.imageUrl != null
              ? DecorationImage(
                  image: NetworkImage(widget.imageUrl!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: widget.imageUrl == null
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

    if (widget.onClick != null) {
      avatarCircle = GestureDetector(
        onTap: widget.onClick,
        behavior: HitTestBehavior.opaque,
        child: avatarCircle,
      );
    }

    if (hasBorderDecorator) {
      avatarCircle = AnimatedBuilder(
        animation: Listenable.merge([_spinController, _solidifyController, _progressController]),
        builder: (context, child) {
          return CustomPaint(
            painter: _ConcentricRingPainter(
              progress: widget.progress != null ? _progressController.value * 100 : null,
              hasNewEvent: widget.hasNewEvent,
              color: MitumbaColors.green,
              trackColor: MitumbaColors.divider,
              rotationAngle: _spinController.value * 2 * math.pi,
              solidifyProgress: _solidifyController.value,
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0), // give space for the ring
              child: child,
            ),
          );
        },
        child: avatarCircle,
      );
    }

    final List<Widget> stackChildren = [avatarCircle];

    // 1. Notification count (top right)
    if (widget.notificationCount != null) {
      stackChildren.add(
        Positioned(
          top: -2,
          right: -2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            constraints: const BoxConstraints(
              minWidth: 18,
              minHeight: 18,
            ),
            decoration: BoxDecoration(
              color: widget.notificationColor ?? MitumbaColors.error,
              shape: BoxShape.circle,
              border: Border.all(color: MitumbaColors.surface, width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              '${widget.notificationCount}',
              style: const TextStyle(
                color: MitumbaColors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    // 2. Selected tick (bottom right)
    if (widget.selected) {
      final double tickSize = math.max(16.0, _dimension * 0.35);
      stackChildren.add(
        Positioned(
          bottom: -2,
          right: -2,
          child: Container(
            width: tickSize,
            height: tickSize,
            decoration: BoxDecoration(
              color: MitumbaColors.green,
              shape: BoxShape.circle,
              border: Border.all(color: MitumbaColors.surface, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.check,
              size: tickSize * 0.7,
              color: MitumbaColors.white,
            ),
          ),
        ),
      );
    } 
    // 3. Action icon (bottom right)
    else if (widget.actionIcon != null) {
      final double iconSize = math.max(24.0, _dimension * 0.4);
      stackChildren.add(
        Positioned(
          bottom: -2,
          right: -2,
          child: Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: MitumbaColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: MitumbaColors.divider),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            alignment: Alignment.center,
            child: IconTheme(
              data: IconThemeData(size: iconSize * 0.5, color: MitumbaColors.textPrimary),
              child: widget.actionIcon!,
            ),
          ),
        ),
      );
    }
    // 4. Status dot (bottom right)
    else if (widget.status != null) {
      final double dotSize = math.max(10.0, _dimension * 0.25);
      stackChildren.add(
        Positioned(
          bottom: 2,
          right: 2,
          child: Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: widget.status == MitumbaAvatarStatus.online ? MitumbaColors.success : MitumbaColors.textDisabled,
              shape: BoxShape.circle,
              border: Border.all(color: MitumbaColors.surface, width: 2),
            ),
          ),
        ),
      );
    }
    // 5. Custom badge (bottom right)
    else if (widget.badge != null) {
      final double badgeSize = math.max(20.0, _dimension * 0.4);
      stackChildren.add(
        Positioned(
          bottom: -2,
          right: -2,
          child: Container(
            width: badgeSize,
            height: badgeSize,
            decoration: BoxDecoration(
              color: MitumbaColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: MitumbaColors.divider),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            alignment: Alignment.center,
            child: widget.badge!,
          ),
        ),
      );
    }

    final Widget mainAvatar = Stack(
      clipBehavior: Clip.none,
      children: stackChildren,
    );

    final hasText = (widget.name != null || widget.subtitle != null || widget.progress != null) && widget.textAlignment != null;
    if (hasText) {
      final textChildren = <Widget>[];
      if (widget.name != null) {
        textChildren.add(
          Text(
            widget.name!,
            style: MitumbaTypography.body1.copyWith(
              fontWeight: FontWeight.bold,
              color: MitumbaColors.textPrimary,
              height: 1.1,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }

      final showSubtitle = widget.subtitle != null || (widget.progress != null && widget.textAlignment == MitumbaAvatarTextAlignment.bottom);
      if (showSubtitle) {
        final text = (widget.progress != null && widget.textAlignment == MitumbaAvatarTextAlignment.bottom)
            ? '${widget.progress!.toInt()}% complete'
            : (widget.subtitle ?? '');
        final isOnlineSide = widget.status == MitumbaAvatarStatus.online && widget.textAlignment == MitumbaAvatarTextAlignment.side;
        textChildren.add(
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              text,
              style: MitumbaTypography.body2.copyWith(
                color: isOnlineSide ? MitumbaColors.success : MitumbaColors.textSecondary,
                fontWeight: isOnlineSide ? FontWeight.bold : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      }

      final textBlock = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: widget.textAlignment == MitumbaAvatarTextAlignment.bottom
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: textChildren,
      );

      if (widget.textAlignment == MitumbaAvatarTextAlignment.bottom) {
        return GestureDetector(
          onTap: widget.onClick,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              mainAvatar,
              const SizedBox(height: 6),
              textBlock,
            ],
          ),
        );
      } else {
        return GestureDetector(
          onTap: widget.onClick,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              mainAvatar,
              const SizedBox(width: 8),
              textBlock,
            ],
          ),
        );
      }
    }

    return mainAvatar;
  }
}

class _ConcentricRingPainter extends CustomPainter {
  _ConcentricRingPainter({
    required this.progress,
    required this.hasNewEvent,
    required this.color,
    required this.trackColor,
    required this.rotationAngle,
    required this.solidifyProgress,
  });

  final double? progress;
  final bool hasNewEvent;
  final Color color;
  final Color trackColor;
  final double rotationAngle;
  final double solidifyProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 3) / 2; // leave margin for stroke width

    // Draw Track
    final trackPaint = Paint()
      ..color = trackColor.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, radius, trackPaint);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    if (progress != null) {
      // Draw progress arc (starting from -90 degrees, i.e., top)
      final rect = Rect.fromCircle(center: center, radius: radius);
      const startAngle = -math.pi / 2;
      final sweepAngle = (progress! / 100.0) * 2 * math.pi;
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
    } else if (hasNewEvent) {
      // Draw a spinning dashed/solidifying circle
      final rect = Rect.fromCircle(center: center, radius: radius);
      const int numDashes = 8;
      
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(rotationAngle);
      canvas.translate(-center.dx, -center.dy);

      const double baseDashAngle = (2 * math.pi) / numDashes;
      final double dashRatio = 0.15 + 0.85 * solidifyProgress;
      final double activeSweep = baseDashAngle * dashRatio;

      for (int i = 0; i < numDashes; i++) {
        final double start = i * baseDashAngle;
        canvas.drawArc(rect, start, activeSweep, false, paint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConcentricRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.hasNewEvent != hasNewEvent ||
        oldDelegate.color != color ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.rotationAngle != rotationAngle ||
        oldDelegate.solidifyProgress != solidifyProgress;
  }
}

enum MitumbaAvatarOverlap { tight, standard, relaxed }

/// A container that lays out a list of MitumbaAvatar widgets in a stacked horizontal arrangement with overlap.
class MitumbaAvatarGroup extends StatelessWidget {
  const MitumbaAvatarGroup({
    super.key,
    required this.children,
    this.max = 5,
    this.total,
    this.size = MitumbaAvatarSize.md,
    this.overlap = MitumbaAvatarOverlap.relaxed,
    this.onAdd,
  });

  /// Collection of MitumbaAvatar widgets.
  final List<MitumbaAvatar> children;

  /// Maximum number of avatars to display before adding overflow. Defaults to 5.
  final int max;

  /// Manual total count if different from children.length.
  final int? total;

  /// Size for all avatars in the group.
  final MitumbaAvatarSize size;

  /// How much the avatars should overlap. Defaults to 'relaxed' (least overlap).
  final MitumbaAvatarOverlap overlap;

  /// Adds a CTA '+' button at the end of the stack and triggers this callback when clicked.
  final VoidCallback? onAdd;

  static const Map<MitumbaAvatarOverlap, double> _overlapFactorMap = {
    MitumbaAvatarOverlap.tight: 0.5,
    MitumbaAvatarOverlap.standard: 0.35,
    MitumbaAvatarOverlap.relaxed: 0.2,
  };

  @override
  Widget build(BuildContext context) {
    final showCount = math.min(children.length, max);
    final totalCount = total ?? children.length;
    final overflow = totalCount - showCount;

    final double overlapFactor = _overlapFactorMap[overlap]!;
    final List<Widget> items = [];

    for (int i = 0; i < showCount; i++) {
      final isLastItem = (i == showCount - 1) && (overflow <= 0) && (onAdd == null);
      final child = children[i];

      final stackedChild = MitumbaAvatar(
        key: child.key,
        name: child.name,
        imageUrl: child.imageUrl,
        size: size,
        badge: child.badge,
        status: child.status,
        actionIcon: child.actionIcon,
        notificationCount: child.notificationCount,
        notificationColor: child.notificationColor,
        subtitle: child.subtitle,
        textAlignment: child.textAlignment,
        hasNewEvent: child.hasNewEvent,
        progress: child.progress,
        selected: child.selected,
        isStacked: true,
        isCTA: child.isCTA,
        overflowCount: child.overflowCount,
        onClick: child.onClick,
      );

      if (isLastItem) {
        items.add(stackedChild);
      } else {
        items.add(
          Align(
            widthFactor: 1.0 - overlapFactor,
            alignment: Alignment.centerLeft,
            child: stackedChild,
          ),
        );
      }
    }

    if (overflow > 0) {
      final isLastItem = (onAdd == null);
      final overflowWidget = MitumbaAvatar(
        size: size,
        overflowCount: overflow,
        isStacked: true,
      );

      if (isLastItem) {
        items.add(overflowWidget);
      } else {
        items.add(
          Align(
            widthFactor: 1.0 - overlapFactor,
            alignment: Alignment.centerLeft,
            child: overflowWidget,
          ),
        );
      }
    }

    if (onAdd != null) {
      items.add(
        MitumbaAvatar(
          size: size,
          isCTA: true,
          onClick: onAdd,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: items,
    );
  }
}
