import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/home/data/models/product_model.dart';
import 'package:real_ecommerce/features/home/view/widgets/brand_and_rating.dart';
import 'package:real_ecommerce/features/home/view/widgets/delivery_info_strip.dart';
import 'package:real_ecommerce/features/home/view/widgets/details/color_sector.dart';
import 'package:real_ecommerce/features/home/view/widgets/details/product_bottom_bar.dart';
import 'package:real_ecommerce/features/home/view/widgets/details/product_image_section.dart';
import 'package:real_ecommerce/features/home/view/widgets/details/product_tabs.dart';
import 'package:real_ecommerce/features/home/view/widgets/size_selector.dart';

/// Layout الموبايل:
///   SliverAppBar (Hero image) → تفاصيل المنتج → BottomBar
class ProductDetailMobile extends StatelessWidget {
  final ProductModel product;
  final List<String> galleryImages;
  final int selectedImage;
  final String selectedSize;
  final String selectedColor;
  final bool isWishlisted;
  final List<String> sizes;
  final TabController tabController;
  final PageController pageController;
  final ValueChanged<int> onImageSelect;
  final ValueChanged<String> onSizeSelect;
  final ValueChanged<String> onColorSelect;
  final VoidCallback onWishlistToggle;

  const ProductDetailMobile({
    super.key,
    required this.product,
    required this.galleryImages,
    required this.selectedImage,
    required this.selectedSize,
    required this.selectedColor,
    required this.isWishlisted,
    required this.sizes,
    required this.tabController,
    required this.pageController,
    required this.onImageSelect,
    required this.onSizeSelect,
    required this.onColorSelect,
    required this.onWishlistToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Image Hero ──────────────────────────────
          SliverAppBar(
            expandedHeight: 420,
            pinned: true,
            backgroundColor: AppColors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: const Icon(Icons.arrow_back_rounded,
                      color: AppColors.textPrimary, size: 20),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: onWishlistToggle,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Icon(
                      isWishlisted
                          ? Icons.favorite_rounded
                          : Icons.favorite_outline_rounded,
                      size: 20,
                      color: isWishlisted
                          ? AppColors.accent
                          : AppColors.textHint,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(right: 12, top: 10, bottom: 10),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: const Icon(Icons.share_outlined,
                      size: 18, color: AppColors.textPrimary),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: ProductImageSection(
                images: galleryImages,
                selectedIndex: selectedImage,
                pageController: pageController,
                onSelect: onImageSelect,
              ),
            ),
          ),

          // ── Product Details ──────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pagePadding,
                  AppSpacing.xxl,
                  AppSpacing.pagePadding,
                  0,
                ),
                child: _ProductInfo(
                  product: product,
                  selectedSize: selectedSize,
                  selectedColor: selectedColor,
                  sizes: sizes,
                  tabController: tabController,
                  onSizeSelect: onSizeSelect,
                  onColorSelect: onColorSelect,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ProductBottomBar(
        productId: product.id,
        selectedSize: selectedSize,
        selectedColor: selectedColor,
      ),
    );
  }
}

// ── Shared Info Section ─────────────────────────
// (مشترك بين موبايل وديسكتوب عشان نتفادى التكرار)
class ProductInfoContent extends StatelessWidget {
  final ProductModel product;
  final String selectedSize;
  final String selectedColor;
  final List<String> sizes;
  final TabController tabController;
  final ValueChanged<String> onSizeSelect;
  final ValueChanged<String> onColorSelect;

  const ProductInfoContent({
    super.key,
    required this.product,
    required this.selectedSize,
    required this.selectedColor,
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

        // Color
        if (product.variants.isNotEmpty) ...[
          const SectionHeader(title: 'Color'),
          const SizedBox(height: AppSpacing.lg),
          ColorSelector(
            variants: product.variants,
            selectedColor: selectedColor,
            onSelect: onColorSelect,
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],

        // Size
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

        // Tabs
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
                  reviewsCount: product.reviews),
            ],
          ),
        ),
        const SizedBox(height: 120),
      ],
    );
  }
}

// alias داخلي عشان الاستخدام في الـ SliverToBoxAdapter
typedef _ProductInfo = ProductInfoContent;