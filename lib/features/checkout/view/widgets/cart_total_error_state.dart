import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_cubit.dart';

class CartTotalErrorState extends StatelessWidget {
  final String? message;

  const CartTotalErrorState({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message ?? 'Failed to load cart',
            textAlign: TextAlign.center,
            style: AppTypography.labelLarge,
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(
            onPressed: () {
              context.read<CheckoutCubit>().loadCartTotal();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
