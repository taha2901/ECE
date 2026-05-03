import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_cubit.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_state.dart';

// ═══════════════════════════════════════════════
// ENHANCED CHECKOUT SCREEN (مراحل متعددة)
// ═══════════════════════════════════════════════
class EnhancedCheckoutScreen extends StatefulWidget {
  const EnhancedCheckoutScreen({super.key});

  @override
  State<EnhancedCheckoutScreen> createState() => _EnhancedCheckoutScreenState();
}

class _EnhancedCheckoutScreenState extends State<EnhancedCheckoutScreen> {
  int _currentStep = 0;
  bool _loaded = false;

  // Controllers للخطوة الأولى (معلومات العميل)
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  // Controllers للخطوة الثانية (الشحن)
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _zipCodeController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _zipCodeController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      final checkoutCubit = context.read<CheckoutCubit>();
      // جلب بيانات المستخدم من الـ auth
      checkoutCubit.loadUserDataFromAuth();
      _loaded = true;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  void _handleBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(AppRoutes.home);
      }
    }
  }

  void _handleCancel() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        title: const Text('Cancel Checkout?'),
        content: const Text(
          'Your progress will be lost.\nAre you sure you want to exit?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go(AppRoutes.cartTotal);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Yes, Exit'),
          ),
        ],
      ),
    );
  }

  void _handleNext() {
    if (_currentStep == 0) {
      // تحقق من صحة بيانات العميل
      if (_firstNameController.text.isEmpty ||
          _lastNameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _phoneController.text.isEmpty) {
        _showErrorSnackBar('Please fill in all required fields');
        return;
      }

      context.read<CheckoutCubit>().updateUserData(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            email: _emailController.text,
            phone: _phoneController.text,
          );
    } else if (_currentStep == 1) {
      // تحقق من صحة بيانات الشحن
      if (_addressController.text.isEmpty ||
          _cityController.text.isEmpty ||
          _zipCodeController.text.isEmpty) {
        _showErrorSnackBar('Please fill in all required fields');
        return;
      }

      context.read<CheckoutCubit>().updateUserData(
            address: _addressController.text,
            city: _cityController.text,
            zipCode: _zipCodeController.text,
          );
    } else if (_currentStep == 2) {
      // الخطوة الثالثة: تحديث معلومات الدفع
      context.read<CheckoutCubit>().updatePaymentInfo(
            shippingFee: 10.0,
            tax: 0.0,
          );
    }

    if (_currentStep < 3) {
      setState(() => _currentStep++);
    }
  }

  void _handlePlaceOrder() {
    context.read<CheckoutCubit>().createOrder();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: _handleBack,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            tooltip: 'Cancel Checkout',
            onPressed: _handleCancel,
          ),
        ],
      ),
      body: BlocListener<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            _showErrorSnackBar(state.errorMessage!);
          }

          if (state.status == CheckoutStatus.orderCreated) {
            // الانتقال لصفحة النجاح
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Order placed successfully!'),
                backgroundColor: AppColors.success,
              ),
            );
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                context.go(AppRoutes.home);
              }
            });
          }
        },
        child: Column(
          children: [
            // Step Indicator
            _StepIndicator(currentStep: _currentStep),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                child: [
                  _CustomerInfoStep(
                    firstNameController: _firstNameController,
                    lastNameController: _lastNameController,
                    emailController: _emailController,
                    phoneController: _phoneController,
                  ),
                  _ShippingStep(
                    addressController: _addressController,
                    cityController: _cityController,
                    zipCodeController: _zipCodeController,
                  ),
                  _PaymentStep(),
                  _ReviewStep(),
                ][_currentStep],
              ),
            ),

            // Button
            Container(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              color: AppColors.white,
              child: BlocBuilder<CheckoutCubit, CheckoutState>(
                builder: (context, state) {
                  final isLoading =
                      state.status == CheckoutStatus.creatingOrder;

                  if (_currentStep == 3) {
                    return GradientButton(
                      label: isLoading ? 'Placing Order...' : 'Place Order',
                      onTap: isLoading ? null : _handlePlaceOrder,
                    );
                  }

                  return GradientButton(
                    label: 'Continue',
                    onTap: _handleNext,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Step Indicator ────────────────────────────
class _StepIndicator extends StatelessWidget {
  final int currentStep;

  const _StepIndicator({required this.currentStep});

  final _steps = const ['Customer', 'Shipping', 'Payment', 'Review'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: Column(
        children: [
          Row(
            children: List.generate(_steps.length * 2 - 1, (i) {
              if (i.isOdd) {
                final stepBefore = i ~/ 2;
                return Expanded(
                  child: Container(
                    height: 2,
                    color: stepBefore < currentStep
                        ? AppColors.accent
                        : AppColors.divider,
                  ),
                );
              }
              final step = i ~/ 2;
              final isCompleted = step < currentStep;
              final isCurrent = step == currentStep;

              return Column(
                children: [
                  AnimatedContainer(
                    duration: AppDurations.normal,
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.success
                          : isCurrent
                              ? AppColors.accent
                              : AppColors.surfaceVariant,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isCompleted ? Icons.check_rounded : Icons.circle,
                      size: isCompleted ? 18 : 10,
                      color: isCompleted || isCurrent
                          ? AppColors.white
                          : AppColors.textHint,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _steps[step],
                    style: AppTypography.labelSmall.copyWith(
                      color:
                          isCurrent ? AppColors.accent : AppColors.textHint,
                    ),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Step ${currentStep + 1} of ${_steps.length}',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Step 1: Customer Info ────────────────────────────
class _CustomerInfoStep extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  const _CustomerInfoStep({
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        // populate controllers from state
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
            _buildTextField(
              label: 'First Name *',
              controller: firstNameController,
              hint: 'Enter your first name',
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildTextField(
              label: 'Last Name *',
              controller: lastNameController,
              hint: 'Enter your last name',
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildTextField(
              label: 'Email *',
              controller: emailController,
              hint: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildTextField(
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelLarge),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(
                color: AppColors.accent,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.all(AppSpacing.md),
          ),
        ),
      ],
    );
  }
}

// ─── Step 2: Shipping ────────────────────────────
class _ShippingStep extends StatelessWidget {
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController zipCodeController;

  const _ShippingStep({
    required this.addressController,
    required this.cityController,
    required this.zipCodeController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        if (addressController.text.isEmpty && state.address != null) {
          addressController.text = state.address!;
        }
        if (cityController.text.isEmpty && state.city != null) {
          cityController.text = state.city!;
        }
        if (zipCodeController.text.isEmpty && state.zipCode != null) {
          zipCodeController.text = state.zipCode!;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Shipping Address', style: AppTypography.h2),
            const SizedBox(height: AppSpacing.xl),
            _buildTextField(
              label: 'Address *',
              controller: addressController,
              hint: 'Enter your address',
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        label: 'City *',
                        controller: cityController,
                        hint: 'City',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        label: 'Zip Code *',
                        controller: zipCodeController,
                        hint: 'Zip Code',
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelLarge),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(
                color: AppColors.accent,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.all(AppSpacing.md),
          ),
        ),
      ],
    );
  }
}

// ─── Step 3: Payment ────────────────────────────
class _PaymentStep extends StatefulWidget {
  const _PaymentStep();

  @override
  State<_PaymentStep> createState() => _PaymentStepState();
}

class _PaymentStepState extends State<_PaymentStep> {
  String _selectedPayment = 'deposit';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method', style: AppTypography.h2),
        const SizedBox(height: AppSpacing.xl),
        _PaymentOption(
          title: 'Cash on Delivery',
          subtitle: 'Pay when you receive your order',
          value: 'deposit',
          groupValue: _selectedPayment,
          onChanged: (value) {
            setState(() => _selectedPayment = value ?? 'deposit');
            context.read<CheckoutCubit>().updatePaymentInfo(
                  paymentMethod: value,
                );
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _PaymentOption(
          title: 'Credit/Debit Card',
          subtitle: 'Secure payment with your card',
          value: 'card',
          groupValue: _selectedPayment,
          onChanged: (value) {
            setState(() => _selectedPayment = value ?? 'deposit');
            context.read<CheckoutCubit>().updatePaymentInfo(
                  paymentMethod: value,
                );
          },
        ),
        const SizedBox(height: AppSpacing.xl),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.05),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.accent.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.accent,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Shipping fee will be calculated based on your location.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  const _PaymentOption({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? AppColors.accentShadow : AppColors.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.accent : AppColors.divider,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.labelLarge.copyWith(
                      color: isSelected ? AppColors.accent : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Step 4: Review ────────────────────────────
class _ReviewStep extends StatelessWidget {
  const _ReviewStep();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        if (state.cartTotal == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final cartTotal = state.cartTotal!;
        final subtotal = cartTotal.totalAsDouble;
        final shipping = state.shippingFee ?? 10.0;
        final tax = state.tax ?? 0.0;
        final total = subtotal + shipping + tax;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Review', style: AppTypography.h2),
            const SizedBox(height: AppSpacing.xl),

            // Customer Info
            _ReviewSection(
              title: 'Customer Information',
              children: [
                _ReviewRow('Name', '${state.firstName} ${state.lastName}'),
                _ReviewRow('Email', state.email ?? ''),
                _ReviewRow('Phone', state.phone ?? ''),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Shipping Info
            _ReviewSection(
              title: 'Shipping Address',
              children: [
                _ReviewRow('Address', state.address ?? ''),
                _ReviewRow('City', state.city ?? ''),
                _ReviewRow('Zip Code', state.zipCode ?? ''),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Order Summary
            _ReviewSection(
              title: 'Order Summary',
              children: [
                _ReviewRow('Items', '${cartTotal.items.length}'),
                _ReviewRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
                _ReviewRow('Shipping', '\$${shipping.toStringAsFixed(2)}'),
                _ReviewRow('Tax', '\$${tax.toStringAsFixed(2)}'),
                const Divider(),
                _ReviewRow(
                  'Total',
                  '\$${total.toStringAsFixed(2)}',
                  isBold: true,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ReviewSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _ReviewSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.labelLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          ...children,
        ],
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _ReviewRow(
    this.label,
    this.value, {
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: (isBold ? AppTypography.labelLarge : AppTypography.bodyMedium)
                .copyWith(
              color: AppColors.textHint,
            ),
          ),
          Text(
            value,
            style: (isBold ? AppTypography.labelLarge : AppTypography.bodyMedium)
                .copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
