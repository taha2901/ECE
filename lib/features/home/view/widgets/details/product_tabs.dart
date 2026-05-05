import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';

// ══════════════════════════════════════════════
// STYLED TAB BAR
// ══════════════════════════════════════════════
class StyledTabBar extends StatelessWidget {
  final TabController controller;

  const StyledTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          gradient: AppColors.accentGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppColors.accentShadow,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AppColors.white,
        unselectedLabelColor: AppColors.textHint,
        labelStyle: AppTypography.labelMedium.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
        unselectedLabelStyle:
            AppTypography.labelMedium.copyWith(fontSize: 13),
        padding: const EdgeInsets.all(4),
        tabs: const [
          Tab(text: 'Description'),
          Tab(text: 'Specs'),
          Tab(text: 'Reviews'),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// TAB CONTENT
// ══════════════════════════════════════════════
class DescriptionTab extends StatelessWidget {
  final String description;

  const DescriptionTab({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Text(
        description.isEmpty ? 'No description available' : description,
        style: AppTypography.bodyMedium.copyWith(height: 1.7, fontSize: 14),
      ),
    );
  }
}

class SpecsTab extends StatelessWidget {
  const SpecsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final specs = [
      ('Material', 'Premium Mesh + Rubber'),
      ('Weight', '280g'),
      ('Origin', 'Vietnam'),
      ('Care', 'Machine washable'),
      ('Warranty', '1 Year'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: specs.map((s) => SpecRow(label: s.$1, value: s.$2)).toList(),
    );
  }
}

class ReviewsTab extends StatelessWidget {
  final double rating;
  final int reviewsCount;

  const ReviewsTab({
    super.key,
    required this.rating,
    required this.reviewsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.star_rounded,
                color: Color(0xFFF59E0B), size: 20),
            const SizedBox(width: 8),
            Text('$rating', style: AppTypography.labelLarge),
            const SizedBox(width: 8),
            Text('($reviewsCount reviews)',
                style: AppTypography.bodySmall),
          ],
        ),
        const SizedBox(height: 16),
        if (reviewsCount == 0)
          Center(
            child: Text('No reviews yet', style: AppTypography.bodyMedium),
          ),
      ],
    );
  }
}

// ══════════════════════════════════════════════
// SPEC ROW
// ══════════════════════════════════════════════
class SpecRow extends StatelessWidget {
  final String label;
  final String value;

  const SpecRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: AppTypography.labelMedium
                  .copyWith(color: AppColors.textHint),
            ),
          ),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// REVIEW ITEM
// ══════════════════════════════════════════════
class ReviewItem extends StatelessWidget {
  final String name;
  final double rating;
  final String comment;
  final String? date;
  final String? avatarUrl;

  const ReviewItem({
    super.key,
    required this.name,
    required this.rating,
    required this.comment,
    this.date,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: avatarUrl != null
                ? Image.network(
                    avatarUrl!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        _FallbackAvatar(name: name),
                  )
                : _FallbackAvatar(name: name),
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
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < rating.round()
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 13,
                          color: i < rating.round()
                              ? AppColors.starFilled
                              : AppColors.starEmpty,
                        ),
                      ),
                    ),
                  ],
                ),
                if (date != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    date!,
                    style: AppTypography.labelSmall
                        .copyWith(color: AppColors.textHint),
                  ),
                ],
                const SizedBox(height: 6),
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

class _FallbackAvatar extends StatelessWidget {
  final String name;

  const _FallbackAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      color: AppColors.accent.withOpacity(0.12),
      child: Center(
        child: Text(
          name[0].toUpperCase(),
          style:
              AppTypography.labelLarge.copyWith(color: AppColors.accent),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
// MISC SHARED
// ══════════════════════════════════════════════
class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key});

  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: AppColors.divider);
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.h3.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
    );
  }
}