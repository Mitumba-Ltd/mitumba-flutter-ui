import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Visual variant for [MobileBottomNav].
enum BottomNavVariant { indicator, m3, expansive, bubble, pill, pillHorizontal }

/// A single navigation item for [MobileBottomNav].
class MobileBottomNavItem {
  /// Creates a navigation item.
  const MobileBottomNavItem({
    required this.id,
    required this.label,
    required this.icon,
    this.activeIcon,
  });

  /// Unique tab identifier.
  final String id;

  /// Tab label.
  final String label;

  /// Icon shown when inactive.
  final IconData icon;

  /// Icon shown when active (falls back to [icon]).
  final IconData? activeIcon;
}

/// Default navigation items for the Mitumba marketplace.
const defaultNavItems = [
  MobileBottomNavItem(id: 'home', label: 'Home', icon: Icons.home_outlined, activeIcon: Icons.home),
  MobileBottomNavItem(id: 'search', label: 'Search', icon: Icons.search),
  MobileBottomNavItem(id: 'vazi', label: 'VAZI', icon: Icons.auto_awesome_outlined, activeIcon: Icons.auto_awesome),
  MobileBottomNavItem(id: 'orders', label: 'Orders', icon: Icons.local_mall_outlined, activeIcon: Icons.local_mall),
  MobileBottomNavItem(id: 'profile', label: 'Profile', icon: Icons.person_outlined, activeIcon: Icons.person),
];

/// Mobile bottom navigation with 6 visual variants.
///
/// Mirrors the web `MobileBottomNav` from `@mitumba/ui`.
///
/// ```dart
/// MobileBottomNav(
///   activeTab: 'home',
///   onTabChange: (id) => setState(() => _tab = id),
///   variant: BottomNavVariant.indicator,
/// )
/// ```
class MobileBottomNav extends StatelessWidget {
  /// Creates a mobile bottom navigation bar.
  const MobileBottomNav({
    super.key,
    required this.activeTab,
    required this.onTabChange,
    this.variant = BottomNavVariant.indicator,
    this.items = defaultNavItems,
  });

  /// Currently active tab ID.
  final String activeTab;

  /// Called when a tab is selected.
  final ValueChanged<String> onTabChange;

  /// Visual variant.
  final BottomNavVariant variant;

  /// Navigation items.
  final List<MobileBottomNavItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: MitumbaColors.surface,
        border: Border(top: BorderSide(color: MitumbaColors.divider)),
      ),
      padding: EdgeInsets.symmetric(horizontal: MitumbaSpacing.md),
      child: Row(
        children: items.map((item) {
          final isActive = item.id == activeTab;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTabChange(item.id),
              child: _buildItem(item, isActive),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildItem(MobileBottomNavItem item, bool isActive) {
    final iconData = isActive && item.activeIcon != null ? item.activeIcon! : item.icon;
    final activeColor = isActive ? MitumbaColors.green : MitumbaColors.textSecondary;

    switch (variant) {
      case BottomNavVariant.m3:
        return _M3Item(icon: iconData, label: item.label, isActive: isActive, color: activeColor);
      case BottomNavVariant.expansive:
        return _ExpansiveItem(icon: iconData, label: item.label, isActive: isActive);
      case BottomNavVariant.bubble:
        return _BubbleItem(icon: iconData, label: item.label, isActive: isActive, color: activeColor);
      case BottomNavVariant.pill:
        return _PillItem(icon: iconData, label: item.label, isActive: isActive, color: activeColor);
      case BottomNavVariant.pillHorizontal:
        return _PillHorizontalItem(icon: iconData, label: item.label, isActive: isActive, color: activeColor);
      case BottomNavVariant.indicator:
        return _IndicatorItem(icon: iconData, label: item.label, isActive: isActive, color: activeColor);
    }
  }
}

class _IndicatorItem extends StatelessWidget {
  const _IndicatorItem({required this.icon, required this.label, required this.isActive, required this.color});
  final IconData icon;
  final String label;
  final bool isActive;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: const Cubic(0.34, 1.56, 0.64, 1),
              width: isActive ? 32 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: MitumbaColors.green,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Icon(icon, size: 24, color: color),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(
          fontFamily: MitumbaTypography.fontFamily,
          fontSize: 10,
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          color: color,
        )),
      ],
    );
  }
}

class _M3Item extends StatelessWidget {
  const _M3Item({required this.icon, required this.label, required this.isActive, required this.color});
  final IconData icon;
  final String label;
  final bool isActive;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 56,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? MitumbaColors.green.withAlpha(24) : Colors.transparent,
            borderRadius: BorderRadius.circular(MitumbaRadius.full),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 22, color: color),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(
          fontFamily: MitumbaTypography.fontFamily,
          fontSize: 10,
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          color: color,
        )),
      ],
    );
  }
}

class _ExpansiveItem extends StatelessWidget {
  const _ExpansiveItem({required this.icon, required this.label, required this.isActive});
  final IconData icon;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.symmetric(vertical: MitumbaSpacing.sm, horizontal: MitumbaSpacing.md),
      decoration: BoxDecoration(
        color: isActive ? MitumbaColors.green : Colors.transparent,
        borderRadius: BorderRadius.circular(MitumbaRadius.lg),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: isActive ? MitumbaColors.white : MitumbaColors.textSecondary),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(
            fontFamily: MitumbaTypography.fontFamily,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: isActive ? MitumbaColors.white : MitumbaColors.textSecondary,
          )),
        ],
      ),
    );
  }
}

class _BubbleItem extends StatelessWidget {
  const _BubbleItem({required this.icon, required this.label, required this.isActive, required this.color});
  final IconData icon;
  final String label;
  final bool isActive;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? MitumbaColors.green.withAlpha(24) : Colors.transparent,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 22, color: color),
        ),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: EdgeInsets.symmetric(horizontal: MitumbaSpacing.sm, vertical: 2),
            decoration: BoxDecoration(
              color: MitumbaColors.green.withAlpha(18),
              borderRadius: BorderRadius.circular(MitumbaRadius.full),
            ),
            child: Text(label, style: TextStyle(
              fontFamily: MitumbaTypography.fontFamily,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: MitumbaColors.green,
            )),
          ),
      ],
    );
  }
}

class _PillItem extends StatelessWidget {
  const _PillItem({required this.icon, required this.label, required this.isActive, required this.color});
  final IconData icon;
  final String label;
  final bool isActive;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.symmetric(vertical: MitumbaSpacing.sm, horizontal: MitumbaSpacing.base),
      decoration: BoxDecoration(
        color: isActive ? MitumbaColors.green.withAlpha(20) : Colors.transparent,
        borderRadius: BorderRadius.circular(MitumbaRadius.xl),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(
            fontFamily: MitumbaTypography.fontFamily,
            fontSize: 10,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: color,
          )),
        ],
      ),
    );
  }
}

class _PillHorizontalItem extends StatelessWidget {
  const _PillHorizontalItem({required this.icon, required this.label, required this.isActive, required this.color});
  final IconData icon;
  final String label;
  final bool isActive;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(
        vertical: MitumbaSpacing.sm,
        horizontal: isActive ? MitumbaSpacing.lg : MitumbaSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isActive ? MitumbaColors.green.withAlpha(20) : Colors.transparent,
        borderRadius: BorderRadius.circular(MitumbaRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: color),
          if (isActive) ...[
            SizedBox(width: MitumbaSpacing.xs),
            Text(label, style: TextStyle(
              fontFamily: MitumbaTypography.fontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: MitumbaColors.green,
            )),
          ],
        ],
      ),
    );
  }
}
