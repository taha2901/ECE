import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_theme.dart';
import 'core/constants/app_constants.dart';

void main() {
  runApp(const LuxeStoreApp());
}

class LuxeStoreApp extends StatelessWidget {
  const LuxeStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}