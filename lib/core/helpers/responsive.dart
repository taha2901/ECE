import 'package:flutter/material.dart';

// ══════════════════════════════════════════════════════════
//  BREAKPOINTS
// ══════════════════════════════════════════════════════════
//  mobile  : < 600
//  tablet  : 600 – 1023
//  desktop : ≥ 1024
// ══════════════════════════════════════════════════════════

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 600;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= 600 && w < 1024;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1024;

  /// Number of grid columns that makes sense per screen size
  static int gridColumns(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 1400) return 4;
    if (w >= 1024) return 3;
    if (w >= 600) return 2;
    return 2;
  }

  /// Width of the desktop side-navigation rail
  static const double sideNavWidth = 220;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        if (constraints.maxWidth >= 1024) return desktop;
        if (constraints.maxWidth >= 600) return tablet ?? desktop;
        return mobile;
      },
    );
  }
}
