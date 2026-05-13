import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/checkout/logic/checkout_cubit.dart';
import 'package:real_ecommerce/features/payment/logic/cubit.dart';
import 'package:real_ecommerce/features/payment/logic/payment_order_completion.dart';
import 'package:real_ecommerce/features/payment/logic/payment_totals.dart';
import 'package:real_ecommerce/features/payment/logic/states.dart';
import 'package:real_ecommerce/features/payment/view/widgets/payment_card_submit_bottom_bar.dart';
import 'package:real_ecommerce/features/payment/view/widgets/payment_google_pay_panel.dart';
import 'package:real_ecommerce/features/payment/view/widgets/payment_intent_error_card.dart';
import 'package:real_ecommerce/features/payment/view/widgets/payment_intent_loading_card.dart';
import 'package:real_ecommerce/features/payment/view/widgets/payment_method_tabs.dart';
import 'package:real_ecommerce/features/payment/view/widgets/payment_order_summary_card.dart';
import 'package:real_ecommerce/features/payment/view/widgets/payment_stripe_card_form.dart';

/// شاشة الدفع بـ Stripe: intent من السيرفر ثم كارت أو Google Pay.
class CardPaymentScreen extends StatefulWidget {
  const CardPaymentScreen({super.key});

  @override
  State<CardPaymentScreen> createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  bool _cardComplete = false;
  bool _saveCard = false;
  int _selectedMethod = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startCheckout();
      FocusScope.of(context).unfocus();
    });
  }

  void _startCheckout() {
    final checkout = context.read<CheckoutCubit>().state;
    context.read<PaymentCubit>().createIntent(
          totalAmount: checkoutGrandTotalForStripe(checkout),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentCubit, PaymentState>(
      listener: (context, state) async {
        if (state is PaymentSuccess) {
          await finalizePaidCheckoutAndNavigate(context);
        }
        if (state is PaymentFailure) _showError(state.message);
        if (state is CheckoutFailure) {
          _showError(state.message, retry: true);
        }
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
                      AppSpacing.pagePadding +
                          MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const PaymentOrderSummaryCard(),
                        const SizedBox(height: AppSpacing.xl),
                        PaymentMethodTabs(
                          selectedIndex: _selectedMethod,
                          onChanged: (i) => setState(() => _selectedMethod = i),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        _buildPaymentBody(state),
                      ],
                    ),
                  ),
                ),
                PaymentCardSubmitBottomBar(
                  cardComplete: _cardComplete,
                  selectedMethodIndex: _selectedMethod,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPaymentBody(PaymentState state) {
    if (state is PaymentInitial || state is CheckoutLoading) {
      return const PaymentIntentLoadingCard();
    }
    if (state is CheckoutFailure) {
      return PaymentIntentErrorCard(
        message: state.message,
        onRetry: _startCheckout,
      );
    }

    if (_selectedMethod == 0) {
      return PaymentStripeCardForm(
        saveCard: _saveCard,
        onSaveCardChanged: (v) => setState(() => _saveCard = v),
        onCardCompleteChanged: (complete) {
          setState(() => _cardComplete = complete);
        },
      );
    }
    return const PaymentGooglePayPanel();
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
