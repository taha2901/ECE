import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/core/network/api_result.dart';
import 'package:real_ecommerce/features/home/data/models/product_model.dart';
import 'package:real_ecommerce/features/home/data/repo/home_repository.dart';

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
  final List<ProductModel> products;
  final List<ProductModel> featured;
  final List<ProductModel> trending;

  const ProductLoaded({
    required this.products,
    required this.featured,
    required this.trending,
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
  final HomeRepository _repository;

  ProductCubit(this._repository) : super(const ProductInitial());

  Future<void> loadProducts() async {
    emit(const ProductLoading());
    final result = await _repository.getProducts();

    result.when(
      success: (data) {
        final products = data.results;
        // عرض جميع المنتجات، أو أول النصف كـ featured والباقي كـ trending
        final midpoint = (products.length / 2).ceil();
        final featured = products.take(midpoint).toList();
        final trending = products.skip(midpoint).toList();
        emit(ProductLoaded(
          products: products,
          featured: featured,
          trending: trending,
        ));
      },
      failure: (error) {
        emit(ProductError(error.toString()));
      },
    );
  }

  Future<void> retry() => loadProducts();
}