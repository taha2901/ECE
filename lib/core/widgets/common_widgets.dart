import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import '../constants/app_constants.dart';

// ─────────────────────────────────────────────
// PRIMARY BUTTON
// ─────────────────────────────────────────────
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isFullWidth;
  final bool isOutlined;
  final IconData? icon;
  final double? height;
  final Color? backgroundColor;

  const AppButton({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.isFullWidth = true,
    this.isOutlined = false,
    this.icon,
    this.height,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height ?? 54,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onTap,
              child: _child,
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor ?? AppColors.accent,
              ),
              child: _child,
            ),
    );
  }

  Widget get _child => isLoading
      ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.white,
          ),
        )
      : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18),
              const SizedBox(width: 8),
            ],
            Text(label),
          ],
        );
}

// ─────────────────────────────────────────────
// GRADIENT BUTTON
// ─────────────────────────────────────────────
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final Gradient? gradient;
  final double? height;
  final double borderRadius;

  const GradientButton({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.gradient,
    this.height,
    this.borderRadius = AppRadius.lg,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: height ?? 54,
        decoration: BoxDecoration(
          gradient: gradient ?? AppColors.accentGradient,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: AppColors.accentShadow,
        ),
        alignment: Alignment.center,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
            : Text(
                label,
                style: AppTypography.buttonLarge.copyWith(
                  color: AppColors.white,
                ),
              ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// APP TEXT FIELD
// ─────────────────────────────────────────────
class AppTextField extends StatelessWidget {
  final String hint;
  final String? label;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final bool onlyDigits;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int maxLines;

  const AppTextField({
    super.key,
    required this.hint,
    this.label,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.onlyDigits = false,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTypography.labelLarge),
          const SizedBox(height: AppSpacing.sm),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction ??
              (maxLines > 1 ? TextInputAction.newline : TextInputAction.next),
          inputFormatters: (onlyDigits || keyboardType == TextInputType.number)
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          onFieldSubmitted: (_) {
            final action = textInputAction ??
                (maxLines > 1 ? TextInputAction.newline : TextInputAction.next);
            if (action == TextInputAction.next) {
              FocusScope.of(context).nextFocus();
            }
          },
          validator: validator,
          onChanged: onChanged,
          maxLines: maxLines,
          style: AppTypography.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.textHint, size: 20)
                : null,
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTypography.h2),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              action!,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.accent,
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// BADGE
// ─────────────────────────────────────────────
class AppBadge extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isSmall;

  const AppBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 6 : 10,
        vertical: isSmall ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.accent.withAlpha((0.12 * 255).round()),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: (isSmall ? AppTypography.labelSmall : AppTypography.labelMedium)
            .copyWith(color: textColor ?? AppColors.accent),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// LOADING WIDGET
// ─────────────────────────────────────────────
class AppLoader extends StatelessWidget {
  final Color? color;
  final double size;

  const AppLoader({super.key, this.color, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: color ?? AppColors.accent,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// EMPTY STATE
// ─────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 44, color: AppColors.textHint),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(title, style: AppTypography.h2, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle,
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: AppSpacing.xxl),
              AppButton(
                label: actionLabel!,
                onTap: onAction,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// RATING STARS
// ─────────────────────────────────────────────
class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final bool showLabel;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 14,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          return Icon(
            index < rating.floor()
                ? Icons.star_rounded
                : index < rating
                    ? Icons.star_half_rounded
                    : Icons.star_outline_rounded,
            color: AppColors.accent,
            size: size,
          );
        }),
        if (showLabel) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────
// QUANTITY CONTROL
// ─────────────────────────────────────────────
class QuantityControl extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool isSmall;

  const QuantityControl({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final btnSize = isSmall ? 28.0 : 36.0;
    final iconSize = isSmall ? 14.0 : 18.0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QtyBtn(
            icon: Icons.remove,
            onTap: onDecrement,
            size: btnSize,
            iconSize: iconSize,
          ),
          SizedBox(
            width: isSmall ? 28 : 36,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: AppTypography.labelLarge.copyWith(
                fontSize: isSmall ? 13 : 15,
              ),
            ),
          ),
          _QtyBtn(
            icon: Icons.add,
            onTap: onIncrement,
            size: btnSize,
            iconSize: iconSize,
            isAdd: true,
          ),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double iconSize;
  final bool isAdd;

  const _QtyBtn({
    required this.icon,
    required this.onTap,
    required this.size,
    required this.iconSize,
    this.isAdd = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isAdd ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: isAdd ? AppColors.white : AppColors.textPrimary,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DIVIDER WITH TEXT
// ─────────────────────────────────────────────
class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(text, style: AppTypography.labelSmall),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}