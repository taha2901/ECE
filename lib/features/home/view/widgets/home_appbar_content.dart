import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/auth/logic/cubit.dart';
import 'package:real_ecommerce/features/auth/logic/states.dart';

class HomeAppBarContent extends StatelessWidget {
  const HomeAppBarContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final user = authState.authData?.user;
        final name = user != null && user.firstName.isNotEmpty
            ? '${user.firstName} ${user.lastName}'.trim()
            : 'Guest User';
        final subtitle = user != null ? 'Good morning 👋' : 'Welcome 👋';

        return Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
                boxShadow: AppColors.cardShadow,
              ),
              alignment: Alignment.center,
              child: Text(
                _avatarInitials(name),
                style: AppTypography.h3.copyWith(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textHint,
                      fontSize: 11,
                      letterSpacing: 0.2,
                    ),
                  ),
                  Text(
                    name,
                    style: AppTypography.h3.copyWith(fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            _AppBarIconBtn(
              icon: Icons.notifications_outlined,
              badgeCount: 3,
              onTap: () {},
            ),
            _AppBarIconBtn(
              icon: Icons.shopping_bag_outlined,
              badgeCount: 2,
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  String _avatarInitials(String fullName) {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }
}

class _AppBarIconBtn extends StatelessWidget {
  final IconData icon;
  final int badgeCount;
  final VoidCallback onTap;

  const _AppBarIconBtn({
    required this.icon,
    required this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(13),
              boxShadow: AppColors.cardShadow,
            ),
            child: Icon(icon, size: 20, color: AppColors.textPrimary),
          ),
          if (badgeCount > 0)
            Positioned(
              right: 4,
              top: 4,
              child: Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    badgeCount > 9 ? '9+' : '$badgeCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
