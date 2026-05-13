import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/features/home/data/models/product_model.dart';
import 'package:real_ecommerce/features/home/view/widgets/details/product_bottom_bar.dart';
import 'package:real_ecommerce/features/home/view/widgets/details/product_image_section.dart';
import 'package:real_ecommerce/features/home/view/widgets/details/product_info_content.dart';

/// Layout الموبايل:
///   SliverAppBar (Hero image) → تفاصيل المنتج → BottomBar
class ProductDetailMobile extends StatelessWidget {
  final ProductModel product;
  final List<String> galleryImages;
  final int selectedImage;
  final String selectedSize;
  final String selectedColorHex;
  final String selectedColorName;
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
    required this.selectedColorHex,
    required this.selectedColorName,
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
                child: ProductInfoContent(
                  product: product,
                  selectedSize: selectedSize,
                  selectedColorHex: selectedColorHex,
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
        product: product,
        productId: product.id,
        selectedSize: selectedSize,
        selectedColorHex: selectedColorHex,
        selectedColorName: selectedColorName,
      ),
    );
  }
}
