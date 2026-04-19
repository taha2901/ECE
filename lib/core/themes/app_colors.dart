import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Palette - Deep Indigo + Teal Accent (Professional E-commerce)
  static const Color primary = Color(0xFF1B1B3A);        // أغمق من قبل
  static const Color primaryVariant = Color(0xFF151A35); 
  static const Color secondary = Color(0xFF0D274D);      // أعمق وأكثر عمق
  static const Color accent = Color(0xFF008080);         // Teal غامق وراقي
  static const Color accentLight = Color(0xFF00B2B2);    // Gradient خفيف للaccent

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF4F5FB);     // فاتح ونظيف
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFE8EBF7); 
  static const Color divider = Color(0xFFDDE1EB);

  // Text
  static const Color textPrimary = Color(0xFF1B1B3A);    // عميق واحترافي
  static const Color textSecondary = Color(0xFF5E6478);  // محايد وهادئ
  static const Color textHint = Color(0xFFA0A6B2);       // أنعم من قبل
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
    colors: [primary, secondary],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentLight],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF5C6BC0), Color(0xFF7B5EB3)], // Gradient أعمق للكروت
  );

  // Shadows (not const because we use opacity)
  static final List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0xFF1B1B3A).withOpacity(0.08),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  static final List<BoxShadow> accentShadow = [
    BoxShadow(
      color: Color(0xFF008080).withOpacity(0.35),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  // Stars / Rating
  static const Color starFilled = Color(0xFFFBBF24);
  static const Color starEmpty = Color(0xFFE5E7EB);

  // Admin Dashboard
  static const Color adminPrimary = Color(0xFF1E293B);
  static const Color adminSidebar = Color(0xFF0F172A);
  static const Color adminAccent = Color(0xFF6366F1);
  static const Color adminCard = Color(0xFF1E293B);
}