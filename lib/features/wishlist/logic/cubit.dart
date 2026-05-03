// lib/features/wishlist/logic/wishlist_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/features/wishlist/logic/states.dart';

import '../data/repo/wishlist_repository.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final WishlistRepository _repo;

  WishlistCubit(this._repo) : super(const WishlistInitial());

  Future<void> loadWishlist() async {
    emit(const WishlistLoading());
    try {
      final items = await _repo.getWishlist();
      emit(WishlistLoaded(items));
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  Future<void> toggleWishlist(int productId) async {
    final currentState = state;
    final currentItems = currentState is WishlistLoaded
        ? currentState.items
        : <dynamic>[];

    // Optimistic update: emit loading على نفس المنتج
    if (currentState is WishlistLoaded) {
      emit(WishlistActionLoading(
        productId: productId,
        currentItems: currentState.items,
      ));
    }

    try {
      if (currentState is WishlistLoaded && currentState.contains(productId)) {
        // Remove
        await _repo.removeFromWishlist(productId);
        final updated = currentState.items
            .where((e) => e.product.id != productId)
            .toList();
        emit(WishlistLoaded(updated));
      } else {
        // Add
        final newItem = await _repo.addToWishlist(productId);
        final prevItems = currentState is WishlistLoaded
            ? currentState.items
            : <dynamic>[];
        emit(WishlistLoaded([...prevItems, newItem]));
      }
    } catch (e) {
      // Rollback
      if (currentState is WishlistLoaded) {
        emit(WishlistLoaded(currentState.items));
      }
      emit(WishlistError(e.toString()));
    }
  }

  bool isWishlisted(int productId) {
    final currentState = state;
    if (currentState is WishlistLoaded) {
      return currentState.contains(productId);
    }
    if (currentState is WishlistActionLoading) {
      return currentState.currentItems
          .any((e) => e.product.id == productId);
    }
    return false;
  }
}