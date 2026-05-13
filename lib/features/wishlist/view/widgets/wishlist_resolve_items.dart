import 'package:real_ecommerce/features/wishlist/data/models/wishlist_model.dart';
import 'package:real_ecommerce/features/wishlist/logic/states.dart';

/// عناصر المفضلة المعروضة أثناء التحميل أو بعد التحميل.
List<WishlistModel> wishlistItemsFromState(WishlistState state) {
  if (state is WishlistLoaded) return state.items;
  if (state is WishlistActionLoading) return state.currentItems;
  return [];
}
