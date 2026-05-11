import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/cart/data/models/cart_models.dart';
import 'package:real_ecommerce/features/cart/logic/cubit.dart';
import 'package:real_ecommerce/features/cart/view/widgets/cart_dialogs.dart';

// ══════════════════════════════════════════════════════════
//  CART ITEM CARD  —  مشتركة بين Mobile و Desktop
// ══════════════════════════════════════════════════════════

class CartItemCard extends StatefulWidget {
  final CartItemModel item;

  const CartItemCard({super.key, required this.item});

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.item.quantity;
  }

  // تحديث المحلي عند تغيير الـ item من الـ BLoC (rollback)
  @override
  void didUpdateWidget(CartItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.quantity != widget.item.quantity) {
      _quantity = widget.item.quantity;
    }
  }

  Color _parseColor(String rawColor) {
    try {
      if (rawColor.startsWith('#')) {
        return Color(int.parse(rawColor.replaceFirst('#', '0xFF')));
      }
      const named = {
        'black': Colors.black,
        'white': Colors.white,
        'red': Colors.red,
        'green': Colors.green,
        'blue': Colors.blue,
      };
      return named[rawColor.toLowerCase()] ?? AppColors.textHint;
    } catch (_) {
      return AppColors.textHint;
    }
  }

  void _increment() {
    setState(() => _quantity++);
    context.read<CartCubit>().updateCartItem(
          widget.item.id,
          _quantity,
          widget.item.size,
          widget.item.color,
        );
  }

  void _decrement() {
    if (_quantity <= 1) return;
    setState(() => _quantity--);
    context.read<CartCubit>().updateCartItem(
          widget.item.id,
          _quantity,
          widget.item.size,
          widget.item.color,
        );
  }

  Future<void> _confirmRemove() async {
    final confirmed = await showRemoveItemDialog(
      context,
      productName: widget.item.product.name,
    );
    if (confirmed == true && mounted) {
      context.read<CartCubit>().removeFromCart(widget.item.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.item.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => showRemoveItemDialog(
        context,
        productName: widget.item.product.name,
      ),
      onDismissed: (_) =>
          context.read<CartCubit>().removeFromCart(widget.item.id),

      // ── خلفية السحب (حمراء يمين→يسار) ──────────────
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.delete_outline_rounded,
                color: AppColors.error, size: 26),
            const SizedBox(height: 4),
            Text(
              'Remove',
              style: AppTypography.labelSmall.copyWith(color: AppColors.error),
            ),
          ],
        ),
      ),

      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── صورة المنتج ──────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.item.product.image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.image_outlined,
                      color: AppColors.textHint),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),

            // ── تفاصيل المنتج ────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // اسم المنتج + زرار الحذف
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.item.product.name,
                          style: AppTypography.labelLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: _confirmRemove,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // اللون والمقاس
                  Row(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: _parseColor(widget.item.color),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.textHint, width: 0.5),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.item.size,
                        style: AppTypography.labelMedium
                            .copyWith(color: AppColors.textHint),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // السعر وضبط الكمية
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.item.product.formattedPrice,
                        style: AppTypography.priceMedium,
                      ),
                      QuantityControl(
                        quantity: _quantity,
                        onIncrement: _increment,
                        onDecrement: _decrement,
                        isSmall: true,
                      ),
                    ],
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

// ══════════════════════════════════════════════════════════
//  QUANTITY CONTROL
// ══════════════════════════════════════════════════════════

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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.surfaceVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onDecrement,
            child: Padding(
              padding: EdgeInsets.all(isSmall ? 4 : 8),
              child: Icon(
                Icons.remove,
                size: isSmall ? 16 : 20,
                color: quantity <= 1 ? AppColors.textHint.withOpacity(0.4) : AppColors.textHint,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isSmall ? 8 : 12),
            child: Text(
              '$quantity',
              style: isSmall
                  ? AppTypography.labelMedium
                  : AppTypography.labelLarge,
            ),
          ),
          GestureDetector(
            onTap: onIncrement,
            child: Padding(
              padding: EdgeInsets.all(isSmall ? 4 : 8),
              child: Icon(
                Icons.add,
                size: isSmall ? 16 : 20,
                color: AppColors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}