import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/features/home/view/widgets/details/product_image_section.dart';

/// عمود الصور في تفاصيل المنتج على الديسكتوب: صورة رئيسية + شريط thumbnails.
class ProductDesktopImagePanel extends StatelessWidget {
  final List<String> images;
  final int selectedIndex;
  final PageController pageController;
  final ValueChanged<int> onSelect;

  const ProductDesktopImagePanel({
    super.key,
    required this.images,
    required this.selectedIndex,
    required this.pageController,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
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
                      color: isSelected ? AppColors.accent : AppColors.divider,
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
                        child: const Icon(
                          Icons.image_outlined,
                          size: 20,
                          color: AppColors.textHint,
                        ),
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
