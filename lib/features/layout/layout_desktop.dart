import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/helpers/responsive.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';

// ══════════════════════════════════════════════════════════
//  DESKTOP LAYOUT  —  permanent side navigation
// ══════════════════════════════════════════════════════════

class LayoutDesktop extends StatelessWidget {
  final List<Widget> screens;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const LayoutDesktop({
    super.key,
    required this.screens,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // ── Side Navigation ──────────────────────────────
          _DesktopSideNav(
            selectedIndex: selectedIndex,
            onTap: onTap,
          ),

          // ── Content Area ─────────────────────────────────
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: screens,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  SIDE NAVIGATION
// ══════════════════════════════════════════════════════════

class _DesktopSideNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _DesktopSideNav({
    required this.selectedIndex,
    required this.onTap,
  });

  static const _items = [
    _NavItem(icon: Icons.home_rounded,         inactiveIcon: Icons.home_outlined,           label: 'Home'),
    _NavItem(icon: Icons.shopping_bag_rounded,  inactiveIcon: Icons.shopping_bag_outlined,   label: 'Cart'),
    _NavItem(icon: Icons.favorite_rounded,      inactiveIcon: Icons.favorite_outline_rounded, label: 'Wishlist'),
    _NavItem(icon: Icons.person_rounded,        inactiveIcon: Icons.person_outline_rounded,   label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.sideNavWidth,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Logo / Brand ──────────────────────────────
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: AppColors.accentGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.shopping_bag_rounded,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Text(
                  'ShopApp',
                  style: AppTypography.h3.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // ── Nav Items ─────────────────────────────────
          ...List.generate(_items.length, (i) {
            final item = _items[i];
            final isSelected = selectedIndex == i;
            return _SideNavItem(
              item: item,
              isSelected: isSelected,
              onTap: () => onTap(i),
            );
          }),

          const Spacer(),

          // ── Settings link ─────────────────────────────
          _SideNavItem(
            item: const _NavItem(
              icon: Icons.settings_rounded,
              inactiveIcon: Icons.settings_outlined,
              label: 'Settings',
            ),
            isSelected: false,
            onTap: () {},
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SideNavItem extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _SideNavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.accent.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? item.icon : item.inactiveIcon,
                size: 20,
                color: isSelected ? AppColors.accent : AppColors.textHint,
              ),
              const SizedBox(width: 12),
              Text(
                item.label,
                style: AppTypography.labelMedium.copyWith(
                  color: isSelected ? AppColors.accent : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              if (isSelected) ...[
                const Spacer(),
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData inactiveIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.inactiveIcon,
    required this.label,
  });
}