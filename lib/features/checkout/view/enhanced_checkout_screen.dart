import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/helpers/responsive.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/features/auth/logic/cubit.dart';
import 'package:real_ecommerce/features/auth/logic/states.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_cubit.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_state.dart';
import 'package:real_ecommerce/features/checkout/view/checkout_screen_desktop.dart';
import 'package:real_ecommerce/features/checkout/view/checkout_screen_mobile.dart';
import 'package:real_ecommerce/features/checkout/view/widgets/checkout_cancel_dialog.dart';

// ═══════════════════════════════════════════════
// ENHANCED CHECKOUT SCREEN — entry point
// كل الـ logic هنا، مفيش UI خالص
// ═══════════════════════════════════════════════
class EnhancedCheckoutScreen extends StatefulWidget {
  const EnhancedCheckoutScreen({super.key});

  @override
  State<EnhancedCheckoutScreen> createState() => _EnhancedCheckoutScreenState();
}

class _EnhancedCheckoutScreenState extends State<EnhancedCheckoutScreen> {
  int _currentStep = 0;
  bool _loaded = false;

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _zipCodeController;

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
      // ✅ احصل على بيانات المستخدم من الـ auth وانتظر قليلاً لتحديث الحالة
      context.read<CheckoutCubit>().loadUserDataFromAuth();
      
      // ✅ انتظر frame واحد ثم تأكد من تحديث الـ controllers
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateControllersFromCheckoutState();
      });
      
      _loaded = true;
    }
  }

  /// تحديث الـ controllers من CheckoutState
  void _updateControllersFromCheckoutState() {
    try {
      final checkoutState = context.read<CheckoutCubit>().state;
      _populateControllersFromState(checkoutState);
    } catch (e) {
      // ignore
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

  // ── Navigation Logic ─────────────────────────
  void _handleBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      context.canPop() ? context.pop() : context.go(AppRoutes.home);
    }
  }

  void _handleCancel() {
    showCheckoutCancelDialog(context);
  }

  void _handleNext() {
    // Validation
    if (_currentStep == 0) {
      if (_firstNameController.text.isEmpty ||
          _lastNameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _phoneController.text.isEmpty) {
        _showError('Please fill in all required fields');
        return;
      }
      context.read<CheckoutCubit>().updateUserData(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
      );
    } else if (_currentStep == 1) {
      if (_addressController.text.isEmpty || _cityController.text.isEmpty) {
        _showError('Please fill in all required fields');
        return;
      }
      context.read<CheckoutCubit>().updateUserData(
        address: _addressController.text,
        city: _cityController.text,
        zipCode: _zipCodeController.text.isNotEmpty ? _zipCodeController.text : null,
      );
    } else if (_currentStep == 2) {
      context.read<CheckoutCubit>().updatePaymentInfo(
        shippingFee: 10.0,
        tax: 0.0,
      );
    }

    if (_currentStep < 3) setState(() => _currentStep++);
  }

  // void _handlePlaceOrder() {
  //   context.read<CheckoutCubit>().createOrder();
  // }

  void _handlePlaceOrder() {
    final state = context.read<CheckoutCubit>().state;

    if (state.paymentMethod == 'card') {
      context.go(AppRoutes.payment); // ← روح شاشة الكارت
    } else {
      context.read<CheckoutCubit>().createOrder(); // ← كاش عادي
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, authState) {
        if (authState.status == AuthStatus.success) {
          context.read<CheckoutCubit>().loadUserDataFromAuth();
        }
      },
      child: BlocListener<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state.errorMessage != null) _showError(state.errorMessage!);

          if (state.status == CheckoutStatus.orderCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Order placed successfully!'),
                backgroundColor: AppColors.success,
              ),
            );
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) context.go(AppRoutes.home);
            });
          }

          _populateControllersFromState(state);
        },
        child: Responsive(
          mobile: EnhancedCheckoutMobile(
            currentStep: _currentStep,
            firstNameController: _firstNameController,
            lastNameController: _lastNameController,
            emailController: _emailController,
            phoneController: _phoneController,
            addressController: _addressController,
            cityController: _cityController,
            zipCodeController: _zipCodeController,
            onBack: _handleBack,
            onCancel: _handleCancel,
            onNext: _handleNext,
            onPlaceOrder: _handlePlaceOrder,
          ),
          desktop: EnhancedCheckoutDesktop(
            currentStep: _currentStep,
            firstNameController: _firstNameController,
            lastNameController: _lastNameController,
            emailController: _emailController,
            phoneController: _phoneController,
            addressController: _addressController,
            cityController: _cityController,
            zipCodeController: _zipCodeController,
            onBack: _handleBack,
            onCancel: _handleCancel,
            onNext: _handleNext,
            onPlaceOrder: _handlePlaceOrder,
          ),
        ),
      ),
    );
  }

  void _populateControllersFromState(CheckoutState state) {
    if (_firstNameController.text.isEmpty &&
        (state.firstName?.isNotEmpty ?? false)) {
      _firstNameController.text = state.firstName!;
    }
    if (_lastNameController.text.isEmpty &&
        (state.lastName?.isNotEmpty ?? false)) {
      _lastNameController.text = state.lastName!;
    }
    if (_emailController.text.isEmpty && (state.email?.isNotEmpty ?? false)) {
      _emailController.text = state.email!;
    }
    if (_phoneController.text.isEmpty && (state.phone?.isNotEmpty ?? false)) {
      _phoneController.text = state.phone!;
    }
    if (_addressController.text.isEmpty &&
        (state.address?.isNotEmpty ?? false)) {
      _addressController.text = state.address!;
    }
    if (_cityController.text.isEmpty && (state.city?.isNotEmpty ?? false)) {
      _cityController.text = state.city!;
    }
    if (_zipCodeController.text.isEmpty &&
        (state.zipCode?.isNotEmpty ?? false)) {
      _zipCodeController.text = state.zipCode!;
    }
  }
}
