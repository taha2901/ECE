// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:real_ecommerce/core/constants/app_constants.dart';
// import 'package:real_ecommerce/core/di/service_locator.dart';
// import 'package:real_ecommerce/core/themes/app_colors.dart';
// import 'package:real_ecommerce/core/widgets/common_widgets.dart';
// import 'package:real_ecommerce/features/home/logic/bannars_cubit.dart';
// import 'package:real_ecommerce/features/home/logic/category_cubit.dart';
// import 'package:real_ecommerce/features/home/logic/product_cubit.dart';
// import 'package:real_ecommerce/features/home/view/widgets/category_pill.dart';
// import 'package:real_ecommerce/features/home/view/widgets/featured_and_new_arrival_products.dart';
// import 'package:real_ecommerce/features/home/view/widgets/home_appbar_content.dart';
// import 'package:real_ecommerce/features/home/view/widgets/home_banner_carousal.dart';
// import 'package:real_ecommerce/features/home/view/widgets/home_search_bar.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => BannerCubit()..loadBanners()),
//         BlocProvider(create: (_) => sl<CategoryCubit>()..loadCategories()),
//         BlocProvider(create: (_) => sl<ProductCubit>()),
//       ],
//       child: const _HomeView(),
//     );
//   }
// }

// class _HomeView extends StatefulWidget {
//   const _HomeView();

//   @override
//   State<_HomeView> createState() => _HomeViewState();
// }

// class _HomeViewState extends State<_HomeView>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _animCtrl;
//   late final Animation<double> _fadeAnim;

//   @override
//   void initState() {
//     super.initState();
//     _animCtrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
//     _animCtrl.forward();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<ProductCubit>().loadProducts();
//     });
//   }

//   @override
//   void dispose() {
//     _animCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: FadeTransition(
//         opacity: _fadeAnim,
//         child: CustomScrollView(
//           physics: const BouncingScrollPhysics(),
//           slivers: [
//             // ── App Bar ──────────────────────────────────
//             const SliverAppBar(
//               floating: true,
//               snap: true,
//               elevation: 0,
//               scrolledUnderElevation: 0,
//               backgroundColor: AppColors.background,
//               title: HomeAppBarContent(),
//               toolbarHeight: 72,
//             ),

//             SliverToBoxAdapter(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: AppSpacing.sm),

//                   // ── Search ────────────────────────────
//                   const Padding(
//                     padding: EdgeInsets.symmetric(
//                         horizontal: AppSpacing.pagePadding),
//                     child: HomeSearchBar(),
//                   ),
//                   const SizedBox(height: AppSpacing.xxl),
//                   const HomeBannerCarousel(),
//                   const SizedBox(height: AppSpacing.sectionGap),
//                   const Padding(
//                     padding:
//                         EdgeInsets.only(left: AppSpacing.pagePadding),
//                     child: CategoryPillsRow(),
//                   ),
//                   const SizedBox(height: AppSpacing.sectionGap),
//                   // ── Featured ──────────────────────────
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: AppSpacing.pagePadding),
//                     child: SectionHeader(
//                       title: 'Featured',
//                       action: AppStrings.seeAll,
//                       onAction: () {},
//                     ),
//                   ),
//                   const SizedBox(height: AppSpacing.lg),
//                   const FeaturedProductsRow(),
//                   const SizedBox(height: AppSpacing.sectionGap),

//                   // ── New Arrivals ──────────────────────
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: AppSpacing.pagePadding),
//                     child: SectionHeader(
//                       title: 'New Arrivals',
//                       action: AppStrings.seeAll,
//                       onAction: () {},
//                     ),
//                   ),
//                   const SizedBox(height: AppSpacing.lg),
//                   const NewArrivalsGrid(),
//                   const SizedBox(height: AppSpacing.xxxl),
//                   // Bottom padding to prevent bottom nav bar from covering content
//                   const SizedBox(height: 100),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/core/di/service_locator.dart';
import 'package:real_ecommerce/core/helpers/responsive.dart';
import 'package:real_ecommerce/features/home/logic/bannars_cubit.dart';
import 'package:real_ecommerce/features/home/logic/category_cubit.dart';
import 'package:real_ecommerce/features/home/logic/product_cubit.dart';
import 'package:real_ecommerce/features/home/view/home_desktop_layout.dart';
import 'package:real_ecommerce/features/home/view/home_mobile_layout.dart';

// ══════════════════════════════════════════════════════════
//  HOME SCREEN
//  ✅  Provides the shared cubits
//  ✅  Delegates rendering to the right layout
//  ✅  No UI logic lives here
// ══════════════════════════════════════════════════════════

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BannerCubit()..loadBanners()),
        BlocProvider(create: (_) => sl<CategoryCubit>()..loadCategories()),
        BlocProvider(create: (_) => sl<ProductCubit>()),
      ],
      child: const Responsive(
        mobile:  HomeMobileLayout(),
        desktop: HomeDesktopLayout(),
      ),
    );
  }
}