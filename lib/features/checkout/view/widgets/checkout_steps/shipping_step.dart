import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_cubit.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_state.dart';
import 'package:real_ecommerce/features/checkout/view/widgets/checkout_text_feld.dart';

class ShippingStep extends StatelessWidget {
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController zipCodeController;

  const ShippingStep({
    super.key,
    required this.addressController,
    required this.cityController,
    required this.zipCodeController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        // ✅ تحديث الـ controllers إذا كانت فارغة والـ state لديه بيانات
        if (addressController.text.isEmpty) {
          addressController.text = state.address ?? '';
        }
        if (cityController.text.isEmpty) {
          cityController.text = state.city ?? '';
        }
        if (zipCodeController.text.isEmpty) {
          zipCodeController.text = state.zipCode ?? '';
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Shipping Address', style: AppTypography.h2),
            const SizedBox(height: AppSpacing.xl),
            CheckoutTextField(
              label: 'Address *',
              controller: addressController,
              hint: 'Enter your address',
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CheckoutTextField(
                    label: 'City *',
                    controller: cityController,
                    hint: 'City',
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: CheckoutTextField(
                    label: 'Zip Code',
                    controller: zipCodeController,
                    hint: 'Zip Code',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}