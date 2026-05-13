import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/features/home/data/models/product_model.dart';
import 'package:real_ecommerce/features/home/view/widgets/details/product_bottom_bar.dart';
import 'package:real_ecommerce/features/home/view/widgets/details/product_desktop_image_panel.dart';
import 'package:real_ecommerce/features/home/view/widgets/details/product_info_content.dart';

/// Layout الديسكتوب:
///   ┌─── AppBar ──────────────────────────────────────┐
///   ├──────────────────────┬──────────────────────────┤
///   │  Images (sticky)     │  Product Info (scroll)   │
///   │                      │                          │
///   │  [ Main Image ]      │  Brand / Name / Price    │
///   │  [ thumb ][ thumb ]  │  Delivery strip          │
///   │                      │  Colors / Sizes          │
///   │                      │  Tabs                    │
///   ├──────────────────────┴──────────────────────────┤
///   │  [ Qty ] [ ──── Add to Cart ──────────────── ]  │
///   └─────────────────────────────────────────────────┘
class ProductDetailDesktop extends StatelessWidget {
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

  const ProductDetailDesktop({
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isWishlisted
                  ? Icons.favorite_rounded
                  : Icons.favorite_outline_rounded,
              color: isWishlisted ? AppColors.accent : null,
            ),
            onPressed: onWishlistToggle,
          ),
          const IconButton(
            icon: Icon(Icons.share_outlined),
            onPressed: null,
          ),
          const SizedBox(width: AppSpacing.md),
        ],
      ),
      body: Column(
        children: [
          // ── Main Content ──────────────────────────────
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.pagePadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Left: Image (sticky) ────────────
                      Expanded(
                        flex: 5,
                        child: ProductDesktopImagePanel(
                          images: galleryImages,
                          selectedIndex: selectedImage,
                          pageController: pageController,
                          onSelect: onImageSelect,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xxl),

                      // ── Right: Info (scrollable) ─────────
                      Expanded(
                        flex: 6,
                        child: SingleChildScrollView(
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
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Bottom Bar ────────────────────────────────
          ProductBottomBar(
            product: product,
            productId: product.id,
            selectedSize: selectedSize,
            selectedColorHex: selectedColorHex,
            selectedColorName: selectedColorName,
          ),
        ],
      ),
    );
  }
}