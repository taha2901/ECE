import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Core Palette — Obsidian + Emerald Teal
  static const Color primary = Color(0xFF0A0F1E);
  static const Color primaryVariant = Color(0xFF131929);
  static const Color secondary = Color(0xFF1C2640);
  static const Color accent = Color(0xFF00C6A7);        // vivid teal
  static const Color accentDeep = Color(0xFF009B85);
  static const Color accentLight = Color(0xFF5EECD8);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF6F8FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F3FA);
  static const Color divider = Color(0xFFE4E9F2);

  // Text
  static const Color textPrimary = Color(0xFF0D1226);
  static const Color textSecondary = Color(0xFF5B6478);
  static const Color textHint = Color(0xFFAAB2C4);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnAccent = Color(0xFFFFFFFF);

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A0F1E), Color(0xFF1C2640)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentLight],
  );

  static const LinearGradient bannerGradient1 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A0F1E), Color(0xFF1C2640)],
  );

  static const LinearGradient bannerGradient2 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00C6A7), Color(0xFF009B85)],
  );

  static const LinearGradient bannerGradient3 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6C47FF), Color(0xFF9B6DFF)],
  );

  // Shadows
  static final List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF0D1226).withOpacity(0.07),
      blurRadius: 24,
      spreadRadius: 0,
      offset: const Offset(0, 6),
    ),
  ];

  static final List<BoxShadow> accentShadow = [
    BoxShadow(
      color: const Color(0xFF00C6A7).withOpacity(0.38),
      blurRadius: 20,
      spreadRadius: 0,
      offset: const Offset(0, 8),
    ),
  ];

  static final List<BoxShadow> floatShadow = [
    BoxShadow(
      color: const Color(0xFF0D1226).withOpacity(0.12),
      blurRadius: 32,
      spreadRadius: 0,
      offset: const Offset(0, 8),
    ),
  ];

  // Stars
  static const Color starFilled = Color(0xFFFBBF24);
  static const Color starEmpty = Color(0xFFE5E7EB);
}