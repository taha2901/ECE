// lib/features/wishlist/logic/wishlist_states.dart

import 'package:equatable/equatable.dart';

import '../data/models/wishlist_model.dart';

abstract class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object?> get props => [];
}

class WishlistInitial extends WishlistState {
  const WishlistInitial();
}

class WishlistLoading extends WishlistState {
  const WishlistLoading();
}

class WishlistLoaded extends WishlistState {
  final List<WishlistModel> items;

  const WishlistLoaded(this.items);

  /// IDs المنتجات الموجودة في الـ wishlist - سهل للـ check
  Set<int> get productIds => items.map((e) => e.product.id).toSet();

  bool contains(int productId) => productIds.contains(productId);

  @override
  List<Object?> get props => [items];
}

class WishlistError extends WishlistState {
  final String message;

  const WishlistError(this.message);

  @override
  List<Object?> get props => [message];
}

class WishlistActionLoading extends WishlistState {
  /// ID المنتج اللي بيتعمل عليه action (add/remove)
  final int productId;
  final List<WishlistModel> currentItems;

  const WishlistActionLoading({
    required this.productId,
    required this.currentItems,
  });

  @override
  List<Object?> get props => [productId, currentItems];
}