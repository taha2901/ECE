import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import '../../../core/constants/app_constants.dart';

// ═══════════════════════════════════════════════
// CATEGORIES SCREEN
// ═══════════════════════════════════════════════
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  final _categories = const [
    _CategoryData('Electronics', Icons.devices_rounded, Color(0xFF4F46E5)),
    _CategoryData('Fashion', Icons.checkroom_rounded, Color(0xFFE94560)),
    _CategoryData('Beauty', Icons.spa_rounded, Color(0xFFEC4899)),
    _CategoryData('Home & Living', Icons.home_rounded, Color(0xFF10B981)),
    _CategoryData('Sports', Icons.fitness_center_rounded, Color(0xFFF59E0B)),
    _CategoryData('Books', Icons.menu_book_rounded, Color(0xFF3B82F6)),
    _CategoryData('Groceries', Icons.local_grocery_store_rounded, Color(0xFF22C55E)),
    _CategoryData('Automotive', Icons.directions_car_rounded, Color(0xFF6366F1)),
    _CategoryData('Toys', Icons.toys_rounded, Color(0xFFF97316)),
    _CategoryData('Music', Icons.music_note_rounded, Color(0xFF8B5CF6)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Categories'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pagePadding,
              vertical: 8,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search categories...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: AppColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.lg,
          crossAxisSpacing: AppSpacing.lg,
          childAspectRatio: 1.3,
        ),
        itemCount: _categories.length,
        itemBuilder: (_, i) => CategoryGridCard(category: _categories[i]),
      ),
    );
  }
}

class CategoryGridCard extends StatelessWidget {
  final _CategoryData category;

  const CategoryGridCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: AppColors.cardShadow,
        ),
        child: Stack(
          children: [
            // Background accent circle
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: category.color.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: category.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Icon(category.icon, color: category.color, size: 24),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(category.name, style: AppTypography.labelLarge),
                  Text(
                    '120+ Items',
                    style: AppTypography.labelSmall.copyWith(
                      color: category.color,
                    ),
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

class _CategoryData {
  final String name;
  final IconData icon;
  final Color color;

  const _CategoryData(this.name, this.icon, this.color);
}