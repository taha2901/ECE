// lib/features/payment/view/card_payment_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_cubit.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_state.dart';
import 'package:real_ecommerce/features/payment/logic/cubit.dart';
import 'package:real_ecommerce/features/payment/logic/states.dart';

class CardPaymentScreen extends StatefulWidget {
  const CardPaymentScreen({super.key});

  @override
  State<CardPaymentScreen> createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  bool _cardComplete = false;
  bool _saveCard = false;
  int _selectedMethod = 0; // 0 = Card, 1 = Google Pay

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startCheckout();
      // إغلق الكيبوردة عند دخول صفحة الدفع
      FocusScope.of(context).unfocus();
    });
  }

  void _startCheckout() {
    final s = context.read<CheckoutCubit>().state;
    final total = (s.cartTotal?.totalAsDouble ?? 0) +
        (s.shippingFee ?? 10) +
        (s.tax ?? 0);
    context.read<PaymentCubit>().createIntent(totalAmount: total);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentCubit, PaymentState>(
      listener: (context, state) async {
        if (state is PaymentSuccess) {
          final checkoutCubit = context.read<CheckoutCubit>();
          final goToSuccess = GoRouter.of(context).go;
          final messenger = ScaffoldMessenger.of(context);
          await checkoutCubit.createOrder();
          if (!mounted) return;
          if (checkoutCubit.state.status == CheckoutStatus.orderCreated) {
            goToSuccess(AppRoutes.paymentSuccess);
          } else {
            messenger.showSnackBar(SnackBar(
              content: Text(
                  checkoutCubit.state.errorMessage ?? 'Order failed. Please try again.'),
              backgroundColor: AppColors.error,
            ));
          }
        }
        if (state is PaymentFailure) _showError(state.message);
        if (state is CheckoutFailure) _showError(state.message, retry: true);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: const Text('Secure Payment'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              context.read<PaymentCubit>().reset();
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.enhancedCheckout);
              }
            },
          ),
        ),
        body: BlocBuilder<PaymentCubit, PaymentState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.pagePadding,
                      AppSpacing.pagePadding,
                      AppSpacing.pagePadding,
                      AppSpacing.pagePadding + MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _OrderSummaryCard(),
                        const SizedBox(height: AppSpacing.xl),
                        _PaymentMethodTabs(
                          selected: _selectedMethod,
                          onTap: (i) => setState(() => _selectedMethod = i),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        _buildBody(state),
                      ],
                    ),
                  ),
                ),
                _BottomPayButton(
                  cardComplete: _cardComplete,
                  selectedMethod: _selectedMethod,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(PaymentState state) {
    if (state is PaymentInitial || state is CheckoutLoading) {
      return const _LoadingView();
    }
    if (state is CheckoutFailure) {
      return _ErrorView(message: state.message, onRetry: _startCheckout);
    }

    if (_selectedMethod == 0) {
      return _CardFormView(
        saveCard: _saveCard,
        onSaveCardChanged: (v) => setState(() => _saveCard = v),
        onCardChanged: (complete) {
          setState(() => _cardComplete = complete);
        },
      );
    } else {
      return const _GooglePayView();
    }
  }

  void _showError(String message, {bool retry = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppTypography.bodySmall),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        action: retry
            ? SnackBarAction(
                label: 'Retry',
                textColor: AppColors.white,
                onPressed: _startCheckout,
              )
            : null,
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// Payment Method Tabs
// ══════════════════════════════════════════════════════
class _PaymentMethodTabs extends StatelessWidget {
  final int selected;
  final void Function(int) onTap;

  const _PaymentMethodTabs({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _Tab(
            icon: Icons.credit_card_rounded,
            label: 'Credit Card',
            isSelected: selected == 0,
            onTap: () => onTap(0),
          ),
          _Tab(
            icon: Icons.g_mobiledata_rounded,
            label: 'Google Pay',
            isSelected: selected == 1,
            onTap: () => onTap(1),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _Tab({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppDurations.normal,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: isSelected ? AppColors.cardShadow : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18,
                  color: isSelected ? AppColors.accent : AppColors.textHint),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: isSelected ? AppColors.accent : AppColors.textHint,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// Card Form View
// ══════════════════════════════════════════════════════
class _CardFormView extends StatefulWidget {
  final void Function(bool isComplete) onCardChanged;
  final bool saveCard;
  final void Function(bool) onSaveCardChanged;

  const _CardFormView({
    required this.onCardChanged,
    required this.saveCard,
    required this.onSaveCardChanged,
  });

  @override
  State<_CardFormView> createState() => _CardFormViewState();
}

class _CardFormViewState extends State<_CardFormView> {
  // للعرض البصري على الكارت فقط
  String _displayNumber = '•••• •••• •••• ••••';
  String _displayExpiry = 'MM / YY';
  String _displayHolder = 'YOUR NAME';
  late final TextEditingController _holderController;

  @override
  void initState() {
    super.initState();
    _holderController = TextEditingController();
    _holderController.addListener(() {
      setState(() {
        _displayHolder = _holderController.text.isEmpty
            ? 'YOUR NAME'
            : _holderController.text.toUpperCase();
      });
    });
  }

  @override
  void dispose() {
    _holderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Credit Card Visual (جمالي فقط) ──────────
        _CreditCardVisual(
          number: _displayNumber,
          expiry: _displayExpiry,
          holder: _displayHolder,
        ),
        const SizedBox(height: AppSpacing.xl),

        // ── Header ───────────────────────────────────
        Row(
          children: [
            const Icon(Icons.lock_outline_rounded,
                size: 16, color: AppColors.accent),
            const SizedBox(width: AppSpacing.sm),
            Text('Card Details', style: AppTypography.labelLarge),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                children: [
                  const Icon(Icons.security_rounded,
                      size: 12, color: AppColors.success),
                  const SizedBox(width: 4),
                  Text('SSL Secured',
                      style: AppTypography.labelSmall.copyWith(
                          color: AppColors.success, fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        // ── Card holder field ───────────────────────
        const SizedBox(height: AppSpacing.xl),
        AppTextField(
          controller: _holderController,
          label: 'Card Holder',
          hint: 'Name on card',
          prefixIcon: Icons.person_outline_rounded,
        ),
        const SizedBox(height: AppSpacing.xl),

        // ── Stripe CardField (الوحيد — هو اللي بيعمل الدفع) ──
        _StyledFieldBox(
          child: SizedBox(
            height: 54,
            child: CardField(
              onCardChanged: (details) {
                final complete = details?.complete ?? false;
                setState(() {
                  _displayNumber = details?.last4 != null
                      ? '•••• •••• •••• ${details!.last4}'
                      : '•••• •••• •••• ••••';
                  if (details?.expiryMonth != null &&
                      details?.expiryYear != null) {
                    final month = details!.expiryMonth!.toString().padLeft(2, '0');
                    final year = details.expiryYear!.toString();
                    _displayExpiry = year.length == 4
                        ? '$month / ${year.substring(year.length - 2)}'
                        : '$month / $year';
                  } else {
                    _displayExpiry = 'MM / YY';
                  }
                });
                widget.onCardChanged(complete);
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // ── Save Card Toggle ──────────────────────────
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.04),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.accent.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(Icons.bookmark_outline_rounded,
                    size: 18, color: AppColors.accent),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Save card for later',
                        style: AppTypography.labelSmall),
                    Text('Secured via Stripe Vault',
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.textHint)),
                  ],
                ),
              ),
              Switch(
                value: widget.saveCard,
                onChanged: widget.onSaveCardChanged,
                activeColor: AppColors.accent,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // ── Security Badges ───────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Badge(Icons.verified_user_outlined, 'PCI DSS'),
            const SizedBox(width: AppSpacing.md),
            _Badge(Icons.lock_outline_rounded, 'Encrypted'),
            const SizedBox(width: AppSpacing.md),
            _Badge(Icons.replay_rounded, '3D Secure'),
          ],
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════
// Credit Card Visual (عرض جمالي فقط)
// ══════════════════════════════════════════════════════
class _CreditCardVisual extends StatelessWidget {
  final String number;
  final String expiry;
  final String holder;

  const _CreditCardVisual({
    required this.number,
    required this.expiry,
    required this.holder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 190,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A2E).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // دوائر الخلفية
          Positioned(
            top: -30,
            right: -20,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withOpacity(0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: 40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withOpacity(0.08),
              ),
            ),
          ),

          // المحتوى
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // شعار + Chip
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'LuxeStore',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Container(
                      width: 36,
                      height: 26,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.85),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                // رقم الكارت
                Text(
                  number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    letterSpacing: 3,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 12),

                // اسم + تاريخ + لوجو
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CardLabel('CARD HOLDER', holder),
                    _CardLabel('EXPIRES', expiry),
                    // Mastercard logo
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEB001B),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(-10, 0),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color:
                                  const Color(0xFFF79E1B).withOpacity(0.85),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardLabel extends StatelessWidget {
  final String label;
  final String value;
  const _CardLabel(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 9,
                letterSpacing: 1)),
        Text(value,
            style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 13,
                letterSpacing: 1)),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════
// Google Pay View
// ══════════════════════════════════════════════════════
class _GooglePayView extends StatelessWidget {
  const _GooglePayView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, PaymentState>(
      builder: (context, state) {
        final clientSecret =
            state is CheckoutSuccess ? state.clientSecret : null;

        return Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            children: [
              const Icon(Icons.g_mobiledata_rounded,
                  size: 48, color: AppColors.accent),
              const SizedBox(height: AppSpacing.md),
              Text('Google Pay', style: AppTypography.h3),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Fast and secure payment with your Google account',
                style: AppTypography.bodySmall
                    .copyWith(color: AppColors.textHint),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              if (clientSecret != null)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: PlatformPayButton(
                    onPressed: () async =>
                        await _payWithGooglePay(context, clientSecret),
                    type: PlatformButtonType.pay,
                  ),
                )
              else
                const CircularProgressIndicator(
                    color: AppColors.accent, strokeWidth: 2),
            ],
          ),
        );
      },
    );
  }

  Future<void> _payWithGooglePay(
      BuildContext context, String clientSecret) async {
    try {
      await Stripe.instance.confirmPlatformPayPaymentIntent(
        clientSecret: clientSecret,
        confirmParams: const PlatformPayConfirmParams.googlePay(
          googlePay: GooglePayParams(
            testEnv: true,
            merchantName: 'LuxeStore',
            merchantCountryCode: 'US',
            currencyCode: 'USD',
          ),
        ),
      );
      if (!context.mounted) return;
      final checkoutCubit = context.read<CheckoutCubit>();
      final goToSuccess = GoRouter.of(context).go;
      final messenger = ScaffoldMessenger.of(context);
      await checkoutCubit.createOrder();
      if (!context.mounted) return;
      final checkoutState = checkoutCubit.state;
      if (checkoutState.status == CheckoutStatus.orderCreated) {
        goToSuccess(AppRoutes.paymentSuccess);
      } else {
        messenger.showSnackBar(SnackBar(
          content: Text(
              checkoutState.errorMessage ?? 'Order failed. Please try again.'),
          backgroundColor: AppColors.error,
        ));
      }
    } on StripeException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.error.localizedMessage ?? 'Google Pay failed'),
          backgroundColor: AppColors.error,
        ));
      }
    }
  }
}

// ══════════════════════════════════════════════════════
// Order Summary Card
// ══════════════════════════════════════════════════════
class _OrderSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        final cartTotal = state.cartTotal;
        if (cartTotal == null) return const SizedBox.shrink();

        final subtotal = cartTotal.totalAsDouble;
        final shipping = state.shippingFee ?? 10.0;
        final tax = state.tax ?? 0.0;
        final total = subtotal + shipping + tax;

        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.receipt_long_outlined, size: 18),
                  const SizedBox(width: AppSpacing.sm),
                  Text('Order Summary', style: AppTypography.labelLarge),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              const Divider(),
              const SizedBox(height: AppSpacing.sm),
              _SummaryRow('Items (${cartTotal.items.length})',
                  '\$${subtotal.toStringAsFixed(2)}'),
              _SummaryRow('Shipping', '\$${shipping.toStringAsFixed(2)}'),
              _SummaryRow('Tax', '\$${tax.toStringAsFixed(2)}'),
              const SizedBox(height: AppSpacing.sm),
              const Divider(),
              const SizedBox(height: AppSpacing.sm),
              _SummaryRow('Total', '\$${total.toStringAsFixed(2)}',
                  isBold: true),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _SummaryRow(this.label, this.value, {this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: isBold
                  ? AppTypography.labelLarge
                  : AppTypography.bodyMedium
                      .copyWith(color: AppColors.textHint)),
          Text(value,
              style: isBold
                  ? AppTypography.labelLarge.copyWith(
                      color: AppColors.accent, fontWeight: FontWeight.bold)
                  : AppTypography.bodyMedium),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// Loading View
// ══════════════════════════════════════════════════════
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(
              color: AppColors.accent, strokeWidth: 2),
          const SizedBox(height: AppSpacing.lg),
          Text('Preparing your order…',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textHint)),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// Error View
// ══════════════════════════════════════════════════════
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline_rounded, color: AppColors.error, size: 40),
          const SizedBox(height: AppSpacing.md),
          Text(message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium),
          const SizedBox(height: AppSpacing.lg),
          GradientButton(label: 'Retry', onTap: onRetry),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// Bottom Pay Button
// ══════════════════════════════════════════════════════
class _BottomPayButton extends StatelessWidget {
  final bool cardComplete;
  final int selectedMethod;

  const _BottomPayButton({
    required this.cardComplete,
    required this.selectedMethod,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, PaymentState>(
      builder: (context, state) {
        if (selectedMethod == 1) return const SizedBox.shrink();

        final isLoading = state is PaymentLoading;
        final isReady = state is CheckoutSuccess || state is PaymentFailure;
        final canPay = isReady && cardComplete && !isLoading;

        return Container(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state is PaymentFailure)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: AppColors.error, size: 16),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(state.message,
                              style: AppTypography.bodySmall
                                  .copyWith(color: AppColors.error)),
                        ),
                      ],
                    ),
                  ),
                ),
              GradientButton(
                label: isLoading ? 'Processing…' : 'Pay Now',
                onTap: canPay ? () => _pay(context) : null,
              ),
            ],
          ),
        );
      },
    );
  }

  void _pay(BuildContext context) {
    final s = context.read<CheckoutCubit>().state;
    context.read<PaymentCubit>().confirmPayment(
          name:
              '${s.firstName ?? ''} ${s.lastName ?? ''}'.trim(),
          email: s.email ?? '',
        );
  }
}

// ══════════════════════════════════════════════════════
// Helpers
// ══════════════════════════════════════════════════════
class _StyledFieldBox extends StatelessWidget {
  final Widget child;
  const _StyledFieldBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Badge(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.textHint),
        const SizedBox(width: 4),
        Text(label,
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textHint, fontSize: 10)),
      ],
    );
  }
}