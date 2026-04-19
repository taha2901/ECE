import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';

// ═══════════════════════════════════════════════
// PRODUCT DETAIL SCREEN
// ═══════════════════════════════════════════════
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  int _selectedImage = 0;
  String _selectedSize = 'M';
  String _selectedColor = '#1A1A2E';
  bool _isWishlisted = false;
  late TabController _tabController;

  final _sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  final _colors = ['#1A1A2E', '#E94560', '#10B981', '#F59E0B'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _hexToColor(String hex) =>
      Color(int.parse(hex.replaceFirst('#', '0xFF')));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Image Section ──────────────────────
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: AppColors.white,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: AppColors.cardShadow,
              ),
              child: const BackButton(),
            ),
            actions: [
              _ActionButton(
                icon: Icon(
                  _isWishlisted
                      ? Icons.favorite_rounded
                      : Icons.favorite_outline_rounded,
                  color: _isWishlisted ? AppColors.accent : AppColors.textHint,
                ),
                onTap: () => setState(() => _isWishlisted = !_isWishlisted),
              ),
              _ActionButton(
                icon: const Icon(Icons.share_outlined, size: 20),
                onTap: () {},
                margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _ProductImageSection(
                selectedIndex: _selectedImage,
                onSelect: (i) => setState(() => _selectedImage = i),
              ),
            ),
          ),

          // ── Product Details ────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.xxl),
                  topRight: Radius.circular(AppRadius.xxl),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pagePadding,
                  AppSpacing.xxl,
                  AppSpacing.pagePadding,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand row
                    Row(
                      children: [
                        AppBadge(label: 'Nike'),
                        const Spacer(),
                        const RatingStars(rating: 4.7),
                        Text(' (2.4k)', style: AppTypography.bodySmall),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Title
                    Text(
                      'Nike Air Max 2025\nRunning Shoes',
                      style: AppTypography.h1.copyWith(height: 1.25),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Price row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('\$149.99', style: AppTypography.priceLarge),
                        const SizedBox(width: AppSpacing.md),
                        Text('\$199.99', style: AppTypography.priceStrikethrough),
                        const Spacer(),
                        AppBadge(
                          label: '-25%',
                          backgroundColor: AppColors.accent.withOpacity(0.12),
                          textColor: AppColors.accent,
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.xxl),
                    _Divider(),

                    // Color selection
                    const SizedBox(height: AppSpacing.xl),
                    _SectionTitle(title: 'Color'),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: _colors.map((c) {
                        final isSelected = _selectedColor == c;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedColor = c),
                          child: AnimatedContainer(
                            duration: AppDurations.fast,
                            margin: const EdgeInsets.only(right: AppSpacing.md),
                            width: isSelected ? 40 : 34,
                            height: isSelected ? 40 : 34,
                            decoration: BoxDecoration(
                              color: _hexToColor(c),
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(color: AppColors.accent, width: 2.5)
                                  : null,
                              boxShadow: [
                                BoxShadow(
                                  color: _hexToColor(c).withOpacity(0.45),
                                  blurRadius: isSelected ? 14 : 6,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: isSelected
                                ? const Icon(Icons.check_rounded, color: AppColors.white, size: 16)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),

                    // Size selection
                    const SizedBox(height: AppSpacing.xxl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _SectionTitle(title: 'Size'),
                        Text(
                          'Size Guide →',
                          style: AppTypography.labelMedium.copyWith(color: AppColors.accent),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Wrap(
                      spacing: AppSpacing.md,
                      runSpacing: AppSpacing.md,
                      children: _sizes.map((s) {
                        final isSelected = _selectedSize == s;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedSize = s),
                          child: AnimatedContainer(
                            duration: AppDurations.fast,
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: isSelected ? AppColors.accentGradient : null,
                              color: isSelected ? null : AppColors.white,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              boxShadow: isSelected
                                  ? AppColors.accentShadow
                                  : AppColors.cardShadow,
                            ),
                            child: Center(
                              child: Text(
                                s,
                                style: AppTypography.labelMedium.copyWith(
                                  color: isSelected
                                      ? AppColors.white
                                      : AppColors.textSecondary,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    // Delivery info strip
                    const SizedBox(height: AppSpacing.xxl),
                    _DeliveryInfoStrip(),

                    // Tabs
                    const SizedBox(height: AppSpacing.xxl),
                    _Divider(),
                    const SizedBox(height: AppSpacing.lg),
                    TabBar(
                      controller: _tabController,
                      labelColor: AppColors.accent,
                      unselectedLabelColor: AppColors.textHint,
                      indicatorColor: AppColors.accent,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: const [
                        Tab(text: 'Description'),
                        Tab(text: 'Specs'),
                        Tab(text: 'Reviews'),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      height: 200,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Description
                          Text(
                            'Premium running shoes designed for performance and comfort. '
                            'Built with advanced Air Max cushioning technology for maximum '
                            'support during your workouts. The breathable mesh upper keeps '
                            'your feet cool, while the durable rubber outsole provides '
                            'excellent traction on any surface.',
                            style: AppTypography.bodyMedium.copyWith(height: 1.6),
                          ),
                          // Specs
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              _SpecRow(label: 'Material', value: 'Premium Mesh + Rubber'),
                              _SpecRow(label: 'Weight', value: '280g'),
                              _SpecRow(label: 'Origin', value: 'Vietnam'),
                              _SpecRow(label: 'Care', value: 'Machine washable'),
                              _SpecRow(label: 'Warranty', value: '1 Year'),
                            ],
                          ),
                          // Reviews
                          ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            children: const [
                              ReviewItem(
                                name: 'Ahmed M.',
                                rating: 5,
                                comment: 'Amazing quality! Exactly as described. Super comfy.',
                                date: '2 days ago',
                              ),
                              ReviewItem(
                                name: 'Sara K.',
                                rating: 4,
                                comment: 'Great product, fast delivery. Will buy again!',
                                date: '1 week ago',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const _ProductBottomBar(),
    );
  }
}

// ─── Image Section ──────────────────────────────
class _ProductImageSection extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _ProductImageSection({
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F8),
              child: const Center(
                child: Icon(Icons.image_outlined, size: 120, color: AppColors.textHint),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pagePadding,
              vertical: AppSpacing.lg,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                final isSelected = selectedIndex == i;
                return GestureDetector(
                  onTap: () => onSelect(i),
                  child: AnimatedContainer(
                    duration: AppDurations.fast,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F8),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: isSelected
                          ? Border.all(color: AppColors.accent, width: 2)
                          : Border.all(color: Colors.transparent, width: 2),
                      boxShadow: isSelected ? AppColors.accentShadow : null,
                    ),
                    child: const Icon(Icons.image_outlined, size: 28, color: AppColors.textHint),
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

// ─── Action Button ──────────────────────────────
class _ActionButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;
  final EdgeInsets? margin;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        boxShadow: AppColors.cardShadow,
      ),
      child: IconButton(icon: icon, onPressed: onTap),
    );
  }
}

// ─── Delivery Info Strip ────────────────────────
class _DeliveryInfoStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          _DeliveryItem(
            icon: Icons.local_shipping_outlined,
            label: 'Free Delivery',
            sub: 'Orders above \$50',
            color: AppColors.info,
          ),
          Container(width: 1, height: 40, color: AppColors.divider),
          _DeliveryItem(
            icon: Icons.replay_outlined,
            label: 'Easy Return',
            sub: '30 day policy',
            color: AppColors.success,
          ),
          Container(width: 1, height: 40, color: AppColors.divider),
          _DeliveryItem(
            icon: Icons.verified_outlined,
            label: 'Authentic',
            sub: '100% genuine',
            color: AppColors.accent,
          ),
        ],
      ),
    );
  }
}

class _DeliveryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final Color color;

  const _DeliveryItem({
    required this.icon,
    required this.label,
    required this.sub,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(label, style: AppTypography.labelSmall.copyWith(fontSize: 10)),
          Text(
            sub,
            style: AppTypography.labelSmall.copyWith(
              fontSize: 9,
              color: AppColors.textHint,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Bottom Bar ─────────────────────────────────
class _ProductBottomBar extends StatefulWidget {
  const _ProductBottomBar();

  @override
  State<_ProductBottomBar> createState() => _ProductBottomBarState();
}

class _ProductBottomBarState extends State<_ProductBottomBar> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        AppSpacing.lg,
        AppSpacing.pagePadding,
        AppSpacing.pagePadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppRadius.xxl),
          topRight: Radius.circular(AppRadius.xxl),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          QuantityControl(
            quantity: _qty,
            onIncrement: () => setState(() => _qty++),
            onDecrement: () {
              if (_qty > 1) setState(() => _qty--);
            },
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: GradientButton(
              label: AppStrings.addToCart,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared Widgets ─────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTypography.h3);
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(color: AppColors.divider, height: 1);
  }
}

class _SpecRow extends StatelessWidget {
  final String label;
  final String value;

  const _SpecRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(label, style: AppTypography.labelMedium.copyWith(color: AppColors.textHint)),
          ),
          Text(value, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// REVIEW ITEM
// ═══════════════════════════════════════════════
class ReviewItem extends StatelessWidget {
  final String name;
  final double rating;
  final String comment;
  final String? date;

  const ReviewItem({
    super.key,
    required this.name,
    required this.rating,
    required this.comment,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.accent.withOpacity(0.12),
            child: Text(
              name[0],
              style: AppTypography.labelLarge.copyWith(color: AppColors.accent),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: AppTypography.labelLarge),
                    const Spacer(),
                    RatingStars(rating: rating, showLabel: false, size: 12),
                  ],
                ),
                if (date != null) ...[
                  const SizedBox(height: 2),
                  Text(date!, style: AppTypography.labelSmall.copyWith(color: AppColors.textHint)),
                ],
                const SizedBox(height: 4),
                Text(
                  comment,
                  style: AppTypography.bodySmall.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}