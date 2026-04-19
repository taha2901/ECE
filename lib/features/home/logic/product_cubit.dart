import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/features/home/data/models/product_model.dart';

// ══════════════════════════════════════════════════════════
//  STATES
// ══════════════════════════════════════════════════════════

sealed class ProductState {
  const ProductState();
}

final class ProductInitial extends ProductState {
  const ProductInitial();
}

final class ProductLoading extends ProductState {
  const ProductLoading();
}

final class ProductLoaded extends ProductState {
  /// الـ raw data — الفلترة بتحصل في الـ UI بناءً على selectedId من CategoryCubit
  final List<ProductModel> featured;
  final List<ProductModel> newArrivals;

  const ProductLoaded({
    required this.featured,
    required this.newArrivals,
  });
}

final class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);
}

// ══════════════════════════════════════════════════════════
//  CUBIT
// ══════════════════════════════════════════════════════════

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(const ProductInitial());

  Future<void> loadProducts() async {
    emit(const ProductLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      // 🔌 استبدل بـ: await _repository.getProducts()
      emit(ProductLoaded(
        featured: ProductMockData.featured,
        newArrivals: ProductMockData.newArrivals,
      ));
    } catch (e) {
      emit(const ProductError('Failed to load products.'));
    }
  }

  Future<void> retry() => loadProducts();
}