import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/coupons/logic/cubit.dart';
import 'package:real_ecommerce/features/coupons/logic/states.dart';
import 'package:real_ecommerce/features/coupons/view/coupon_card.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/common_widgets.dart';

// ═══════════════════════════════════════════════
// OFFERS & COUPONS SCREEN
// ═══════════════════════════════════════════════
class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Coupons'),
      ),
      body: const CouponsTab(),
    );
  }
}

// ─── Coupons Tab ───────────────────────────────
class FlashSalesTab extends StatelessWidget {
  const FlashSalesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      children: [
        // Active flash sale banner
        Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            gradient: AppColors.accentGradient,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: AppColors.accentShadow,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.bolt_rounded, color: AppColors.white, size: 16),
                        Text(
                          ' Flash Sale',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Up to 70% OFF',
                      style: AppTypography.h1.copyWith(color: AppColors.white),
                    ),
                    Text(
                      'Ends in 06:24:38',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.local_fire_department_rounded,
                size: 64,
                color: Colors.white24,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.lg,
            crossAxisSpacing: AppSpacing.lg,
            childAspectRatio: 0.72,
          ),
          itemCount: 6,
          itemBuilder: (_, i) => const _FlashProductCard(),
        ),
      ],
    );
  }
}

class _FlashProductCard extends StatelessWidget {
  const _FlashProductCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.xl),
                    topRight: Radius.circular(AppRadius.xl),
                  ),
                  child: Container(
                    width: double.infinity,
                    color: AppColors.surfaceVariant,
                    child: const Icon(Icons.image_outlined, size: 44, color: AppColors.textHint),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: AppBadge(
                    label: '-70%',
                    backgroundColor: AppColors.accent,
                    textColor: AppColors.white,
                    isSmall: true,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(AppRadius.xl),
                        bottomRight: Radius.circular(AppRadius.xl),
                      ),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: 0.65,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.accentGradient,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product Name',
                  style: AppTypography.labelLarge.copyWith(fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('\$29', style: AppTypography.priceSmall),
                    const SizedBox(width: 4),
                    Text('\$99', style: AppTypography.priceStrikethrough),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '65 left',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Coupons Tab ───────────────────────────────
class CouponsTab extends StatefulWidget {
  const CouponsTab({super.key});

  @override
  State<CouponsTab> createState() => _CouponsTabState();
}

class _CouponsTabState extends State<CouponsTab> {
  @override
  void initState() {
    super.initState();
    final couponCubit = context.read<CouponCubit>();
    if (couponCubit.state is CouponInitial) {
      couponCubit.loadCoupons();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CouponCubit, CouponState>(
      builder: (context, state) {
        if (state is CouponLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CouponError) {
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            child: Center(
              child: Text(state.message, style: AppTypography.bodyMedium),
            ),
          );
        }

        if (state is CouponLoaded) {
          if (state.coupons.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.pagePadding),
                child: Text('No active coupons at the moment.'),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            itemCount: state.coupons.length,
            itemBuilder: (_, index) => ActiveCouponCard(coupon: state.coupons[index]),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class CouponCard extends StatelessWidget {
  final String code;
  final String discount;
  final String expiry;
  final bool isUsed;

  const CouponCard({
    super.key,
    required this.code,
    required this.discount,
    required this.expiry,
    required this.isUsed,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isUsed ? 0.5 : 1,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 100,
              decoration: BoxDecoration(
                gradient: isUsed
                    ? const LinearGradient(
                        colors: [AppColors.textHint, AppColors.textHint],
                      )
                    : AppColors.accentGradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.xl),
                  bottomLeft: Radius.circular(AppRadius.xl),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(discount, style: AppTypography.h2),
                          const SizedBox(height: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                              border: Border.all(
                                color: AppColors.divider,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Text(
                              code,
                              style: AppTypography.labelLarge.copyWith(
                                letterSpacing: 2,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(expiry, style: AppTypography.bodySmall),
                        ],
                      ),
                    ),
                    if (!isUsed)
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.accentGradient,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          child: Text(
                            'Use',
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      )
                    else
                      AppBadge(
                        label: 'Used',
                        backgroundColor: AppColors.surfaceVariant,
                        textColor: AppColors.textHint,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Deals Tab ─────────────────────────────────
class DealsTab extends StatelessWidget {
  const DealsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      children: List.generate(
        4,
        (i) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.lg),
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            gradient: [
              AppColors.primaryGradient,
              AppColors.accentGradient,
              const LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)]),
              const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
            ][i],
            boxShadow: AppColors.cardShadow,
          ),
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ['Weekend Sale', 'Bundle Deal', 'Student Offer', 'Members Only'][i],
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      ['30% OFF', 'Buy 2 Get 1', '15% OFF', 'Extra 25%'][i],
                      style: AppTypography.h1.copyWith(color: AppColors.white),
                    ),
                    Text(
                      'Shop Now →',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                [Icons.weekend_rounded, Icons.card_giftcard_rounded, Icons.school_rounded, Icons.star_rounded][i],
                size: 64,
                color: Colors.white24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}