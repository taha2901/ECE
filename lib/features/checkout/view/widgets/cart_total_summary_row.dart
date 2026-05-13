import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';

class CartTotalSummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;
  final bool isBold;

  const CartTotalSummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.isHighlight = false,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: (isBold ? AppTypography.labelLarge : AppTypography.bodyMedium)
              .copyWith(
            color: isHighlight ? AppColors.accent : AppColors.textPrimary,
          ),
        ),
        Text(
          value,
          style: (isBold ? AppTypography.h3 : AppTypography.bodyMedium)
              .copyWith(
            color: isHighlight ? AppColors.accent : AppColors.textPrimary,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
