import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/common_widgets.dart';

// ═══════════════════════════════════════════════
// CART SCREEN
// ═══════════════════════════════════════════════
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Clear All',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.accent,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              itemCount: 3,
              itemBuilder: (_, i) => const CartItemCard(),
            ),
          ),
          const CartSummarySection(),
        ],
      ),
    );
  }
}

class CartItemCard extends StatefulWidget {
  const CartItemCard({super.key});

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.xl),
        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: Container(
                width: 80,
                height: 80,
                color: AppColors.surfaceVariant,
                child: const Icon(
                  Icons.image_outlined,
                  color: AppColors.textHint,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nike Air Max 2025',
                    style: AppTypography.labelLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      AppBadge(label: 'Blue', isSmall: true),
                      const SizedBox(width: 6),
                      AppBadge(label: 'Size L', isSmall: true),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$149.99', style: AppTypography.priceMedium),
                      QuantityControl(
                        quantity: _qty,
                        onIncrement: () => setState(() => _qty++),
                        onDecrement: () {
                          if (_qty > 1) setState(() => _qty--);
                        },
                        isSmall: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartSummarySection extends StatefulWidget {
  const CartSummarySection({super.key});

  @override
  State<CartSummarySection> createState() => _CartSummarySectionState();
}

class _CartSummarySectionState extends State<CartSummarySection> {
  final _couponCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppRadius.xxl),
          topRight: Radius.circular(AppRadius.xxl),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _couponCtrl,
                  decoration: InputDecoration(
                    hintText: 'Enter coupon code',
                    hintStyle: AppTypography.bodyMedium,
                    prefixIcon: const Icon(
                      Icons.local_offer_outlined,
                      size: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Apply',
                    style: AppTypography.buttonMedium.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          const _PriceRow(label: 'Subtotal', value: '\$449.97'),
          const _PriceRow(label: 'Shipping', value: '\$9.99'),
          const _PriceRow(
            label: 'Discount',
            value: '-\$50.00',
            isDiscount: true,
          ),
          const Divider(height: AppSpacing.xl),
          _PriceRow(label: 'Total', value: '\$409.96', isTotal: true),
          const SizedBox(height: AppSpacing.xl),
          GradientButton(
            label: 'Proceed to Checkout',
            onTap: () {
              context.go(AppRoutes.checkout);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDiscount;
  final bool isTotal;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isDiscount = false,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal ? AppTypography.h3 : AppTypography.bodyMedium,
          ),
          Text(
            value,
            style: isTotal
                ? AppTypography.priceLarge
                : isDiscount
                ? AppTypography.labelLarge.copyWith(color: AppColors.success)
                : AppTypography.labelLarge,
          ),
        ],
      ),
    );
  }
}