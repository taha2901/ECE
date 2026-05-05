import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';

const _kSteps = ['Customer', 'Shipping', 'Payment', 'Review'];

// ══════════════════════════════════════════════════════
// HORIZONTAL — مناسب للموبايل (AppBar تحته)
// ══════════════════════════════════════════════════════
class CheckoutStepIndicatorHorizontal extends StatelessWidget {
  final int currentStep;

  const CheckoutStepIndicatorHorizontal({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: Column(
        children: [
          Row(
            children: List.generate(_kSteps.length * 2 - 1, (i) {
              // connector line
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
                    _kSteps[step],
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
            'Step ${currentStep + 1} of ${_kSteps.length}',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// VERTICAL — مناسب للديسكتوب (sidebar على الشمال)
// ══════════════════════════════════════════════════════
class CheckoutStepIndicatorVertical extends StatelessWidget {
  final int currentStep;

  const CheckoutStepIndicatorVertical({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(_kSteps.length * 2 - 1, (i) {
        // connector line بين الـ steps
        if (i.isOdd) {
          final stepBefore = i ~/ 2;
          return Padding(
            padding: const EdgeInsets.only(left: 17), // محاذاة مع مركز الدايرة
            child: Container(
              width: 2,
              height: 32,
              color: stepBefore < currentStep
                  ? AppColors.accent
                  : AppColors.divider,
            ),
          );
        }

        final step = i ~/ 2;
        final isCompleted = step < currentStep;
        final isCurrent = step == currentStep;

        return Row(
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
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _kSteps[step],
                  style: AppTypography.labelLarge.copyWith(
                    color: isCurrent
                        ? AppColors.accent
                        : isCompleted
                            ? AppColors.textPrimary
                            : AppColors.textHint,
                  ),
                ),
                if (isCurrent)
                  Text(
                    'In progress',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                if (isCompleted)
                  Text(
                    'Completed',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.success,
                    ),
                  ),
              ],
            ),
          ],
        );
      }),
    );
  }
}