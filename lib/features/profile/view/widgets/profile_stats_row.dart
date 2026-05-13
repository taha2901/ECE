import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:real_ecommerce/features/address/logic/address_cubit.dart';
import 'package:real_ecommerce/features/orders/logic/cubit.dart' as orders;
import 'package:real_ecommerce/features/orders/logic/states.dart' as orders_state;
import 'package:real_ecommerce/features/profile/view/widgets/profile_stat_item.dart';
import 'package:real_ecommerce/features/wishlist/logic/cubit.dart';
import 'package:real_ecommerce/features/wishlist/logic/states.dart';

/// صف الإحصائيات (طلبات / مفضلة / عناوين) تحت الأفاتار.
class ProfileStatsRow extends StatelessWidget {
  final bool isLoggedIn;
  final VoidCallback onShowLoginDialog;

  const ProfileStatsRow({
    super.key,
    required this.isLoggedIn,
    required this.onShowLoginDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BlocBuilder<orders.OrdersCubit, orders_state.OrdersState>(
          builder: (context, orderState) {
            final ordersCount = orderState is orders_state.OrdersLoaded
                ? orderState.orders.length
                : 0;
            return ProfileStatItem(
              value: isLoggedIn ? ordersCount.toString() : '0',
              label: 'Orders',
              onTap: () => isLoggedIn
                  ? context.push(AppRoutes.orders)
                  : onShowLoginDialog(),
            );
          },
        ),
        const ProfileStatDivider(),
        BlocBuilder<WishlistCubit, WishlistState>(
          builder: (context, wishlistState) {
            final count = wishlistState is WishlistLoaded
                ? wishlistState.items.length
                : 0;
            return ProfileStatItem(
              value: isLoggedIn ? count.toString() : '0',
              label: 'Wishlist',
            );
          },
        ),
        const ProfileStatDivider(),
        BlocBuilder<AddressCubit, AddressState>(
          builder: (context, addressState) {
            final addressCount = addressState.addresses.length;
            return ProfileStatItem(
              value: isLoggedIn ? addressCount.toString() : '0',
              label: 'Addresses',
              onTap: () => isLoggedIn
                  ? context.push(AppRoutes.myAddresses)
                  : onShowLoginDialog(),
            );
          },
        ),
      ],
    );
  }
}
