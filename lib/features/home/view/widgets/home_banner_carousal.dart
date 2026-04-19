import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/features/home/data/models/bannar_model.dart';
import 'package:real_ecommerce/features/home/logic/bannars_cubit.dart';

// ══════════════════════════════════════════════════════════
//  BANNER CAROUSEL — يقرأ من BannerCubit فقط
//  ✅ عزل تام — اختيار الصنف ما يأثرش عليه خالص
// ══════════════════════════════════════════════════════════

class HomeBannerCarousel extends StatelessWidget {
  const HomeBannerCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerCubit, BannerState>(
      builder: (context, state) {
        if (state is BannerLoading) {
          return const _BannerShimmer();
        }
        if (state is! BannerLoaded) return const SizedBox.shrink();

        return _BannerCarouselView(banners: state.banners);
      },
    );
  }
}

// ── Stateful carousel ──────────────────────────────────────

class _BannerCarouselView extends StatefulWidget {
  final List<BannerModel> banners;
  const _BannerCarouselView({required this.banners});

  @override
  State<_BannerCarouselView> createState() => _BannerCarouselViewState();
}

class _BannerCarouselViewState extends State<_BannerCarouselView> {
  int _current = 0;
  late final PageController _pageCtrl;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 195,
          child: PageView.builder(
            controller: _pageCtrl,
            onPageChanged: (i) => setState(() => _current = i),
            itemCount: widget.banners.length,
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pagePadding),
              child: _BannerCard(banner: widget.banners[i]),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.banners.length, (i) {
            final isActive = i == _current;
            return GestureDetector(
              onTap: () => _pageCtrl.animateToPage(
                i,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              ),
              child: AnimatedContainer(
                duration: AppDurations.normal,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 22 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isActive
                      ? widget.banners[_current].accentColor
                      : widget.banners[_current].accentColor
                          .withOpacity(0.22),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ── Banner card ────────────────────────────────────────────

class _BannerCard extends StatelessWidget {
  final BannerModel banner;
  const _BannerCard({required this.banner});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: SizedBox(
        height: 195,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              banner.imageUrl,
              fit: BoxFit.cover,
              cacheWidth: 800,
              loadingBuilder: (ctx, child, p) =>
                  p == null ? child : const ColoredBox(color: Color(0xFF1A1A2E)),
              errorBuilder: (_, __, ___) =>
                  const ColoredBox(color: Color(0xFF1A1A2E)),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withOpacity(0.72),
                    Colors.black.withOpacity(0.38),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    banner.accentColor.withOpacity(0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _TagPill(
                      tag: banner.tag, accentColor: banner.accentColor),
                  const SizedBox(height: 10),
                  Text(
                    banner.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    banner.subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.62),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _ShopNowBtn(accentColor: banner.accentColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagPill extends StatelessWidget {
  final String tag;
  final Color accentColor;
  const _TagPill({required this.tag, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.25),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border:
            Border.all(color: accentColor.withOpacity(0.5), width: 0.8),
      ),
      child: Text(
        tag,
        style: TextStyle(
          color: Colors.white.withOpacity(0.95),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _ShopNowBtn extends StatelessWidget {
  final Color accentColor;
  const _ShopNowBtn({required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Shop Now',
            style: TextStyle(
              color: accentColor,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 5),
          Icon(Icons.arrow_forward_rounded, color: accentColor, size: 13),
        ],
      ),
    );
  }
}

// ── Shimmer placeholder ────────────────────────────────────

class _BannerShimmer extends StatelessWidget {
  const _BannerShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pagePadding),
      child: Container(
        height: 195,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(22),
        ),
      ),
    );
  }
}