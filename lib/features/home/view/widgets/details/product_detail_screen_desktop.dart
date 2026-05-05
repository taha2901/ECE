import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/features/home/data/models/product_model.dart';
import 'package:real_ecommerce/features/home/view/widgets/details/product_bottom_bar.dart';
import 'package:real_ecommerce/features/home/view/widgets/details/product_detail_screen_mobile.dart';
import 'package:real_ecommerce/features/home/view/widgets/details/product_image_section.dart';

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
  final String selectedColor;
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
                        child: _StickyImagePanel(
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
                            selectedColor: selectedColor,
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
            productId: product.id,
            selectedSize: selectedSize,
            selectedColor: selectedColor,
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// STICKY IMAGE PANEL
// الصورة الرئيسية + thumbnails جانبية (ديسكتوب)
// ══════════════════════════════════════════════
class _StickyImagePanel extends StatelessWidget {
  final List<String> images;
  final int selectedIndex;
  final PageController pageController;
  final ValueChanged<int> onSelect;

  const _StickyImagePanel({
    required this.images,
    required this.selectedIndex,
    required this.pageController,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main image
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: AspectRatio(
            aspectRatio: 1,
            child: ProductImageSection(
              images: images,
              selectedIndex: selectedIndex,
              pageController: pageController,
              onSelect: onSelect,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Thumbnails row
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: AppSpacing.md),
            itemBuilder: (_, i) {
              final isSelected = selectedIndex == i;
              return GestureDetector(
                onTap: () => onSelect(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 68,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.accent
                          : AppColors.divider,
                      width: isSelected ? 2.5 : 1,
                    ),
                    boxShadow: isSelected
                        ? AppColors.accentShadow
                        : AppColors.cardShadow,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      images[i],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.surfaceVariant,
                        child: const Icon(Icons.image_outlined,
                            size: 20, color: AppColors.textHint),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}