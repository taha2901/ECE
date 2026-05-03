import 'package:flutter/material.dart';

// ══════════════════════════════════════════════════════════
//  CATEGORY MODEL
// ══════════════════════════════════════════════════════════

class CategoryModel {
  final String id;
  final String name;
  final String nameAr;
  final String slug;
  final String image;
  final int count;
  final IconData icon;
  final Color bgColor;
  final Color activeColor;
  final Color iconColor;

  CategoryModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.slug,
    required this.image,
    required this.count,
    required this.icon,
    required this.bgColor,
    required this.activeColor,
    required this.iconColor,
  });

  String get label => nameAr.isNotEmpty ? nameAr : name;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final slug = (json['slug'] as String?) ?? '';
    final name = (json['name'] as String?) ?? '';
    final nameAr = (json['name_ar'] as String?) ?? '';

    final palette = _categoryPalette(slug, name, nameAr);

    return CategoryModel(
      id: (json['id']?.toString() ?? ''),
      name: name,
      nameAr: nameAr,
      slug: slug,
      image: (json['image'] as String?) ?? '',
      count: json['count'] is int
          ? json['count'] as int
          : int.tryParse(json['count']?.toString() ?? '') ?? 0,
      icon: palette.icon,
      bgColor: palette.bgColor,
      activeColor: palette.activeColor,
      iconColor: palette.iconColor,
    );
  }
}

// ══════════════════════════════════════════════════════════
//  CATEGORY PALETTE
// ══════════════════════════════════════════════════════════

class _CategoryPalette {
  final IconData icon;
  final Color bgColor;
  final Color activeColor;
  final Color iconColor;

  const _CategoryPalette({
    required this.icon,
    required this.bgColor,
    required this.activeColor,
    required this.iconColor,
  });
}
_CategoryPalette _categoryPalette(
    String slug, String name, String nameAr) {

  // ندمج كل النصوص في string واحد صغير عشان ندور فيه
  final all = '${slug.toLowerCase()} ${name.toLowerCase()} $nameAr';

  bool has(List<String> keys) =>
      keys.any((k) => all.contains(k.toLowerCase()));

  // 👔 رجالي
  if (has(['man', 'men', 'رجال', 'رجالي', 'azya-rj', 'male'])) {
    return const _CategoryPalette(
      icon: Icons.person_rounded,
      bgColor: Color(0xFFE0F2FE),
      activeColor: Color(0xFF0EA5E9),
      iconColor: Color(0xFF0284C7),
    );
  }

  // 👗 حريمي / نساء
  if (has(['woman', 'women', 'female', 'نسا', 'حريم', 'ladies', 'lady'])) {
    return const _CategoryPalette(
      icon: Icons.woman_rounded,
      bgColor: Color(0xFFFDF4FF),
      activeColor: Color(0xFFA855F7),
      iconColor: Color(0xFF9333EA),
    );
  }

  // 🧒 أطفالي
  if (has(['kid', 'child', 'baby', 'infant', 'أطفال', 'اطفال', 'طفل'])) {
    return const _CategoryPalette(
      icon: Icons.child_care_rounded,
      bgColor: Color(0xFFFFF7ED),
      activeColor: Color(0xFFF97316),
      iconColor: Color(0xFFEA580C),
    );
  }

  // 👟 أحذية
  if (has(['shoe', 'boot', 'footwear', 'sneaker', 'حذاء', 'احذي', 'أحذي'])) {
    return const _CategoryPalette(
      icon: Icons.directions_walk_rounded,
      bgColor: Color(0xFFF0FDF4),
      activeColor: Color(0xFF22C55E),
      iconColor: Color(0xFF16A34A),
    );
  }

  // ⌚ اكسسوارات
  if (has(['access', 'watch', 'jewelry', 'jewel',
           'اكسس', 'إكسس', 'مجوهر', 'ساعة'])) {
    return const _CategoryPalette(
      icon: Icons.watch_rounded,
      bgColor: Color(0xFFFFF1F2),
      activeColor: Color(0xFFF43F5E),
      iconColor: Color(0xFFE11D48),
    );
  }

  // 🏋️ رياضي
  if (has(['sport', 'gym', 'fitness', 'outdoor', 'hike',
           'رياض', 'خارج', 'جيم'])) {
    return const _CategoryPalette(
      icon: Icons.fitness_center_rounded,
      bgColor: Color(0xFFF0FDF4),
      activeColor: Color(0xFF22C55E),
      iconColor: Color(0xFF16A34A),
    );
  }

  // 👗 فساتين
  if (has(['dress', 'فستان', 'فساتين'])) {
    return const _CategoryPalette(
      icon: Icons.checkroom_rounded,
      bgColor: Color(0xFFFDF4FF),
      activeColor: Color(0xFFEC4899),
      iconColor: Color(0xFFDB2777),
    );
  }

  // 👕 تيشيرت
  if (has(['shirt', 'tshirt', 't-shirt', 'top', 'قميص', 'تيشيرت'])) {
    return const _CategoryPalette(
      icon: Icons.dry_cleaning_rounded,
      bgColor: Color(0xFFE0F2FE),
      activeColor: Color(0xFF0EA5E9),
      iconColor: Color(0xFF0284C7),
    );
  }

  // 🧥 جواكت
  if (has(['jacket', 'coat', 'جاكيت', 'معطف', 'بالطو'])) {
    return const _CategoryPalette(
      icon: Icons.ac_unit_rounded,
      bgColor: Color(0xFFF0FDF4),
      activeColor: Color(0xFF10B981),
      iconColor: Color(0xFF059669),
    );
  }

  // 👖 بنطلونات
  if (has(['pant', 'jean', 'trouser', 'بنطل', 'جينز'])) {
    return const _CategoryPalette(
      icon: Icons.accessibility_new_rounded,
      bgColor: Color(0xFFF1F5F9),
      activeColor: Color(0xFF64748B),
      iconColor: Color(0xFF475569),
    );
  }

  // 🧢 قبعات
  if (has(['hat', 'cap', 'قبعة', 'طاقية'])) {
    return const _CategoryPalette(
      icon: Icons.sports_baseball_rounded,
      bgColor: Color(0xFFFEFCE8),
      activeColor: Color(0xFFEAB308),
      iconColor: Color(0xFFCA8A04),
    );
  }

  // 💄 تجميل
  if (has(['beauty', 'cosmetic', 'makeup', 'skin',
           'تجميل', 'مكياج', 'عناية'])) {
    return const _CategoryPalette(
      icon: Icons.spa_rounded,
      bgColor: Color(0xFFFFF7ED),
      activeColor: Color(0xFFF97316),
      iconColor: Color(0xFFEA580C),
    );
  }

  // 📱 إلكترونيات
  if (has(['electron', 'mobile', 'phone', 'tech',
           'إلكترون', 'الكترون', 'موبايل', 'هاتف']))
    return const _CategoryPalette(
      icon: Icons.devices_rounded,
      bgColor: Color(0xFFE0F2FE),
      activeColor: Color(0xFF0EA5E9),
      iconColor: Color(0xFF0284C7),
    );

  // 🏠 منزل
  if (has(['home', 'house', 'منزل', 'بيت', 'مطبخ']))
    return const _CategoryPalette(
      icon: Icons.home_rounded,
      bgColor: Color(0xFFF0FDF4),
      activeColor: Color(0xFF22C55E),
      iconColor: Color(0xFF16A34A),
    );

  // افتراضي
  return const _CategoryPalette(
    icon: Icons.category_rounded,
    bgColor: Color(0xFFEEEDFE),
    activeColor: Color(0xFF6366F1),
    iconColor: Color(0xFF6366F1),
  );
}
