import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/home/data/models/product_model.dart';
import 'package:real_ecommerce/features/home/view/widgets/brand_and_rating.dart';
import 'package:real_ecommerce/features/home/view/widgets/delivery_info_strip.dart';
import 'package:real_ecommerce/features/home/view/widgets/details/color_sector.dart';
import 'package:real_ecommerce/features/home/view/widgets/details/product_tabs.dart';
import 'package:real_ecommerce/features/home/view/widgets/size_selector.dart';

/// تفاصيل المنتج (اسم، سعر، ألوان، مقاسات، تابات) — مشترك بين موبايل وديسكتوب.
class ProductInfoContent extends StatelessWidget {
  final ProductModel product;
  final String selectedSize;
  final String selectedColorHex;
  final List<String> sizes;
  final TabController tabController;
  final ValueChanged<String> onSizeSelect;
  final ValueChanged<String> onColorSelect;

  const ProductInfoContent({
    super.key,
    required this.product,
    required this.selectedSize,
    required this.selectedColorHex,
    required this.sizes,
    required this.tabController,
    required this.onSizeSelect,
    required this.onColorSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BrandAndRating(),
        const SizedBox(height: AppSpacing.md),
        Text(
          product.name,
          style: AppTypography.h1.copyWith(
            height: 1.2,
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          product.formattedPrice,
          style: AppTypography.displayMedium.copyWith(
            color: AppColors.accent,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        DeliveryInfoStrip(),
        const SizedBox(height: AppSpacing.xxl),
        const SectionDivider(),
        const SizedBox(height: AppSpacing.xl),
        if (product.variants.isNotEmpty) ...[
          const SectionHeader(title: 'Color'),
          const SizedBox(height: AppSpacing.lg),
          ColorSelector(
            variants: product.variants,
            selectedColor: selectedColorHex,
            onSelect: onColorSelect,
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionHeader(title: 'Size'),
            GestureDetector(
              onTap: () {},
              child: Text(
                'Size Guide →',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        SizeSelector(
          sizes: sizes,
          selected: selectedSize,
          onSelect: onSizeSelect,
        ),
        const SizedBox(height: AppSpacing.xxl),
        const SectionDivider(),
        const SizedBox(height: AppSpacing.lg),
        StyledTabBar(controller: tabController),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          height: 220,
          child: TabBarView(
            controller: tabController,
            children: [
              DescriptionTab(description: product.description),
              const SpecsTab(),
              ReviewsTab(
                rating: product.rating,
                reviewsCount: product.reviews,
              ),
            ],
          ),
        ),
        const SizedBox(height: 120),
      ],
    );
  }
}
