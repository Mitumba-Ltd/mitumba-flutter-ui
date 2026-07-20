import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

class FloatingChatDock extends StatelessWidget {
  const FloatingChatDock({
    super.key,
    required this.open,
    required this.title,
    this.subtitle,
    this.avatarUrl,
    required this.minimized,
    required this.onToggleMinimize,
    required this.onClose,
    this.unreadCount = 0,
    this.onBack,
    required this.children,
  });

  final bool open;
  final String title;
  final String? subtitle;
  final String? avatarUrl;
  final bool minimized;
  final VoidCallback onToggleMinimize;
  final VoidCallback onClose;
  final int unreadCount;
  final VoidCallback? onBack;
  final Widget children;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    if (!open || isMobile) {
      return const SizedBox.shrink();
    }

    const double dockWidth = 360.0;
    const double dockHeight = 520.0;

    return Positioned(
      bottom: MitumbaSpacing.lg,
      right: MitumbaSpacing.lg,
      child: Material(
        type: MaterialType.transparency,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: dockWidth,
          height: minimized ? 62.0 : dockHeight,
          decoration: BoxDecoration(
            color: MitumbaColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(MitumbaRadius.xl),
              topRight: Radius.circular(MitumbaRadius.xl),
              bottomLeft: Radius.circular(minimized ? MitumbaRadius.xl : 0),
              bottomRight: Radius.circular(minimized ? MitumbaRadius.xl : 0),
            ),
            border: Border.all(color: MitumbaColors.divider),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 16.0,
                offset: Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // Header
              GestureDetector(
                onTap: minimized ? onToggleMinimize : null,
                child: Container(
                  height: 60.0,
                  color: MitumbaColors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: MitumbaSpacing.base,
                    vertical: MitumbaSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      if (onBack != null) ...[
                        IconButton(
                          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 20.0),
                          onPressed: onBack,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          splashRadius: 20.0,
                        ),
                        const SizedBox(width: MitumbaSpacing.xs),
                      ],
                      
                      // Avatar with badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 16.0,
                            backgroundColor: Colors.white24,
                            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                            child: avatarUrl == null
                                ? Text(
                                    title.isNotEmpty ? title[0].toUpperCase() : '?',
                                    style: const TextStyle(
                                      fontFamily: 'Nunito',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  )
                                : null,
                          ),
                          if (minimized && unreadCount > 0)
                            Positioned(
                              top: -4.0,
                              right: -4.0,
                              child: Container(
                                padding: const EdgeInsets.all(2.0),
                                decoration: const BoxDecoration(
                                  color: MitumbaColors.error,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16.0,
                                  minHeight: 16.0,
                                ),
                                child: Center(
                                  child: Text(
                                    '$unreadCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: MitumbaSpacing.sm),
                      
                      // Title & Subtitle
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            if (subtitle != null)
                              Text(
                                subtitle!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 11.0,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                          ],
                        ),
                      ),
                      
                      // Actions
                      IconButton(
                        icon: Icon(
                          minimized ? Icons.open_in_full : Icons.remove,
                          color: Colors.white,
                          size: 16.0,
                        ),
                        onPressed: onToggleMinimize,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        splashRadius: 20.0,
                      ),
                      const SizedBox(width: MitumbaSpacing.sm),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18.0,
                        ),
                        onPressed: onClose,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        splashRadius: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
              
              // Body (expanded)
              if (!minimized)
                Expanded(
                  child: children,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
