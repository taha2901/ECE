// // lib/features/wishlist/view/wishlist_screen.dart
// // ✅ تغيير بسيط: تحوّل الـ WishlistScreen لـ StatefulWidget
// //    عشان تطلب البيانات في initState (بعد ما الـ GuestGuard تأكّد إن المستخدم مسجّل).

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:real_ecommerce/core/constants/app_constants.dart';
// import 'package:real_ecommerce/core/themes/app_colors.dart';
// import 'package:real_ecommerce/core/themes/app_typography.dart';
// import 'package:real_ecommerce/features/cart/logic/cubit.dart';
// import 'package:real_ecommerce/features/wishlist/data/models/wishlist_model.dart';
// import 'package:real_ecommerce/features/wishlist/logic/cubit.dart';
// import 'package:real_ecommerce/features/wishlist/logic/states.dart';

// class WishlistScreen extends StatefulWidget {
//   const WishlistScreen({super.key});

//   @override
//   State<WishlistScreen> createState() => _WishlistScreenState();
// }

// class _WishlistScreenState extends State<WishlistScreen> {
//   bool _loaded = false;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     // ✅ نحمّل الـ wishlist مرة واحدة فقط، وبس لو المستخدم وصلها (يعني مسجّل)
//     if (!_loaded) {
//       context.read<WishlistCubit>().loadWishlist();
//       _loaded = true;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         title: const Text('Wishlist'),
//         actions: [
//           BlocBuilder<WishlistCubit, WishlistState>(
//             builder: (context, state) {
//               if (state is! WishlistLoaded || state.items.isEmpty) {
//                 return const SizedBox.shrink();
//               }
//               return TextButton(
//                 onPressed: () {
//                   for (final item in state.items) {
//                     context.read<CartCubit>().addToCart(
//                           productId: item.product.id,
//                           quantity: 1,
//                           size: 'M',
//                           color: item.product.variants.isNotEmpty
//                               ? item.product.variants.first.colorHex
//                               : '#000000',
//                         );
//                   }
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text('All items added to cart!')),
//                   );
//                 },
//                 child: Text(
//                   'Add All to Cart',
//                   style: AppTypography.labelMedium
//                       .copyWith(color: AppColors.accent),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: BlocBuilder<WishlistCubit, WishlistState>(
//         builder: (context, state) {
//           if (state is WishlistLoading) {
//             return const Center(
//               child: CircularProgressIndicator(color: AppColors.accent),
//             );
//           }

//           if (state is WishlistError) {
//             return Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(Icons.error_outline_rounded,
//                       size: 48, color: AppColors.error),
//                   const SizedBox(height: 12),
//                   Text(state.message,
//                       textAlign: TextAlign.center,
//                       style: AppTypography.bodyMedium),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () =>
//                         context.read<WishlistCubit>().loadWishlist(),
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }

//           final items = state is WishlistLoaded
//               ? state.items
//               : state is WishlistActionLoading
//                   ? state.currentItems
//                   : <WishlistModel>[];

//           if (items.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     Icons.favorite_border_rounded,
//                     size: 72,
//                     color: AppColors.textHint.withOpacity(0.4),
//                   ),
//                   const SizedBox(height: 16),
//                   Text('Your wishlist is empty',
//                       style: AppTypography.h3
//                           .copyWith(color: AppColors.textHint)),
//                   const SizedBox(height: 8),
//                   Text('Save items you love here',
//                       style: AppTypography.bodyMedium
//                           .copyWith(color: AppColors.textHint)),
//                 ],
//               ),
//             );
//           }

//           return GridView.builder(
//             padding: const EdgeInsets.all(AppSpacing.pagePadding),
//             gridDelegate:
//                 const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               mainAxisSpacing: AppSpacing.lg,
//               crossAxisSpacing: AppSpacing.lg,
//               childAspectRatio: 0.72,
//             ),
//             itemCount: items.length,
//             itemBuilder: (_, i) {
//               final isActionLoading = state is WishlistActionLoading &&
//                   state.productId == items[i].product.id;
//               return WishlistItemCard(
//                 item: items[i],
//                 isActionLoading: isActionLoading,
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// // ── WishlistItemCard (بدون تغيير) ─────────────────────

// class WishlistItemCard extends StatelessWidget {
//   final WishlistModel item;
//   final bool isActionLoading;

//   const WishlistItemCard({
//     super.key,
//     required this.item,
//     this.isActionLoading = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final product = item.product;

//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(AppRadius.xl),
//         boxShadow: AppColors.cardShadow,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(AppRadius.xl),
//                     topRight: Radius.circular(AppRadius.xl),
//                   ),
//                   child: product.image.isNotEmpty
//                       ? Image.network(
//                           product.image,
//                           width: double.infinity,
//                           fit: BoxFit.cover,
//                           loadingBuilder: (ctx, child, progress) {
//                             if (progress == null) return child;
//                             return Container(
//                               color: AppColors.surfaceVariant,
//                               child: const Center(
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: AppColors.accent,
//                                 ),
//                               ),
//                             );
//                           },
//                           errorBuilder: (_, __, ___) => Container(
//                             color: AppColors.surfaceVariant,
//                             child: const Icon(Icons.image_outlined,
//                                 size: 44, color: AppColors.textHint),
//                           ),
//                         )
//                       : Container(
//                           color: AppColors.surfaceVariant,
//                           child: const Icon(Icons.image_outlined,
//                               size: 44, color: AppColors.textHint),
//                         ),
//                 ),
//                 Positioned(
//                   top: 8,
//                   right: 8,
//                   child: GestureDetector(
//                     onTap: isActionLoading
//                         ? null
//                         : () => context
//                             .read<WishlistCubit>()
//                             .toggleWishlist(product.id),
//                     child: Container(
//                       width: 32,
//                       height: 32,
//                       decoration: BoxDecoration(
//                         color: AppColors.accent.withOpacity(0.1),
//                         shape: BoxShape.circle,
//                       ),
//                       child: isActionLoading
//                           ? const Padding(
//                               padding: EdgeInsets.all(7),
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: AppColors.accent,
//                               ),
//                             )
//                           : const Icon(
//                               Icons.favorite_rounded,
//                               size: 16,
//                               color: AppColors.accent,
//                             ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(AppSpacing.md),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   product.name,
//                   style: AppTypography.labelLarge.copyWith(fontSize: 13),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(product.formattedPrice, style: AppTypography.priceSmall),
//                 const SizedBox(height: 8),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 34,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       context.read<CartCubit>().addToCart(
//                             productId: product.id,
//                             quantity: 1,
//                             size: 'M',
//                             color: product.variants.isNotEmpty
//                                 ? product.variants.first.colorHex
//                                 : '#000000',
//                           );
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                             content:
//                                 Text('${product.name} added to cart!')),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
//                     child: Text(
//                       'Add to Cart',
//                       style: AppTypography.labelSmall
//                           .copyWith(color: AppColors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/core/helpers/responsive.dart';
import 'package:real_ecommerce/features/wishlist/logic/cubit.dart';
import 'wishlist_screen_mobile.dart';
import 'wishlist_screen_desktop.dart';

// ═══════════════════════════════════════════════
// WISHLIST SCREEN — entry point
// بس بيحمّل الـ data ويوزّع على موبايل/ديسكتوب
// ═══════════════════════════════════════════════
class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      context.read<WishlistCubit>().loadWishlist();
      _loaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: const WishlistMobile(),
      desktop: const WishlistDesktop(),
    );
  }
}