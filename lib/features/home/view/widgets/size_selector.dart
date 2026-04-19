import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';

class SizeSelector extends StatelessWidget {
  final List<String> sizes;
  final String selected;
  final ValueChanged<String> onSelect;

  const SizeSelector({super.key, 
    required this.sizes,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: sizes.map((s) {
        final isSelected = selected == s;
        return GestureDetector(
          onTap: () => onSelect(s),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              gradient: isSelected ? AppColors.accentGradient : null,
              color: isSelected ? null : AppColors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: isSelected ? AppColors.accentShadow : AppColors.cardShadow,
            ),
            child: Center(
              child: Text(
                s,
                style: AppTypography.labelMedium.copyWith(
                  color: isSelected ? AppColors.white : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
