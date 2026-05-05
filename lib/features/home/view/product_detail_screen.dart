// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:real_ecommerce/core/constants/app_constants.dart';
// import 'package:real_ecommerce/core/routers/app_router.dart';
// import 'package:real_ecommerce/core/themes/app_colors.dart';
// import 'package:real_ecommerce/core/themes/app_typography.dart';
// import 'package:real_ecommerce/features/auth/logic/cubit.dart';
// import 'package:real_ecommerce/features/cart/logic/cubit.dart';
// import 'package:real_ecommerce/features/home/data/models/product_model.dart';
// import 'package:real_ecommerce/features/home/view/widgets/brand_and_rating.dart';
// import 'package:real_ecommerce/features/home/view/widgets/delivery_info_strip.dart';
// import 'package:real_ecommerce/features/home/view/widgets/size_selector.dart';


// class ProductDetailScreen extends StatefulWidget {
//   final ProductModel product;
  
//   const ProductDetailScreen({super.key, required this.product});

//   @override
//   State<ProductDetailScreen> createState() => _ProductDetailScreenState();
// }

// class _ProductDetailScreenState extends State<ProductDetailScreen>
//     with TickerProviderStateMixin {
//   int _selectedImage = 0;
//   String _selectedSize = 'M';
//   String _selectedColor = '#0A0F1E';
//   bool _isWishlisted = false;
//   late TabController _tabController;
//   late PageController _pageController;

//   late List<String> _galleryImages;

//   final _sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

//   @override
//   void initState() {
//     super.initState();
//     // بناء قائمة الصور من المنتج والـ variants
//     _galleryImages = [
//       widget.product.image,
//       ...widget.product.variants.map((v) => v.image).toList(),
//     ];
//     _tabController = TabController(length: 3, vsync: this);
//     _pageController = PageController();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           // ── Image Hero ──────────────────────────────────
//           SliverAppBar(
//             expandedHeight: 420,
//             pinned: true,
//             backgroundColor: AppColors.white,
//             elevation: 0,
//             scrolledUnderElevation: 0,
//             leading: Padding(
//               padding: const EdgeInsets.all(10),
//               child: GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: AppColors.white,
//                     shape: BoxShape.circle,
//                     boxShadow: AppColors.cardShadow,
//                   ),
//                   child: const Icon(Icons.arrow_back_rounded,
//                       color: AppColors.textPrimary, size: 20),
//                 ),
//               ),
//             ),
//             actions: [
//               // Wishlist
//               Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: GestureDetector(
//                   onTap: () => setState(() => _isWishlisted = !_isWishlisted),
//                   child: Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: AppColors.white,
//                       shape: BoxShape.circle,
//                       boxShadow: AppColors.cardShadow,
//                     ),
//                     child: Icon(
//                       _isWishlisted
//                           ? Icons.favorite_rounded
//                           : Icons.favorite_outline_rounded,
//                       size: 20,
//                       color: _isWishlisted
//                           ? AppColors.accent
//                           : AppColors.textHint,
//                     ),
//                   ),
//                 ),
//               ),
//               // Share
//               Padding(
//                 padding: const EdgeInsets.only(right: 12, top: 10, bottom: 10),
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: AppColors.white,
//                     shape: BoxShape.circle,
//                     boxShadow: AppColors.cardShadow,
//                   ),
//                   child: const Icon(Icons.share_outlined,
//                       size: 18, color: AppColors.textPrimary),
//                 ),
//               ),
//             ],
//             flexibleSpace: FlexibleSpaceBar(
//               background: _ProductImageSection(
//                 images: _galleryImages,
//                 selectedIndex: _selectedImage,
//                 pageController: _pageController,
//                 onSelect: (i) {
//                   setState(() => _selectedImage = i);
//                   _pageController.animateToPage(i,
//                       duration: const Duration(milliseconds: 350),
//                       curve: Curves.easeInOut);
//                 },
//               ),
//             ),
//           ),

//           // ── Product Details ──────────────────────────────
//           SliverToBoxAdapter(
//             child: Container(
//               decoration: const BoxDecoration(
//                 color: AppColors.background,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(28),
//                   topRight: Radius.circular(28),
//                 ),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(
//                   AppSpacing.pagePadding,
//                   AppSpacing.xxl,
//                   AppSpacing.pagePadding,
//                   0,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                    BrandAndRating(),
//                     const SizedBox(height: AppSpacing.md),
//                     Text(
//                       widget.product.name,
//                       style: AppTypography.h1.copyWith(
//                         height: 1.2,
//                         fontWeight: FontWeight.w800,
//                         fontSize: 24,
//                       ),
//                     ),
//                     const SizedBox(height: AppSpacing.lg),
//                     Text(
//                       widget.product.formattedPrice,
//                       style: AppTypography.displayMedium.copyWith(
//                         color: AppColors.accent,
//                       ),
//                     ),
//                     const SizedBox(height: AppSpacing.xxl),
//                     DeliveryInfoStrip(),
//                     const SizedBox(height: AppSpacing.xxl),
                        
//                     const _SectionDivider(),
//                     const SizedBox(height: AppSpacing.xl),
                        
//                     // Color selection - فقط إذا كانت هناك variants
//                     if (widget.product.variants.isNotEmpty) ...[
//                       _SectionHeader(title: 'Color'),
//                       const SizedBox(height: AppSpacing.lg),
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           children: widget.product.variants.map((variant) {
//                             return Padding(
//                               padding: const EdgeInsets.only(right: AppSpacing.md),
//                               child: GestureDetector(
//                                 onTap: () => setState(() => _selectedColor = variant.colorHex),
//                                 child: Container(
//                                   width: 50,
//                                   height: 50,
//                                   decoration: BoxDecoration(
//                                     color: Color(int.parse(variant.colorHex.replaceFirst('#', '0xFF'))),
//                                     shape: BoxShape.circle,
//                                     border: Border.all(
//                                       color: _selectedColor == variant.colorHex
//                                           ? AppColors.accent
//                                           : Colors.grey,
//                                       width: _selectedColor == variant.colorHex ? 3 : 1,
//                                     ),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       variant.color,
//                                       style: TextStyle(
//                                         fontSize: 10,
//                                         color: Color(int.parse(variant.colorHex.replaceFirst('#', '0xFF'))) == Colors.black ? Colors.white : Colors.black,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                       const SizedBox(height: AppSpacing.xxl),
//                     ],
                        
//                     // Size selection
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         _SectionHeader(title: 'Size'),
//                         GestureDetector(
//                           onTap: () {},
//                           child: Text(
//                             'Size Guide →',
//                             style: AppTypography.labelMedium.copyWith(
//                               color: AppColors.accent,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: AppSpacing.lg),
//                     SizeSelector(
//                       sizes: _sizes,
//                       selected: _selectedSize,
//                       onSelect: (s) => setState(() => _selectedSize = s),
//                     ),
//                     const SizedBox(height: AppSpacing.xxl),
                        
//                     // Tab bar section
//                     const _SectionDivider(),
//                     const SizedBox(height: AppSpacing.lg),
//                     StyledTabBar(controller: _tabController),
//                     const SizedBox(height: AppSpacing.lg),
//                     SizedBox(
//                       height: 220,
//                       child: TabBarView(
//                         controller: _tabController,
//                         children: [
//                           _DescriptionTab(description: widget.product.description),
//                           _SpecsTab(),
//                           _ReviewsTab(rating: widget.product.rating, reviewsCount: widget.product.reviews),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 120),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: _ProductBottomBar(),
//     );
//   }
// }

// // ═══════════════════════════════════════════════
// // IMAGE SECTION — PageView with thumbnails
// // ═══════════════════════════════════════════════
// class _ProductImageSection extends StatelessWidget {
//   final List<String> images;
//   final int selectedIndex;
//   final PageController pageController;
//   final ValueChanged<int> onSelect;

//   const _ProductImageSection({
//     required this.images,
//     required this.selectedIndex,
//     required this.pageController,
//     required this.onSelect,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: const Color(0xFFF0F3FA),
//       child: Stack(
//         children: [
//           // Main image pageview
//           PageView.builder(
//             controller: pageController,
//             onPageChanged: onSelect,
//             itemCount: images.length,
//             itemBuilder: (_, i) => Hero(
//               tag: 'product-image-$i',
//               child: Image.network(
//                 images[i],
//                 fit: BoxFit.cover,
//                 loadingBuilder: (ctx, child, progress) {
//                   if (progress == null) return child;
//                   return Center(
//                     child: CircularProgressIndicator(
//                       value: progress.expectedTotalBytes != null
//                           ? progress.cumulativeBytesLoaded /
//                               progress.expectedTotalBytes!
//                           : null,
//                       color: AppColors.accent,
//                       strokeWidth: 2,
//                     ),
//                   );
//                 },
//                 errorBuilder: (_, __, ___) => const Center(
//                   child: Icon(Icons.image_outlined,
//                       size: 80, color: AppColors.textHint),
//                 ),
//               ),
//             ),
//           ),

//           // Bottom thumbnails
//           Positioned(
//             bottom: 16,
//             left: 0,
//             right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(images.length, (i) {
//                 final isSelected = selectedIndex == i;
//                 return GestureDetector(
//                   onTap: () => onSelect(i),
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 250),
//                     curve: Curves.easeOut,
//                     margin: const EdgeInsets.symmetric(horizontal: 5),
//                     width: isSelected ? 66 : 56,
//                     height: isSelected ? 66 : 56,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(14),
//                       border: Border.all(
//                         color: isSelected
//                             ? AppColors.accent
//                             : Colors.white.withOpacity(0.6),
//                         width: isSelected ? 2.5 : 1.5,
//                       ),
//                       boxShadow: isSelected ? AppColors.accentShadow : AppColors.cardShadow,
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.network(
//                         images[i],
//                         fit: BoxFit.cover,
//                         errorBuilder: (_, __, ___) => Container(
//                           color: AppColors.surfaceVariant,
//                           child: const Icon(Icons.image_outlined,
//                               size: 18, color: AppColors.textHint),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class StyledTabBar extends StatelessWidget {
//   final TabController controller;

//   const StyledTabBar({super.key, required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 46,
//       decoration: BoxDecoration(
//         color: AppColors.surfaceVariant,
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: TabBar(
//         controller: controller,
//         indicator: BoxDecoration(
//           gradient: AppColors.accentGradient,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: AppColors.accentShadow,
//         ),
//         indicatorSize: TabBarIndicatorSize.tab,
//         dividerColor: Colors.transparent,
//         labelColor: AppColors.white,
//         unselectedLabelColor: AppColors.textHint,
//         labelStyle: AppTypography.labelMedium.copyWith(
//           fontWeight: FontWeight.w700,
//           fontSize: 13,
//         ),
//         unselectedLabelStyle: AppTypography.labelMedium.copyWith(
//           fontSize: 13,
//         ),
//         padding: const EdgeInsets.all(4),
//         tabs: const [
//           Tab(text: 'Description'),
//           Tab(text: 'Specs'),
//           Tab(text: 'Reviews'),
//         ],
//       ),
//     );
//   }
// }

// // ═══════════════════════════════════════════════
// // TAB CONTENT
// // ═══════════════════════════════════════════════
// class _DescriptionTab extends StatelessWidget {
//   final String description;
  
//   const _DescriptionTab({required this.description});
  
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       physics: const NeverScrollableScrollPhysics(),
//       child: Text(
//         description.isEmpty 
//           ? 'No description available' 
//           : description,
//         style: AppTypography.bodyMedium.copyWith(height: 1.7, fontSize: 14),
//       ),
//     );
//   }
// }

// class _SpecsTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final specs = [
//       ('Material', 'Premium Mesh + Rubber'),
//       ('Weight', '280g'),
//       ('Origin', 'Vietnam'),
//       ('Care', 'Machine washable'),
//       ('Warranty', '1 Year'),
//     ];

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: specs
//           .map((s) => _SpecRow(label: s.$1, value: s.$2))
//           .toList(),
//     );
//   }
// }

// class _ReviewsTab extends StatelessWidget {
//   final double rating;
//   final int reviewsCount;
  
//   const _ReviewsTab({required this.rating, required this.reviewsCount});
  
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 20),
//             const SizedBox(width: 8),
//             Text(
//               '$rating',
//               style: AppTypography.labelLarge,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               '($reviewsCount reviews)',
//               style: AppTypography.bodySmall,
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         if (reviewsCount == 0)
//           Center(
//             child: Text(
//               'No reviews yet',
//               style: AppTypography.bodyMedium,
//             ),
//           ),
//       ],
//     );
//   }
// }

// // ═══════════════════════════════════════════════
// // SPEC ROW
// // ═══════════════════════════════════════════════
// class _SpecRow extends StatelessWidget {
//   final String label;
//   final String value;

//   const _SpecRow({required this.label, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: AppSpacing.sm),
//       padding: const EdgeInsets.symmetric(
//           horizontal: AppSpacing.lg, vertical: AppSpacing.md),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: AppColors.cardShadow,
//       ),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 90,
//             child: Text(
//               label,
//               style: AppTypography.labelMedium.copyWith(
//                   color: AppColors.textHint),
//             ),
//           ),
//           Text(value, style: AppTypography.bodyMedium.copyWith(
//             color: AppColors.textPrimary,
//             fontWeight: FontWeight.w500,
//           )),
//         ],
//       ),
//     );
//   }
// }

// // ═══════════════════════════════════════════════
// // REVIEW ITEM — with network avatar
// // ═══════════════════════════════════════════════
// class ReviewItem extends StatelessWidget {
//   final String name;
//   final double rating;
//   final String comment;
//   final String? date;
//   final String? avatarUrl;

//   const ReviewItem({
//     super.key,
//     required this.name,
//     required this.rating,
//     required this.comment,
//     this.date,
//     this.avatarUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: AppSpacing.md),
//       padding: const EdgeInsets.all(AppSpacing.lg),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: AppColors.cardShadow,
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Avatar
//           ClipOval(
//             child: avatarUrl != null
//                 ? Image.network(
//                     avatarUrl!,
//                     width: 40,
//                     height: 40,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => _FallbackAvatar(name: name),
//                   )
//                 : _FallbackAvatar(name: name),
//           ),
//           const SizedBox(width: AppSpacing.md),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(name, style: AppTypography.labelLarge),
//                     const Spacer(),
//                     // Star rating
//                     Row(
//                       children: List.generate(5, (i) => Icon(
//                         i < rating.round()
//                             ? Icons.star_rounded
//                             : Icons.star_outline_rounded,
//                         size: 13,
//                         color: i < rating.round()
//                             ? AppColors.starFilled
//                             : AppColors.starEmpty,
//                       )),
//                     ),
//                   ],
//                 ),
//                 if (date != null) ...[
//                   const SizedBox(height: 2),
//                   Text(
//                     date!,
//                     style: AppTypography.labelSmall
//                         .copyWith(color: AppColors.textHint),
//                   ),
//                 ],
//                 const SizedBox(height: 6),
//                 Text(
//                   comment,
//                   style: AppTypography.bodySmall.copyWith(height: 1.5),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _FallbackAvatar extends StatelessWidget {
//   final String name;

//   const _FallbackAvatar({required this.name});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 40,
//       height: 40,
//       color: AppColors.accent.withOpacity(0.12),
//       child: Center(
//         child: Text(
//           name[0].toUpperCase(),
//           style: AppTypography.labelLarge.copyWith(color: AppColors.accent),
//         ),
//       ),
//     );
//   }
// }

// // ═══════════════════════════════════════════════
// // BOTTOM BAR
// // ═══════════════════════════════════════════════
// class _ProductBottomBar extends StatefulWidget {
 

//   const _ProductBottomBar();

//   @override
//   State<_ProductBottomBar> createState() => _ProductBottomBarState();
// }

// class _ProductBottomBarState extends State<_ProductBottomBar> {
//   int _qty = 1;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(
//         AppSpacing.pagePadding,
//         AppSpacing.lg,
//         AppSpacing.pagePadding,
//         AppSpacing.pagePadding +
//             MediaQuery.of(context).padding.bottom,
//       ),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(24),
//           topRight: Radius.circular(24),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.primary.withOpacity(0.08),
//             blurRadius: 24,
//             offset: const Offset(0, -6),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // Quantity control
//           _QuantityControl(
//             quantity: _qty,
//             onIncrement: () => setState(() => _qty++),
//             onDecrement: () {
//               if (_qty > 1) setState(() => _qty--);
//             },
//           ),
//           const SizedBox(width: AppSpacing.lg),

//           // Add to Cart button
//           Expanded(
//             child: GestureDetector(
//               onTap: () {
//                 final isLoggedIn = context.read<AuthCubit>().state.isSuccess;
//                 if (!isLoggedIn) {
//                   ScaffoldMessenger.of(context)
//                     ..clearSnackBars()
//                     ..showSnackBar(
//                       SnackBar(
//                         content: const Text(
//                           'Please sign in to add items to your cart.',
//                         ),
//                         action: SnackBarAction(
//                           label: 'Sign In',
//                           onPressed: () => context.push(AppRoutes.login),
//                         ),
//                       ),
//                     );
//                   return;
//                 }

//                 final productDetailState = context.findAncestorStateOfType<_ProductDetailScreenState>();
//                 if (productDetailState != null) {
//                   context.read<CartCubit>().addToCart(
//                     productId: productDetailState.widget.product.id,
//                     quantity: _qty,
//                     size: productDetailState._selectedSize,
//                     color: productDetailState._selectedColor,
//                   );
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Added to cart!')),
//                   );
//                 }
//               },
//               child: Container(
//                 height: 54,
//                 decoration: BoxDecoration(
//                   gradient: AppColors.accentGradient,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: AppColors.accentShadow,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.shopping_bag_outlined,
//                         color: Colors.white, size: 20),
//                     const SizedBox(width: 8),
//                     Text(
//                       AppStrings.addToCart,
//                       style: AppTypography.buttonLarge.copyWith(
//                         color: AppColors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Quantity Control ────────────────────────────
// class _QuantityControl extends StatelessWidget {
//   final int quantity;
//   final VoidCallback onIncrement;
//   final VoidCallback onDecrement;

//   const _QuantityControl({
//     required this.quantity,
//     required this.onIncrement,
//     required this.onDecrement,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.surfaceVariant,
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           _QtyBtn(icon: Icons.remove_rounded, onTap: onDecrement),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 14),
//             child: Text(
//               '$quantity',
//               style: AppTypography.h3.copyWith(fontSize: 16),
//             ),
//           ),
//           _QtyBtn(icon: Icons.add_rounded, onTap: onIncrement, filled: true),
//         ],
//       ),
//     );
//   }
// }

// class _QtyBtn extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onTap;
//   final bool filled;

//   const _QtyBtn({required this.icon, required this.onTap, this.filled = false});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 40,
//         height: 46,
//         decoration: BoxDecoration(
//           gradient: filled ? AppColors.accentGradient : null,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Icon(
//           icon,
//           size: 18,
//           color: filled ? AppColors.white : AppColors.textSecondary,
//         ),
//       ),
//     );
//   }
// }

// // ─── Divider ─────────────────────────────────────
// class _SectionDivider extends StatelessWidget {
//   const _SectionDivider();

//   @override
//   Widget build(BuildContext context) {
//     return Container(height: 1, color: AppColors.divider);
//   }
// }

// // ─── Section Header ──────────────────────────────
// class _SectionHeader extends StatelessWidget {
//   final String title;

//   const _SectionHeader({required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       title,
//       style: AppTypography.h3.copyWith(
//         fontWeight: FontWeight.w700,
//         fontSize: 16,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/helpers/responsive.dart';
import 'package:real_ecommerce/features/home/data/models/product_model.dart';
import 'package:real_ecommerce/features/home/view/widgets/details/product_detail_screen_desktop.dart';
import 'package:real_ecommerce/features/home/view/widgets/details/product_detail_screen_mobile.dart';

// ═══════════════════════════════════════════════
// PRODUCT DETAIL SCREEN — entry point
// كل الـ state هنا، مفيش UI خالص
// ═══════════════════════════════════════════════
class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  int _selectedImage = 0;
  String _selectedSize = 'M';
  String _selectedColor = '#0A0F1E';
  bool _isWishlisted = false;

  late final TabController _tabController;
  late final PageController _pageController;
  late final List<String> _galleryImages;

  final _sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

  @override
  void initState() {
    super.initState();
    _galleryImages = [
      widget.product.image,
      ...widget.product.variants.map((v) => v.image),
    ];
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onImageSelect(int i) {
    setState(() => _selectedImage = i);
    _pageController.animateToPage(
      i,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // props مشتركة بين الـ layouts
    final shared = (
      product: widget.product,
      galleryImages: _galleryImages,
      selectedImage: _selectedImage,
      selectedSize: _selectedSize,
      selectedColor: _selectedColor,
      isWishlisted: _isWishlisted,
      sizes: _sizes,
      tabController: _tabController,
      pageController: _pageController,
      onImageSelect: _onImageSelect,
      onSizeSelect: (String s) => setState(() => _selectedSize = s),
      onColorSelect: (String c) => setState(() => _selectedColor = c),
      onWishlistToggle: () => setState(() => _isWishlisted = !_isWishlisted),
    );

    return Responsive(
      mobile: ProductDetailMobile(
        product: shared.product,
        galleryImages: shared.galleryImages,
        selectedImage: shared.selectedImage,
        selectedSize: shared.selectedSize,
        selectedColor: shared.selectedColor,
        isWishlisted: shared.isWishlisted,
        sizes: shared.sizes,
        tabController: shared.tabController,
        pageController: shared.pageController,
        onImageSelect: shared.onImageSelect,
        onSizeSelect: shared.onSizeSelect,
        onColorSelect: shared.onColorSelect,
        onWishlistToggle: shared.onWishlistToggle,
      ),
      desktop: ProductDetailDesktop(
        product: shared.product,
        galleryImages: shared.galleryImages,
        selectedImage: shared.selectedImage,
        selectedSize: shared.selectedSize,
        selectedColor: shared.selectedColor,
        isWishlisted: shared.isWishlisted,
        sizes: shared.sizes,
        tabController: shared.tabController,
        pageController: shared.pageController,
        onImageSelect: shared.onImageSelect,
        onSizeSelect: shared.onSizeSelect,
        onColorSelect: shared.onColorSelect,
        onWishlistToggle: shared.onWishlistToggle,
      ),
    );
  }
}