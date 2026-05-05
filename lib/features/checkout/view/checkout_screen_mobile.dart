import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_cubit.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_state.dart';
import 'package:real_ecommerce/features/checkout/view/widgets/checkout_step_indicator.dart';
import 'package:real_ecommerce/features/checkout/view/widgets/checkout_steps/customer_info_step.dart';
import 'package:real_ecommerce/features/checkout/view/widgets/checkout_steps/payment_step.dart';
import 'package:real_ecommerce/features/checkout/view/widgets/checkout_steps/review_step.dart';
import 'package:real_ecommerce/features/checkout/view/widgets/checkout_steps/shipping_step.dart';

/// Layout الموبايل:
///   AppBar → StepIndicator → ScrollableContent → BottomButton
class EnhancedCheckoutMobile extends StatelessWidget {
  final int currentStep;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController zipCodeController;
  final VoidCallback onBack;
  final VoidCallback onCancel;
  final VoidCallback onNext;
  final VoidCallback onPlaceOrder;

  const EnhancedCheckoutMobile({
    super.key,
    required this.currentStep,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
    required this.cityController,
    required this.zipCodeController,
    required this.onBack,
    required this.onCancel,
    required this.onNext,
    required this.onPlaceOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: onBack,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            tooltip: 'Cancel Checkout',
            onPressed: onCancel,
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Step Indicator ──────────────────────
          CheckoutStepIndicatorHorizontal(currentStep: currentStep),

          // ── Step Content ────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: _buildStep(),
            ),
          ),

          // ── Bottom Button ───────────────────────
          Container(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            color: AppColors.white,
            child: BlocBuilder<CheckoutCubit, CheckoutState>(
              builder: (context, state) {
                final isLoading = state.status == CheckoutStatus.creatingOrder;
                return GradientButton(
                  label: currentStep == 3
                      ? (isLoading ? 'Placing Order...' : 'Place Order')
                      : 'Continue',
                  onTap: isLoading
                      ? null
                      : currentStep == 3
                          ? onPlaceOrder
                          : onNext,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep() {
    return switch (currentStep) {
      0 => CustomerInfoStep(
          firstNameController: firstNameController,
          lastNameController: lastNameController,
          emailController: emailController,
          phoneController: phoneController,
        ),
      1 => ShippingStep(
          addressController: addressController,
          cityController: cityController,
          zipCodeController: zipCodeController,
        ),
      2 => const PaymentStep(),
      _ => const ReviewStep(),
    };
  }
}