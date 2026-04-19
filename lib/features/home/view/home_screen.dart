import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';
import 'package:real_ecommerce/features/home/view/widgets/home_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App Bar ──────────────────────────────────────
          SliverAppBar(
            floating: true,
            snap: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: AppColors.background,
            title: const HomeAppBarContent(),
            toolbarHeight: 72,
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.pagePadding,
                  ),
                  child: HomeSearchBar(),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Banner Carousel
                const HomeBannerCarousel(),
                const SizedBox(height: AppSpacing.sectionGap),

                // Flash Sale
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.pagePadding,
                  ),
                  child: FlashSaleSection(),
                ),
                const SizedBox(height: AppSpacing.sectionGap),

                // Categories
                const Padding(
                  padding: EdgeInsets.only(left: AppSpacing.pagePadding),
                  child: CategoryPillsRow(),
                ),
                const SizedBox(height: AppSpacing.sectionGap),

                // Featured header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.pagePadding,
                  ),
                  child: SectionHeader(
                    title: 'Featured',
                    action: AppStrings.seeAll,
                    onAction: () {},
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Featured products
                const FeaturedProductsRow(),
                const SizedBox(height: AppSpacing.sectionGap),

                // New Arrivals header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.pagePadding,
                  ),
                  child: SectionHeader(
                    title: 'New Arrivals',
                    action: AppStrings.seeAll,
                    onAction: () {},
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // New Arrivals grid
                const NewArrivalsGrid(),
                const SizedBox(height: AppSpacing.xxxl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}