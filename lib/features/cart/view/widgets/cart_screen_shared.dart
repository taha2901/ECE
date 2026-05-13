import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';
import 'package:real_ecommerce/features/cart/logic/cubit.dart';
import 'package:real_ecommerce/features/cart/logic/states.dart';

/// رسائل الخطأ / النجاح المرتبطة بالسلة — نفس السلوك على الموبايل والديسكتوب.
class CartFeedbackListener extends StatelessWidget {
  final Widget child;

  const CartFeedbackListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state.errorMessage != null &&
            state.status == CartStatus.loaded) {
          appScaffoldMessengerKey.currentState
            ?..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.errorMessage!)),
                  ],
                ),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                duration: const Duration(seconds: 3),
              ),
            );
        }
        if (state.status == CartStatus.loaded &&
            state.message == 'Cart cleared') {
          appScaffoldMessengerKey.currentState
            ?..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle_outline,
                        color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text('Cart cleared successfully'),
                  ],
                ),
                backgroundColor: Colors.green.shade600,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
        }
      },
      child: child,
    );
  }
}

class CartEmptyView extends StatelessWidget {
  /// `true` = تخطيط أوضح على الشاشات الكبيرة.
  final bool wideLayout;

  const CartEmptyView({super.key, this.wideLayout = false});

  @override
  Widget build(BuildContext context) {
    final iconSize = wideLayout ? 100.0 : 80.0;
    final titleStyle = wideLayout ? AppTypography.h1 : AppTypography.h2;
    final subtitleStyle = wideLayout
        ? AppTypography.bodyLarge.copyWith(color: AppColors.textHint)
        : AppTypography.bodyMedium.copyWith(color: AppColors.textHint);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: iconSize, color: AppColors.textHint),
          SizedBox(height: wideLayout ? AppSpacing.xl : AppSpacing.lg),
          Text('Your cart is empty', style: titleStyle),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Add some items to get started',
            style: subtitleStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: wideLayout ? AppSpacing.xxl : AppSpacing.xl),
          if (wideLayout)
            SizedBox(
              width: 240,
              child: AppButton(
                onTap: () => context.go(AppRoutes.home),
                label: 'Continue Shopping',
                isFullWidth: true,
              ),
            )
          else
            AppButton(
              onTap: () => context.go(AppRoutes.home),
              label: 'Continue Shopping',
            ),
        ],
      ),
    );
  }
}

class CartErrorView extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;
  final bool wideLayout;

  const CartErrorView({
    super.key,
    this.message,
    required this.onRetry,
    this.wideLayout = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = wideLayout ? 80.0 : 60.0;
    final textStyle =
        wideLayout ? AppTypography.bodyLarge : AppTypography.bodyMedium;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline,
              size: iconSize, color: AppColors.textHint),
          SizedBox(height: wideLayout ? AppSpacing.xl : AppSpacing.lg),
          Text(
            message ?? 'Error loading cart',
            textAlign: TextAlign.center,
            style: textStyle,
          ),
          SizedBox(height: wideLayout ? AppSpacing.xxl : AppSpacing.xl),
          AppButton(onTap: onRetry, label: 'Retry'),
        ],
      ),
    );
  }
}
