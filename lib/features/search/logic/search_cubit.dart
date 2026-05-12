import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/features/home/data/repo/home_repository.dart';
import 'search_states.dart';

class SearchCubit extends Cubit<SearchState> {
  final HomeRepository _repository;

  SearchCubit(this._repository) : super(const SearchInitial());

  /// Search products by query
  Future<void> searchProducts(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    try {
      emit(const SearchLoading());

      final result = await _repository.getProducts(search: trimmedQuery);
      result.when(
        success: (productResponse) {
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

  /// Clear search
  void clearSearch() {
    emit(const SearchInitial());
  }
}
