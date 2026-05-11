import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/coupons/logic/cubit.dart';
import 'package:real_ecommerce/features/coupons/logic/states.dart';
import 'package:real_ecommerce/features/coupons/view/coupon_card.dart';

class ProfileCouponSection extends StatelessWidget {
  final bool isLoggedIn;
  final VoidCallback onShowLoginDialog;

  const ProfileCouponSection({
    super.key,
    required this.isLoggedIn,
    required this.onShowLoginDialog,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Coupons', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Active coupons from the backend are shown here so you can apply them to your next order.',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          BlocBuilder<CouponCubit, CouponState>(
            builder: (context, state) {
              if (state is CouponLoading || state is CouponInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is CouponError) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Unable to load coupons', style: AppTypography.labelLarge),
                    const SizedBox(height: AppSpacing.sm),
                    Text(state.message, style: AppTypography.bodySmall),
                  ],
                );
              }

              if (state is CouponLoaded && state.coupons.isNotEmpty) {
                final coupons = state.coupons.take(3).toList();
                return Column(
                  children: [
                    for (final coupon in coupons) ActiveCouponCard(coupon: coupon),
                    if (state.coupons.length > 3)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => context.push(AppRoutes.offers),
                          child: const Text('View all coupons'),
                        ),
                      ),
                  ],
                );
              }

              return Text('No active coupons found.', style: AppTypography.bodyMedium);
            },
          ),
        ],
      ),
    );
  }
}
