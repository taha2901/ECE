import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';

class ColorSelector extends StatelessWidget {
  final List<String> colors;
  final String selected;
  final Color Function(String) hexToColor;
  final ValueChanged<String> onSelect;

  const ColorSelector({super.key, 
    required this.colors,
    required this.selected,
    required this.hexToColor,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: colors.map((c) {
        final isSelected = selected == c;
        final color = hexToColor(c);
        return GestureDetector(
          onTap: () => onSelect(c),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            margin: const EdgeInsets.only(right: 14),
            width: isSelected ? 44 : 36,
            height: isSelected ? 44 : 36,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: AppColors.accent, width: 2.5)
                  : Border.all(color: Colors.transparent, width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(isSelected ? 0.5 : 0.25),
                  blurRadius: isSelected ? 16 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: isSelected
                ? const Icon(Icons.check_rounded,
                    color: Colors.white, size: 18)
                : null,
          ),
        );
      }).toList(),
    );
  }
}
