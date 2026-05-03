import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/features/cart/data/models/cart_models.dart';
import 'package:real_ecommerce/features/cart/data/repo/cart_repository.dart';
import 'package:real_ecommerce/features/cart/logic/states.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository _repository;

  CartCubit(this._repository) : super(const CartState());

  /// تحميل محتويات العربة
  Future<void> loadCart() async {
    emit(state.copyWith(status: CartStatus.loading));
    
    final result = await _repository.getCart();

    result.when(
      success: (data) {
        emit(state.copyWith(
          status: CartStatus.loaded,
          items: data.results,
          message: null,
          errorMessage: null,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          status: CartStatus.error,
          errorMessage: error.apiErrorModel.readableMessage,
        ));
      },
    );
  }
  

  /// إضافة منتج للعربة
  Future<void> addToCart({
    required int productId,
    required int quantity,
    required String size,
    required String color,
  }) async {
    emit(state.copyWith(status: CartStatus.adding));

    final result = await _repository.addToCart(
      AddToCartRequest(
        productId: productId,
        quantity: quantity,
        size: size,
        color: color,
      ),
    );

    result.when(
      success: (data) {
        emit(state.copyWith(
          status: CartStatus.loaded,
          message: 'Added to cart successfully',
        ));
        // إعادة تحميل العربة
        loadCart();
      },
      failure: (error) {
        emit(state.copyWith(
          status: CartStatus.error,
          errorMessage: error.apiErrorModel.readableMessage,
        ));
      },
    );
  }

  /// تحديث عنصر في العربة (Optimistic Update)
  Future<void> updateCartItem(
    int itemId,
    int quantity,
    String size,
    String color,
  ) async {
    // احصل على مؤشر العنصر
    final itemIndex = state.items.indexWhere((item) => item.id == itemId);
    if (itemIndex == -1) return;

    // احفظ القيمة القديمة عشان نرجع إليها لو فشل التحديث
    final oldItem = state.items[itemIndex];
    final oldQuantity = oldItem.quantity;

    // تحديث optimistic: غير الكمية مباشرة بدون انتظار السيرفر
    final updatedItems = List<CartItemModel>.from(state.items);
    updatedItems[itemIndex] = oldItem.copyWith(quantity: quantity);

    emit(state.copyWith(
      items: updatedItems,
      status: CartStatus.loaded,
      errorMessage: null,
      message: null,
    ));

    // الآن حاول تحديث في السيرفر
    final result = await _repository.updateCartItem(
      itemId,
      quantity,
      size,
      color,
    );

    result.when(
      success: (_) {
        // التحديث نجح في السيرفر، لا نحتاج لفعل شيء آخر
      },
      failure: (error) {
        // التحديث فشل، ارجع الكمية القديمة و أظهر الخطأ
        final revertedItems = List<CartItemModel>.from(state.items);
        revertedItems[itemIndex] = oldItem;

        emit(state.copyWith(
          items: revertedItems,
          errorMessage: error.apiErrorModel.readableMessage,
          status: CartStatus.loaded,
        ));
      },
    );
  }

  /// حذف عنصر من العربة (Optimistic Delete)
  /// حذف عنصر من العربة (Optimistic Delete)
Future<void> removeFromCart(int itemId) async {
  final itemIndex = state.items.indexWhere((item) => item.id == itemId);
  if (itemIndex == -1) return;

  final removedItem = state.items[itemIndex];

  // Optimistic: شيل العنصر فوراً من الـ UI
  final updatedItems = List<CartItemModel>.from(state.items)
    ..removeWhere((item) => item.id == itemId);

  emit(state.copyWith(
    items: updatedItems,
    status: CartStatus.loaded,
    errorMessage: null,
    message: null,
  ));

  // اتصل بالـ API
  final result = await _repository.removeFromCart(itemId);

  result.when(
    success: (_) {
      // تمام، مفيش حاجة
    },
    failure: (error) {
      // Rollback: رجّع العنصر في نفس مكانه
      final revertedItems = List<CartItemModel>.from(state.items);
      revertedItems.insert(itemIndex, removedItem);

      emit(state.copyWith(
        items: revertedItems,
        status: CartStatus.loaded,
        errorMessage: error.apiErrorModel.readableMessage,
      ));
    },
  );
}
  /// مسح العربة
  Future<void> clearCart() async {
    emit(state.copyWith(status: CartStatus.removing));

    final result = await _repository.clearCart();

    result.when(
      success: (_) {
        emit(state.copyWith(
          status: CartStatus.loaded,
          items: [],
          message: 'Cart cleared',
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          status: CartStatus.error,
          errorMessage: error.apiErrorModel.readableMessage,
        ));
      },
    );
  }

  /// إعادة محاولة التحميل
  Future<void> retry() => loadCart();
}
