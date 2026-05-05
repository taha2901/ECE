import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/features/home/data/models/product_model.dart';

class ColorSelector extends StatelessWidget {
  final List<VariantModel> variants;
  final String selectedColor;
  final ValueChanged<String> onSelect;

  const ColorSelector({
    super.key,
    required this.variants,
    required this.selectedColor,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: variants.map((variant) {
          final color = Color(
            int.parse(variant.colorHex.replaceFirst('#', '0xFF')),
          );
          final isSelected = selectedColor == variant.colorHex;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: GestureDetector(
              onTap: () => onSelect(variant.colorHex),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.accent : Colors.grey,
                    width: isSelected ? 3 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    variant.color,
                    style: TextStyle(
                      fontSize: 10,
                      color: color == Colors.black
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
