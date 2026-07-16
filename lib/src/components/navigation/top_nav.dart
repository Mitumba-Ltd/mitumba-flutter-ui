import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../foundation/mitumba_avatar.dart';
import '../foundation/mitumba_primary_button.dart';

/// Navigation link model for [TopNav].
class TopNavLink {
  const TopNavLink({
    required this.label,
    required this.href,
    this.active = false,
  });

  /// The link label.
  final String label;

  /// The target destination or identifier.
  final String href;

  /// Whether the link is currently active.
  final bool active;
}

/// User details model for [TopNav].
class TopNavUser {
  const TopNavUser({
    required this.name,
    this.avatarUrl,
  });

  final String name;
  final String? avatarUrl;
}

/// A premium, living TopNav header app bar.
class TopNav extends StatelessWidget implements PreferredSizeWidget {
  const TopNav({
    super.key,
    this.announcement,
    this.logo,
    this.links = const [],
    this.actions,
    this.cta,
    this.sticky = true,
    this.transparent = false,
    this.searchValue = '',
    this.onSearchChange,
    this.onSearchSubmit,
    this.user,
    this.isAuthenticated = false,
    this.onLogoClick,
    this.onAuthClick,
    this.onProfileClick,
    this.onCartClick,
    this.cartCount = 0,
    this.toolbarHeight = 80.0,
  });

  /// Optional announcement bar content. If provided, renders a green banner above the main nav.
  final Widget? announcement;

  /// Main logo element. If null, renders standard brand text "MITUMBA".
  final Widget? logo;

  /// Navigation links list.
  final List<TopNavLink> links;

  /// Right-side action elements (Icons, Buttons).
  final Widget? actions;

  /// Main CTA button (e.g., "Start Free Trial").
  final Widget? cta;

  /// Whether the nav is sticky. Defaults to true.
  final bool sticky;

  /// Whether the background is transparent.
  final bool transparent;

  /// Current search input value.
  final String searchValue;

  /// Search change handler.
  final ValueChanged<String>? onSearchChange;

  /// Search submit handler.
  final ValueChanged<String>? onSearchSubmit;

  /// User object for profile display.
  final TopNavUser? user;

  /// Authentication status.
  final bool isAuthenticated;

  /// Logo tap handler.
  final VoidCallback? onLogoClick;

  /// Authentication tap handler.
  final VoidCallback? onAuthClick;

  /// Profile avatar tap handler.
  final VoidCallback? onProfileClick;

  /// Cart button tap handler.
  final VoidCallback? onCartClick;

  /// Cart item count.
  final int cartCount;

  /// Main toolbar height. Defaults to 80.0.
  final double toolbarHeight;

  @override
  Size get preferredSize => Size.fromHeight(
        toolbarHeight + (announcement != null ? 32.0 : 0.0),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: transparent ? Colors.transparent : MitumbaColors.surface,
      child: Column(
        children: [
          // Announcement Bar
          if (announcement != null)
            Container(
              height: 32,
              width: double.infinity,
              color: MitumbaColors.green,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: MitumbaSpacing.base),
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontFamily: MitumbaTypography.fontFamily,
                  color: MitumbaColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                child: announcement!,
              ),
            ),

          // Main Toolbar
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: MitumbaSpacing.lg),
              child: Row(
                children: [
                  // Logo
                  GestureDetector(
                    onTap: onLogoClick,
                    child: logo ??
                        const Text(
                          'MITUMBA',
                          style: TextStyle(
                            fontFamily: MitumbaTypography.fontFamily,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: MitumbaColors.green,
                            letterSpacing: -0.5,
                          ),
                        ),
                  ),

                  // Spacer & Desktop Links
                  const Spacer(),
                  if (links.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: links.map((link) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: MitumbaSpacing.base),
                          child: _TopNavLinkWidget(link: link),
                        );
                      }).toList(),
                    ),

                  // Search Bar Area
                  if (onSearchSubmit != null) ...[
                    const Spacer(),
                    Container(
                      width: 240,
                      height: 40,
                      decoration: BoxDecoration(
                        color: MitumbaColors.background,
                        borderRadius: BorderRadius.circular(MitumbaRadius.md),
                        border: Border.all(color: MitumbaColors.divider),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: MitumbaSpacing.sm),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            size: 18,
                            color: MitumbaColors.textSecondary,
                          ),
                          const SizedBox(width: MitumbaSpacing.xs),
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(text: searchValue)
                                ..selection = TextSelection.fromPosition(
                                  TextPosition(offset: searchValue.length),
                                ),
                              onChanged: onSearchChange,
                              onSubmitted: onSearchSubmit,
                              style: const TextStyle(
                                fontFamily: MitumbaTypography.fontFamily,
                                fontSize: MitumbaTypography.fontSizeSm,
                                color: MitumbaColors.textPrimary,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Search listings...',
                                hintStyle: TextStyle(
                                  fontFamily: MitumbaTypography.fontFamily,
                                  fontSize: MitumbaTypography.fontSizeSm,
                                  color: MitumbaColors.textDisabled,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const Spacer(),

                  // Actions Section
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (actions != null) ...[
                        actions!,
                        const SizedBox(width: MitumbaSpacing.xs),
                      ],

                      // Shopping Cart
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.shopping_cart_outlined,
                              color: MitumbaColors.textPrimary,
                            ),
                            onPressed: onCartClick,
                          ),
                          if (cartCount > 0)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                decoration: const BoxDecoration(
                                  color: MitumbaColors.error,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '$cartCount',
                                  style: const TextStyle(
                                    fontFamily: MitumbaTypography.fontFamily,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: MitumbaColors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: MitumbaSpacing.xs),

                      // User Auth Profile Avatar
                      if (isAuthenticated && user != null)
                        GestureDetector(
                          onTap: onProfileClick,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: MitumbaAvatar(
                              name: user!.name,
                              imageUrl: user!.avatarUrl,
                              size: MitumbaAvatarSize.sm,
                            ),
                          ),
                        )
                      else
                        MitumbaPrimaryButton(
                          label: 'Sign In',
                          variant: ButtonVariant.ghost,
                          onPressed: onAuthClick ?? () {},
                          size: ButtonSize.small,
                        ),

                      if (cta != null) ...[
                        const SizedBox(width: MitumbaSpacing.base),
                        cta!,
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (!transparent)
            const Divider(
              height: 1,
              thickness: 1,
              color: MitumbaColors.divider,
            ),
        ],
      ),
    );
  }
}

class _TopNavLinkWidget extends StatefulWidget {
  const _TopNavLinkWidget({required this.link});
  final TopNavLink link;

  @override
  State<_TopNavLinkWidget> createState() => _TopNavLinkWidgetState();
}

class _TopNavLinkWidgetState extends State<_TopNavLinkWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final link = widget.link;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          // If in real app navigation, route to link.href
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered ? -1.0 : 0.0),
          child: Text(
            link.label,
            style: TextStyle(
              fontFamily: MitumbaTypography.fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: link.active || _isHovered ? MitumbaColors.green : MitumbaColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
