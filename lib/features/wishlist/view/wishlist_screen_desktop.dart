import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/features/wishlist/logic/cubit.dart';
import 'package:real_ecommerce/features/wishlist/logic/states.dart';
import 'package:real_ecommerce/features/wishlist/view/widgets/wishlist_desktop_sidebar.dart';
import 'package:real_ecommerce/features/wishlist/view/widgets/wishlist_empty_view.dart';
import 'package:real_ecommerce/features/wishlist/view/widgets/wishlist_error_view.dart';
import 'package:real_ecommerce/features/wishlist/view/widgets/wishlist_item_card.dart';
import 'package:real_ecommerce/features/wishlist/view/widgets/wishlist_resolve_items.dart';

/// Layout الديسكتوب:
///   ┌─────────────────┬──────────────────────────────┐
///   │  Sidebar 260px  │  Grid (3 columns)            │
///   └─────────────────┴──────────────────────────────┘
class WishlistDesktop extends StatelessWidget {
  const WishlistDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Wishlist')),
      body: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }

          if (state is WishlistError) {
            return WishlistErrorView(message: state.message);
          }

          final items = wishlistItemsFromState(state);

          if (items.isEmpty) return const WishlistEmptyView();

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WishlistDesktopSidebar(items: items),
                    const SizedBox(width: AppSpacing.xl),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: AppSpacing.lg,
                          crossAxisSpacing: AppSpacing.lg,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: items.length,
                        itemBuilder: (_, i) {
                          final isActionLoading =
                              state is WishlistActionLoading &&
                                  state.productId == items[i].product.id;
                          return WishlistItemCard(
                            item: items[i],
                            isActionLoading: isActionLoading,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
