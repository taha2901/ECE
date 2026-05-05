import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';

class ProductImageSection extends StatelessWidget {
  final List<String> images;
  final int selectedIndex;
  final PageController pageController;
  final ValueChanged<int> onSelect;

  const ProductImageSection({
    super.key,
    required this.images,
    required this.selectedIndex,
    required this.pageController,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F3FA),
      child: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            onPageChanged: onSelect,
            itemCount: images.length,
            itemBuilder: (_, i) => Hero(
              tag: 'product-image-$i',
              child: Image.network(
                images[i],
                fit: BoxFit.cover,
                loadingBuilder: (ctx, child, progress) {
                  if (progress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                          : null,
                      color: AppColors.accent,
                      strokeWidth: 2,
                    ),
                  );
                },
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.image_outlined,
                      size: 80, color: AppColors.textHint),
                ),
              ),
            ),
          ),

          // Bottom thumbnails
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (i) {
                final isSelected = selectedIndex == i;
                return GestureDetector(
                  onTap: () => onSelect(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: isSelected ? 66 : 56,
                    height: isSelected ? 66 : 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.accent
                            : Colors.white.withOpacity(0.6),
                        width: isSelected ? 2.5 : 1.5,
                      ),
                      boxShadow: isSelected
                          ? AppColors.accentShadow
                          : AppColors.cardShadow,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        images[i],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.surfaceVariant,
                          child: const Icon(Icons.image_outlined,
                              size: 18, color: AppColors.textHint),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}