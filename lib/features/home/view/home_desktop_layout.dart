import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/helpers/responsive.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/home/data/models/category_model.dart';
import 'package:real_ecommerce/features/home/logic/bannars_cubit.dart';
import 'package:real_ecommerce/features/home/logic/category_cubit.dart';
import 'package:real_ecommerce/features/home/logic/product_cubit.dart';
import 'package:real_ecommerce/features/home/view/widgets/product_widgets.dart';

// ══════════════════════════════════════════════════════════
//  HOME — DESKTOP LAYOUT  (professional e-commerce style)
//
//  ┌─────────────────────────────────────────────────────┐
//  │  Category Nav Bar  (horizontal text tabs)            │
//  ├─────────────────────────────────────────────────────┤
//  │  Hero Banner  (full-width, 380px tall)               │
//  ├─────────────────────────────────────────────────────┤
//  │  Promo strip  (3 info tiles)                         │
//  ├─────────────────────────────────────────────────────┤
//  │  Featured   → 4-column product grid                  │
//  ├─────────────────────────────────────────────────────┤
//  │  Flash Deal countdown strip                          │
//  ├─────────────────────────────────────────────────────┤
//  │  New Arrivals → 5-column product grid                │
//  └─────────────────────────────────────────────────────┘
// ══════════════════════════════════════════════════════════

class HomeDesktopLayout extends StatefulWidget {
  const HomeDesktopLayout({super.key});

  @override
  State<HomeDesktopLayout> createState() => _HomeDesktopLayoutState();
}

class _HomeDesktopLayoutState extends State<HomeDesktopLayout> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductCubit>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          _DesktopCategoryNavBar(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _HeroBannerSection(),
                  _PromoBannersRow(),
                  _DesktopSectionWrapper(
                    title: 'Featured Products',
                    child: _DesktopFeaturedGrid(),
                  ),
                  _FlashDealStrip(),
                  _DesktopSectionWrapper(
                    title: 'New Arrivals',
                    child: _DesktopNewArrivalsGrid(),
                  ),
                  SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  CATEGORY NAV BAR  —  horizontal text tabs
// ══════════════════════════════════════════════════════════

class _DesktopCategoryNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        final categories =
            state is CategoryLoaded ? state.categories : <CategoryModel>[];
        final selectedId = state is CategoryLoaded ? state.selectedId : 'all';

        return Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(
              bottom: BorderSide(color: AppColors.divider),
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                _CategoryTab(
                  label: 'All',
                  isSelected: selectedId == 'all',
                  color: AppColors.accent,
                  onTap: () =>
                      context.read<CategoryCubit>().selectCategory('all'),
                ),
                ...categories.map(
                  (cat) => _CategoryTab(
                    label: cat.label,
                    isSelected: cat.id == selectedId,
                    color: cat.activeColor,
                    onTap: () =>
                        context.read<CategoryCubit>().selectCategory(cat.id),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CategoryTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _CategoryTab({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 2),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? color : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? color : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  HERO BANNER  —  full-width, 380 px, with arrows
// ══════════════════════════════════════════════════════════

class _HeroBannerSection extends StatelessWidget {
  const _HeroBannerSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerCubit, BannerState>(
      builder: (context, state) {
        if (state is BannerLoading) {
          return Container(height: 380, color: AppColors.surfaceVariant);
        }
        if (state is! BannerLoaded) return const SizedBox.shrink();
        return _DesktopHeroCarousel(banners: state.banners);
      },
    );
  }
}

class _DesktopHeroCarousel extends StatefulWidget {
  final List<dynamic> banners;
  const _DesktopHeroCarousel({required this.banners});

  @override
  State<_DesktopHeroCarousel> createState() => _DesktopHeroCarouselState();
}

class _DesktopHeroCarouselState extends State<_DesktopHeroCarousel> {
  int _current = 0;
  late final PageController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = PageController();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 380,
      child: Stack(
        children: [
          PageView.builder(
            controller: _ctrl,
            onPageChanged: (i) => setState(() => _current = i),
            itemCount: widget.banners.length,
            itemBuilder: (_, i) =>
                _DesktopBannerSlide(banner: widget.banners[i]),
          ),
          // Left arrow
          Positioned(
            left: 20, top: 0, bottom: 0,
            child: Center(child: _ArrowBtn(icon: Icons.arrow_back_ios_rounded, onTap: () {
              _ctrl.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
            })),
          ),
          // Right arrow
          Positioned(
            right: 20, top: 0, bottom: 0,
            child: Center(child: _ArrowBtn(icon: Icons.arrow_forward_ios_rounded, onTap: () {
              _ctrl.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
            })),
          ),
          // Dots
          Positioned(
            bottom: 16, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.banners.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _current ? 28 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _current ? Colors.white : Colors.white38,
                    borderRadius: BorderRadius.circular(4),
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

class _DesktopBannerSlide extends StatelessWidget {
  final dynamic banner;
  const _DesktopBannerSlide({required this.banner});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(banner.imageUrl, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(color: const Color(0xFF1A1A2E))),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.black.withOpacity(0.75),
                Colors.black.withOpacity(0.3),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(64, 0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: banner.accentColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: banner.accentColor.withOpacity(0.7)),
                ),
                child: Text(banner.tag,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 16),
              Text(banner.title,
                  style: const TextStyle(
                    color: Colors.white, fontSize: 44,
                    fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1,
                  )),
              const SizedBox(height: 10),
              Text(banner.subtitle,
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16)),
              const SizedBox(height: 28),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text('Shop Now',
                        style: TextStyle(color: banner.accentColor, fontSize: 14, fontWeight: FontWeight.w800)),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, color: banner.accentColor, size: 16),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ArrowBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ArrowBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white38),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  PROMO ROW  —  3 info tiles directly below hero
// ══════════════════════════════════════════════════════════

class _PromoBannersRow extends StatelessWidget {
  const _PromoBannersRow();

  static const _items = [
    _PromoItem(label: 'Free Shipping',     sub: 'On orders above \$50',     icon: Icons.local_shipping_outlined, color: Color(0xFF0EA5E9), bg: Color(0xFFE0F2FE)),
    _PromoItem(label: 'Flash Sale — 60%',  sub: 'Limited time offer',       icon: Icons.bolt_rounded,            color: Color(0xFFEF4444), bg: Color(0xFFFEF2F2)),
    _PromoItem(label: 'New Season 2025',   sub: 'Explore the collection',   icon: Icons.auto_awesome_rounded,    color: Color(0xFF8B5CF6), bg: Color(0xFFF5F3FF)),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Row(
        children: _items.asMap().entries.map((e) {
          final p = e.value;
          final isLast = e.key == _items.length - 1;
          return Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: p.bg,
                border: Border(right: isLast ? BorderSide.none : BorderSide(color: AppColors.divider)),
              ),
              child: Row(children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: p.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(p.icon, color: p.color, size: 20),
                ),
                const SizedBox(width: 14),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(p.label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  Text(p.sub, style: TextStyle(fontSize: 11, color: AppColors.textHint)),
                ]),
              ]),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PromoItem {
  final String label, sub;
  final IconData icon;
  final Color color, bg;
  const _PromoItem({required this.label, required this.sub, required this.icon, required this.color, required this.bg});
}

// ══════════════════════════════════════════════════════════
//  SECTION WRAPPER  —  accent bar + title + see all button
// ══════════════════════════════════════════════════════════

class _DesktopSectionWrapper extends StatelessWidget {
  final String title;
  final Widget child;
  const _DesktopSectionWrapper({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 4, height: 22,
            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(title, style: AppTypography.h2.copyWith(fontSize: 20, fontWeight: FontWeight.w800)),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.accent, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('See All →',
                  style: TextStyle(color: AppColors.accent, fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
        ]),
        const SizedBox(height: 20),
        child,
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  FEATURED  —  4-column grid (was horizontal scroll)
// ══════════════════════════════════════════════════════════

class _DesktopFeaturedGrid extends StatelessWidget {
  const _DesktopFeaturedGrid();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      buildWhen: (p, c) {
        if (p is CategoryLoaded && c is CategoryLoaded) return p.selectedId != c.selectedId;
        return false;
      },
      builder: (context, catState) {
        final selectedId = catState is CategoryLoaded ? catState.selectedId : 'all';
        return BlocBuilder<ProductCubit, ProductState>(
          buildWhen: (p, c) => p.runtimeType != c.runtimeType,
          builder: (context, state) {
            if (state is ProductLoading) return _Shimmer(columns: 4);
            if (state is! ProductLoaded)  return const SizedBox.shrink();

            final products = selectedId == 'all'
                ? state.featured
                : state.featured.where((p) => p.category.toString() == selectedId).toList();

            if (products.isEmpty) return const _Empty(msg: 'No featured products');

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.72,
              ),
              itemCount: products.length > 8 ? 8 : products.length,
              itemBuilder: (_, i) => ProductCardGrid(product: products[i]),
            );
          },
        );
      },
    );
  }
}

// ══════════════════════════════════════════════════════════
//  FLASH DEAL STRIP
// ══════════════════════════════════════════════════════════

class _FlashDealStrip extends StatelessWidget {
  const _FlashDealStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1A1A2E), Color(0xFF16213E)]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.bolt_rounded, color: Color(0xFFF59E0B), size: 24),
            const SizedBox(width: 8),
            const Text('Flash Sale',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
          ]),
          const SizedBox(height: 4),
          Text('Up to 60% OFF — Ends tonight!',
              style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 13)),
        ]),
        const SizedBox(width: 36),
        // Countdown
        Row(children: [
          _CountBox('02', 'HRS'),
          _Sep(),
          _CountBox('45', 'MIN'),
          _Sep(),
          _CountBox('30', 'SEC'),
        ]),
        const Spacer(),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,
              borderRadius: BorderRadius.circular(10),
              boxShadow: AppColors.accentShadow,
            ),
            child: const Text('Shop Flash Deals',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
          ),
        ),
      ]),
    );
  }
}

class _CountBox extends StatelessWidget {
  final String v, l;
  const _CountBox(this.v, this.l);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: 46, height: 46,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(child: Text(v,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800))),
      ),
      const SizedBox(height: 4),
      Text(l, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 9, letterSpacing: 1)),
    ]);
  }
}

class _Sep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
      child: Text(':', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 22, fontWeight: FontWeight.w800)),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  NEW ARRIVALS  —  4 or 5 columns
// ══════════════════════════════════════════════════════════

class _DesktopNewArrivalsGrid extends StatelessWidget {
  const _DesktopNewArrivalsGrid();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      buildWhen: (p, c) {
        if (p is CategoryLoaded && c is CategoryLoaded) return p.selectedId != c.selectedId;
        return false;
      },
      builder: (context, catState) {
        final selectedId = catState is CategoryLoaded ? catState.selectedId : 'all';
        return BlocBuilder<ProductCubit, ProductState>(
          buildWhen: (p, c) => p.runtimeType != c.runtimeType,
          builder: (context, state) {
            if (state is ProductLoading) return _Shimmer(columns: 5);
            if (state is! ProductLoaded)  return const SizedBox.shrink();

            final products = selectedId == 'all'
                ? state.trending
                : state.trending.where((p) => p.category.toString() == selectedId).toList();

            if (products.isEmpty) return const _Empty(msg: 'No new arrivals');

            final w = MediaQuery.sizeOf(context).width - Responsive.sideNavWidth;
            final cols = w >= 1400 ? 5 : 4;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.72,
              ),
              itemCount: products.length > 10 ? 10 : products.length,
              itemBuilder: (_, i) => ProductCardGrid(product: products[i]),
            );
          },
        );
      },
    );
  }
}

// ══════════════════════════════════════════════════════════
//  SHARED HELPERS
// ══════════════════════════════════════════════════════════

class _Shimmer extends StatelessWidget {
  final int columns;
  const _Shimmer({required this.columns});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.72,
      ),
      itemCount: columns,
      itemBuilder: (_, __) => Container(
        decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final String msg;
  const _Empty({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.inbox_rounded, size: 48, color: AppColors.textHint.withOpacity(0.4)),
        const SizedBox(height: 12),
        Text(msg, style: TextStyle(color: AppColors.textHint, fontSize: 14)),
      ])),
    );
  }
}