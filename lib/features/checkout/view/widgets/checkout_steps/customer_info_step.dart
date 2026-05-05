import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_cubit.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_state.dart';
import 'package:real_ecommerce/features/checkout/view/widgets/checkout_text_feld.dart';

class CustomerInfoStep extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  const CustomerInfoStep({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        // populate controllers من الـ state (مرة واحدة بس)
        if (firstNameController.text.isEmpty && state.firstName != null) {
          firstNameController.text = state.firstName!;
        }
        if (lastNameController.text.isEmpty && state.lastName != null) {
          lastNameController.text = state.lastName!;
        }
        if (emailController.text.isEmpty && state.email != null) {
          emailController.text = state.email!;
        }
        if (phoneController.text.isEmpty && state.phone != null) {
          phoneController.text = state.phone!;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer Information', style: AppTypography.h2),
            const SizedBox(height: AppSpacing.xl),
            CheckoutTextField(
              label: 'First Name *',
              controller: firstNameController,
              hint: 'Enter your first name',
            ),
            const SizedBox(height: AppSpacing.lg),
            CheckoutTextField(
              label: 'Last Name *',
              controller: lastNameController,
              hint: 'Enter your last name',
            ),
            const SizedBox(height: AppSpacing.lg),
            CheckoutTextField(
              label: 'Email *',
              controller: emailController,
              hint: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: AppSpacing.lg),
            CheckoutTextField(
              label: 'Phone Number *',
              controller: phoneController,
              hint: 'Enter your phone number',
              keyboardType: TextInputType.phone,
            ),
          ],
        );
      },
    );
  }
}