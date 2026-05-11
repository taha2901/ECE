import 'package:equatable/equatable.dart';
import 'package:real_ecommerce/features/home/data/models/product_model.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  final List<ProductModel> products;

  const SearchLoaded({required this.products});

  @override
  List<Object?> get props => [products];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
