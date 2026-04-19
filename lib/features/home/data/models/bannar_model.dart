import 'package:flutter/material.dart';

// ══════════════════════════════════════════════════════════
//  BANNER MODEL
// ══════════════════════════════════════════════════════════

class BannerModel {
  final String id;
  final String tag;
  final String title;
  final String subtitle;
  final String imageUrl;
  final Color accentColor;

  const BannerModel({
    required this.id,
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.accentColor,
  });
}

// ══════════════════════════════════════════════════════════
//  MOCK DATA
// ══════════════════════════════════════════════════════════

class BannerMockData {
  BannerMockData._();

  static const List<BannerModel> banners = [
    BannerModel(
      id: 'b1',
      tag: '🔥 Hot Deal',
      title: 'Up to 50% Off',
      subtitle: 'Summer Essentials',
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&h=400&fit=crop',
      accentColor: Color(0xFF6366F1),
    ),
    BannerModel(
      id: 'b2',
      tag: '✨ Just In',
      title: 'New Season',
      subtitle: 'Explore 2025 Collection',
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&h=400&fit=crop',
      accentColor: Color(0xFF0EA5E9),
    ),
    BannerModel(
      id: 'b3',
      tag: '⚡ Flash Sale',
      title: 'Ends Tonight',
      subtitle: 'Up to 40% off Beauty',
      imageUrl: 'https://images.unsplash.com/photo-1585386959984-a4155224a1ad?w=800&h=400&fit=crop',
      accentColor: Color(0xFFEC4899),
    ),
  ];
}