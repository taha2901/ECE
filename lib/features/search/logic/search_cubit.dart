import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/features/home/data/models/product_model.dart';
import 'package:real_ecommerce/features/home/data/repo/home_repository.dart';
import 'search_states.dart';

class SearchCubit extends Cubit<SearchState> {
  final HomeRepository _repository;

  SearchCubit(this._repository) : super(const SearchInitial());

  List<ProductModel> _allProducts = [];

  /// Load all products for searching
  Future<void> loadProducts() async {
    try {
      emit(const SearchLoading());

      final result = await _repository.getProducts();

      result.when(
        success: (productResponse) {
          _allProducts = productResponse.results;
          emit(SearchLoaded(products: productResponse.results));
        },
        failure: (error) {
          emit(SearchError(error.apiErrorModel.readableMessage));
        },
      );
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  /// Search products by query
  void searchProducts(String query) {
    try {
      if (query.isEmpty) {
        emit(SearchLoaded(products: _allProducts));
        return;
      }

      final filtered = _allProducts
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()) ||
              product.description.toLowerCase().contains(query.toLowerCase()))
          .toList();

      emit(SearchLoaded(products: filtered));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  /// Clear search
  void clearSearch() {
    if (state is SearchLoaded) {
      emit(SearchLoaded(products: _allProducts));
    }
  }
}
