import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/features/home/data/models/category_model.dart';
import 'package:real_ecommerce/features/home/logic/category_cubit.dart';

class CategoryPillsRow extends StatelessWidget {
  const CategoryPillsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      buildWhen: (prev, curr) {
        if (prev is CategoryLoaded && curr is CategoryLoaded) {
          return prev.selectedId != curr.selectedId ||
              prev.categories != curr.categories;
        }
        return prev != curr;
      },
      builder: (context, state) {
        if (state is! CategoryLoaded) return const SizedBox.shrink();

        return SizedBox(
          height: 86,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: AppSpacing.pagePadding),
            itemCount: state.categories.length + 1,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              if (i == 0) {
                final isSelected = state.selectedId == 'all';
                return _AllCategoryPill(
                  isSelected: isSelected,
                  onTap: () => context.read<CategoryCubit>().selectCategory('all'),
                );
              }

              final cat = state.categories[i - 1];
              final isSelected = cat.id == state.selectedId;

              return _CategoryPillItem(
                cat: cat,
                isSelected: isSelected,
                onTap: () =>
                    context.read<CategoryCubit>().selectCategory(cat.id),
              );
            },
          ),
        );
      },
    );
  }
}


class _AllCategoryPill extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _AllCategoryPill({
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.accent : AppColors.textSecondary;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 68,
        child: Column(
          children: [
            AnimatedContainer(
              duration: AppDurations.fast,
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(
                  color: isSelected ? AppColors.accent : Colors.transparent,
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.accent.withAlpha((0.25 * 255).round()),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : AppColors.cardShadow,
              ),
              child: Icon(
                Icons.grid_view_rounded,
                size: 24,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'All',
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryPillItem extends StatelessWidget {
  final CategoryModel cat;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryPillItem({
    required this.cat,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 68,
        child: Column(
          children: [
            AnimatedContainer(
              duration: AppDurations.fast,
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected ? cat.activeColor : cat.bgColor,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(
                  color: isSelected ? cat.activeColor : Colors.transparent,
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: cat.activeColor.withAlpha((0.35 * 255).round()),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : AppColors.cardShadow,
              ),
              child: Icon(
                cat.icon,
                size: 24,
                color: isSelected ? Colors.white : cat.iconColor,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              cat.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w500,
                color:
                    isSelected ? cat.activeColor : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}