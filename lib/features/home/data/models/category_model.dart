import 'package:flutter/material.dart';

// ══════════════════════════════════════════════════════════
//  CATEGORY MODEL
// ══════════════════════════════════════════════════════════

class CategoryModel {
  final String id;
  final String label;
  final IconData icon;
  final Color bgColor;
  final Color activeColor;
  final Color iconColor;

  const CategoryModel({
    required this.id,
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.activeColor,
    required this.iconColor,
  });
}

// ══════════════════════════════════════════════════════════
//  MOCK DATA
// ══════════════════════════════════════════════════════════

class CategoryMockData {
  CategoryMockData._();

  static const List<CategoryModel> categories = [
    CategoryModel(
      id: 'all',
      label: 'All',
      icon: Icons.apps_rounded,
      bgColor: Color(0xFFEEEDFE),
      activeColor: Color(0xFF6366F1),
      iconColor: Color(0xFF6366F1),
    ),
    CategoryModel(
      id: 'electronics',
      label: 'Electronics',
      icon: Icons.devices_rounded,
      bgColor: Color(0xFFE0F2FE),
      activeColor: Color(0xFF0EA5E9),
      iconColor: Color(0xFF0284C7),
    ),
    CategoryModel(
      id: 'fashion',
      label: 'Fashion',
      icon: Icons.checkroom_rounded,
      bgColor: Color(0xFFFDF4FF),
      activeColor: Color(0xFFA855F7),
      iconColor: Color(0xFF9333EA),
    ),
    CategoryModel(
      id: 'beauty',
      label: 'Beauty',
      icon: Icons.spa_rounded,
      bgColor: Color(0xFFFFF7ED),
      activeColor: Color(0xFFF97316),
      iconColor: Color(0xFFEA580C),
    ),
    CategoryModel(
      id: 'home',
      label: 'Home',
      icon: Icons.home_rounded,
      bgColor: Color(0xFFF0FDF4),
      activeColor: Color(0xFF22C55E),
      iconColor: Color(0xFF16A34A),
    ),
    CategoryModel(
      id: 'sports',
      label: 'Sports',
      icon: Icons.fitness_center_rounded,
      bgColor: Color(0xFFFFF1F2),
      activeColor: Color(0xFFF43F5E),
      iconColor: Color(0xFFE11D48),
    ),
  ];
}