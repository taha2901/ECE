import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';
import 'package:real_ecommerce/features/home/view/widgets/product_widgets.dart';

// ═══════════════════════════════════════════════
// HOME APP BAR CONTENT
// ═══════════════════════════════════════════════
class HomeAppBarContent extends StatelessWidget {
  const HomeAppBarContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello, Ahmed 👋', style: AppTypography.h3),
              Text('What are you looking for?', style: AppTypography.bodySmall),
            ],
          ),
          const Spacer(),
          Stack(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  boxShadow: AppColors.cardShadow,
                ),
                child: const Icon(Icons.notifications_outlined, size: 22),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.md),
              boxShadow: AppColors.cardShadow,
            ),
            child: const Icon(Icons.shopping_bag_outlined, size: 22),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// HOME SEARCH BAR
// ═══════════════════════════════════════════════
class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          children: [
            const SizedBox(width: AppSpacing.lg),
            const Icon(Icons.search_rounded, color: AppColors.textHint, size: 22),
            const SizedBox(width: AppSpacing.md),
            Text(AppStrings.search, style: AppTypography.bodyMedium),
            const Spacer(),
            Container(
              margin: const EdgeInsets.all(6),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: const Icon(Icons.tune_rounded, color: AppColors.white, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// HOME BANNER CAROUSEL
// ═══════════════════════════════════════════════
class HomeBannerCarousel extends StatefulWidget {
  const HomeBannerCarousel({super.key});

  @override
  State<HomeBannerCarousel> createState() => _HomeBannerCarouselState();
}

class _HomeBannerCarouselState extends State<HomeBannerCarousel> {
  int _current = 0;

  final _banners = [
    _BannerData(
      title: 'Up to 50% Off',
      subtitle: 'Summer Collection',
      gradient: AppColors.primaryGradient,
      tag: 'Limited Time',
    ),
    _BannerData(
      title: 'New Arrivals',
      subtitle: 'Electronics 2025',
      gradient: const LinearGradient(
        colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      tag: 'Just In',
    ),
    _BannerData(
      title: 'Flash Sale',
      subtitle: 'Ends in 6 hours',
      gradient: AppColors.accentGradient,
      tag: '⚡ Flash',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            padEnds: false,
            controller: PageController(viewportFraction: 0.88),
            onPageChanged: (i) => setState(() => _current = i),
            itemCount: _banners.length,
            itemBuilder: (_, i) {
              final b = _banners[i];
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.lg),
                child: Container(
                  margin: const EdgeInsets.only(left: AppSpacing.pagePadding),
                  decoration: BoxDecoration(
                    gradient: b.gradient,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                  ),
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppBadge(
                              label: b.tag,
                              backgroundColor: AppColors.white.withOpacity(0.2),
                              textColor: AppColors.white,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(b.title, style: AppTypography.h1.copyWith(color: AppColors.white)),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              b.subtitle,
                              style: AppTypography.bodyMedium.copyWith(color: AppColors.white.withOpacity(0.8)),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(AppRadius.pill),
                              ),
                              child: Text(
                                'Shop Now',
                                style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.local_offer_rounded, size: 80, color: Colors.white24),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (i) => AnimatedContainer(
              duration: AppDurations.normal,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _current == i ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _current == i ? AppColors.accent : AppColors.accent.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BannerData {
  final String title;
  final String subtitle;
  final Gradient gradient;
  final String tag;

  const _BannerData({
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.tag,
  });
}

// ═══════════════════════════════════════════════
// FLASH SALE SECTION
// ═══════════════════════════════════════════════
class FlashSaleSection extends StatelessWidget {
  const FlashSaleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    const Icon(Icons.bolt_rounded, color: AppColors.white, size: 18),
                    Text(' Flash Sale', style: AppTypography.labelLarge.copyWith(color: AppColors.white)),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text("Today's Deals", style: AppTypography.h2.copyWith(color: AppColors.white)),
              ],
            ),
          ),
          Row(
            children: [
              _TimeBlock(value: '06', label: 'HRS'),
              const _TimeSeparator(),
              _TimeBlock(value: '24', label: 'MIN'),
              const _TimeSeparator(),
              _TimeBlock(value: '38', label: 'SEC'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeBlock extends StatelessWidget {
  final String value;
  final String label;

  const _TimeBlock({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        children: [
          Text(value, style: AppTypography.h2.copyWith(color: AppColors.white)),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.white.withOpacity(0.7),
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeSeparator extends StatelessWidget {
  const _TimeSeparator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(':', style: AppTypography.h2.copyWith(color: AppColors.white)),
    );
  }
}

// ═══════════════════════════════════════════════
// CATEGORY PILLS ROW
// ═══════════════════════════════════════════════
class CategoryPillsRow extends StatefulWidget {
  const CategoryPillsRow({super.key});

  @override
  State<CategoryPillsRow> createState() => _CategoryPillsRowState();
}

class _CategoryPillsRowState extends State<CategoryPillsRow> {
  int _selected = 0;

  final _cats = [
    ('All', Icons.apps_rounded),
    ('Electronics', Icons.devices_rounded),
    ('Fashion', Icons.checkroom_rounded),
    ('Beauty', Icons.spa_rounded),
    ('Home', Icons.home_rounded),
    ('Sports', Icons.fitness_center_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _cats.length,
        padding: const EdgeInsets.only(right: AppSpacing.pagePadding),
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (_, i) {
          final isSelected = i == _selected;
          return GestureDetector(
            onTap: () => setState(() => _selected = i),
            child: AnimatedContainer(
              duration: AppDurations.fast,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent : AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                boxShadow: isSelected ? AppColors.accentShadow : AppColors.cardShadow,
              ),
              child: Row(
                children: [
                  Icon(
                    _cats[i].$2,
                    size: 16,
                    color: isSelected ? AppColors.white : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _cats[i].$1,
                    style: AppTypography.labelMedium.copyWith(
                      color: isSelected ? AppColors.white : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// FEATURED PRODUCTS ROW
// ═══════════════════════════════════════════════
class FeaturedProductsRow extends StatelessWidget {
  const FeaturedProductsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
        itemCount: 8,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.lg),
        itemBuilder: (_, i) => const ProductCardVertical(),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// NEW ARRIVALS GRID
// ═══════════════════════════════════════════════
class NewArrivalsGrid extends StatelessWidget {
  const NewArrivalsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.lg,
          crossAxisSpacing: AppSpacing.lg,
          childAspectRatio: 0.72,
        ),
        itemCount: 6,
        itemBuilder: (_, i) => const ProductCardGrid(),
      ),
    );
  }
}