// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:real_ecommerce/core/constants/app_constants.dart';
// import 'package:real_ecommerce/core/themes/app_colors.dart';
// import 'package:real_ecommerce/core/themes/app_typography.dart';
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



// lib/features/home/view/product_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/auth/logic/cubit.dart';
import 'package:real_ecommerce/features/auth/logic/states.dart';
import 'package:real_ecommerce/features/cart/logic/cubit.dart';
import 'package:real_ecommerce/features/home/data/models/product_model.dart';
import 'package:real_ecommerce/features/home/view/widgets/delivery_info_strip.dart';
import 'package:real_ecommerce/features/home/view/widgets/size_selector.dart';
import 'package:real_ecommerce/features/wishlist/logic/cubit.dart';
import 'package:real_ecommerce/features/wishlist/logic/states.dart';
import 'package:real_ecommerce/core/routers/app_router.dart';
import 'package:go_router/go_router.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  int _selectedImage = 0;
  String _selectedSize = '';
  String _selectedColor = '';
  late TabController _tabController;
  late PageController _pageController;
  late List<String> _galleryImages;

  @override
  void initState() {
    super.initState();

    // ✅ تحديد الـ variant الأول كـ default
    if (widget.product.variants.isNotEmpty) {
      final firstVariant = widget.product.variants.first;
      _selectedColor = firstVariant.colorHex;
      if (firstVariant.sizes.isNotEmpty) {
        _selectedSize = firstVariant.sizes.first.size;
      }
    }

    // ✅ بناء قائمة الصور من المنتج + الـ variants (بدون صور فاضية)
    _galleryImages = [
      if (widget.product.image.isNotEmpty) widget.product.image,
      ...widget.product.variants
          .where((v) => v.image.isNotEmpty)
          .map((v) => v.image),
    ];

    // لو مفيش صور → صورة placeholder
    if (_galleryImages.isEmpty) _galleryImages = [''];

    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  /// ✅ parse hex safe
  Color _hexToColor(String hex) {
    try {
      final clean = hex.replaceFirst('#', '');
      if (clean.length == 6) {
        return Color(int.parse('FF$clean', radix: 16));
      }
      return AppColors.accent;
    } catch (_) {
      return AppColors.accent;
    }
  }

  /// ✅ الـ sizes المتاحة حسب اللون المختار
  List<String> get _availableSizes {
    if (widget.product.variants.isEmpty) {
      return ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
    }
    final variant = widget.product.variants.firstWhere(
      (v) => v.colorHex == _selectedColor,
      orElse: () => widget.product.variants.first,
    );
    return variant.sizes.map((s) => s.size).toList();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Image Hero ──────────────────────────────────
          SliverAppBar(
            expandedHeight: 420,
            pinned: true,
            backgroundColor: AppColors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: const Icon(Icons.arrow_back_rounded,
                      color: AppColors.textPrimary, size: 20),
                ),
              ),
            ),
            actions: [
              // ✅ Wishlist button — يفحص الـ Auth أولاً
              Padding(
                padding: const EdgeInsets.all(10),
                child: BlocBuilder<WishlistCubit, WishlistState>(
                  builder: (context, state) {
                    final isLoggedIn =
                        context.read<AuthCubit>().state.status ==
                            AuthStatus.success;
                    final wishlisted =
                        context.read<WishlistCubit>().isWishlisted(product.id);

                    return GestureDetector(
                      onTap: () {
                        if (!isLoggedIn) {
                          _showLoginDialog(context);
                          return;
                        }
                        context
                            .read<WishlistCubit>()
                            .toggleWishlist(product.id);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: Icon(
                          wishlisted
                              ? Icons.favorite_rounded
                              : Icons.favorite_outline_rounded,
                          size: 20,
                          color: wishlisted
                              ? AppColors.accent
                              : AppColors.textHint,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Share
              Padding(
                padding:
                    const EdgeInsets.only(right: 12, top: 10, bottom: 10),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: const Icon(Icons.share_outlined,
                      size: 18, color: AppColors.textPrimary),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _ProductImageSection(
                images: _galleryImages,
                selectedIndex: _selectedImage,
                pageController: _pageController,
                onSelect: (i) {
                  setState(() => _selectedImage = i);
                  _pageController.animateToPage(i,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut);
                },
              ),
            ),
          ),

          // ── Product Details ──────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pagePadding,
                  AppSpacing.xxl,
                  AppSpacing.pagePadding,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Brand & Rating — من بيانات المنتج الفعلية
                    _RealBrandAndRating(product: product),
                    const SizedBox(height: AppSpacing.md),

                    // Product name
                    Text(
                      product.name,
                      style: AppTypography.h1.copyWith(
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // ✅ Real price from product model
                    _RealPriceRow(product: product),

                    const SizedBox(height: AppSpacing.xxl),
                    const DeliveryInfoStrip(),
                    const SizedBox(height: AppSpacing.xxl),
                    const _SectionDivider(),
                    const SizedBox(height: AppSpacing.xl),

                    // ✅ Color selection من الـ variants الفعلية
                    if (product.variants.isNotEmpty) ...[
                      _SectionHeader(title: 'Color'),
                      const SizedBox(height: AppSpacing.lg),
                      _ColorSelector(
                        variants: product.variants,
                        selectedColorHex: _selectedColor,
                        hexToColor: _hexToColor,
                        onSelect: (hex) {
                          setState(() {
                            _selectedColor = hex;
                            // reset size لو اللون الجديد ما عندوش نفس الـ size
                            final variant = product.variants.firstWhere(
                              (v) => v.colorHex == hex,
                              orElse: () => product.variants.first,
                            );
                            if (variant.sizes.isNotEmpty) {
                              final sizeExists = variant.sizes
                                  .any((s) => s.size == _selectedSize);
                              if (!sizeExists) {
                                _selectedSize = variant.sizes.first.size;
                              }
                            }
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                    ],

                    // ✅ Size selection
                    if (_availableSizes.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _SectionHeader(title: 'Size'),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Size Guide →',
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SizeSelector(
                        sizes: _availableSizes,
                        selected: _selectedSize,
                        onSelect: (s) => setState(() => _selectedSize = s),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                    ],

                    // Tab bar
                    const _SectionDivider(),
                    const SizedBox(height: AppSpacing.lg),
                    _StyledTabBar(controller: _tabController),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      height: 220,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _DescriptionTab(
                              description: product.description),
                          _SpecsTab(product: product),
                          _ReviewsTab(
                            rating: product.rating,
                            reviewsCount: product.reviews,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _ProductBottomBar(
        product: product,
        selectedSize: _selectedSize,
        selectedColor: _selectedColor,
      ),
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sign In Required'),
        content: const Text(
            'Sign in to save items to your wishlist.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.push(AppRoutes.login);
            },
            child: Text('Sign In',
                style: TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  ✅ REAL Brand & Rating — من بيانات المنتج
// ══════════════════════════════════════════════════════════

class _RealBrandAndRating extends StatelessWidget {
  final ProductModel product;
  const _RealBrandAndRating({required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Brand badge — بيعرض اسم الـ Category
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: AppColors.accent.withOpacity(0.25),
              width: 1,
            ),
          ),
          child: Text(
            product.categoryName,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const Spacer(),
        // Rating chip — من بيانات المنتج الفعلية
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            boxShadow: AppColors.cardShadow,
          ),
          child: Row(
            children: [
              const Icon(Icons.star_rounded,
                  color: AppColors.starFilled, size: 16),
              const SizedBox(width: 4),
              Text(
                product.formattedRating,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                ' (${product.formattedReviews})',
                style:
                    AppTypography.bodySmall.copyWith(fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════
//  ✅ REAL Price Row — من بيانات المنتج
// ══════════════════════════════════════════════════════════

class _RealPriceRow extends StatelessWidget {
  final ProductModel product;
  const _RealPriceRow({required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          product.formattedPrice,
          style: AppTypography.priceLarge,
        ),
        const Spacer(),
        // In stock badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: product.inStock
                ? AppColors.success.withOpacity(0.1)
                : AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(
            product.inStock ? 'In Stock' : 'Out of Stock',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ).copyWith(
              color: product.inStock ? AppColors.success : AppColors.error,
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════
//  ✅ Color Selector — من الـ variants الفعلية
// ══════════════════════════════════════════════════════════

class _ColorSelector extends StatelessWidget {
  final List<VariantModel> variants;
  final String selectedColorHex;
  final Color Function(String) hexToColor;
  final ValueChanged<String> onSelect;

  const _ColorSelector({
    required this.variants,
    required this.selectedColorHex,
    required this.hexToColor,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: variants.map((variant) {
        final isSelected = selectedColorHex == variant.colorHex;
        final color = hexToColor(variant.colorHex);

        return GestureDetector(
          onTap: () => onSelect(variant.colorHex),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: isSelected ? 44 : 36,
            height: isSelected ? 44 : 36,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: AppColors.accent, width: 2.5)
                  : Border.all(
                      color: Colors.grey.withOpacity(0.3), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(isSelected ? 0.5 : 0.2),
                  blurRadius: isSelected ? 16 : 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: isSelected
                ? Icon(
                    Icons.check_rounded,
                    color: _contrastColor(color),
                    size: 18,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }

  /// اختار أبيض أو أسود حسب لون الخلفية
  Color _contrastColor(Color bg) {
    final luminance = bg.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

// ══════════════════════════════════════════════════════════
//  IMAGE SECTION
// ══════════════════════════════════════════════════════════

class _ProductImageSection extends StatelessWidget {
  final List<String> images;
  final int selectedIndex;
  final PageController pageController;
  final ValueChanged<int> onSelect;

  const _ProductImageSection({
    required this.images,
    required this.selectedIndex,
    required this.pageController,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F3FA),
      child: Stack(
        children: [
          // Main image
          PageView.builder(
            controller: pageController,
            onPageChanged: onSelect,
            itemCount: images.length,
            itemBuilder: (_, i) {
              final url = images[i];
              return Hero(
                tag: 'product-image-${i}',
                child: url.isEmpty
                    ? const Center(
                        child: Icon(Icons.image_outlined,
                            size: 80, color: AppColors.textHint))
                    : Image.network(
                        url,
                        fit: BoxFit.cover,
                        loadingBuilder: (ctx, child, progress) {
                          if (progress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: progress.expectedTotalBytes != null
                                  ? progress.cumulativeBytesLoaded /
                                      progress.expectedTotalBytes!
                                  : null,
                              color: AppColors.accent,
                              strokeWidth: 2,
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.image_outlined,
                              size: 80, color: AppColors.textHint),
                        ),
                      ),
              );
            },
          ),

          // Thumbnails
          if (images.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (i) {
                  final isSelected = selectedIndex == i;
                  return GestureDetector(
                    onTap: () => onSelect(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      margin:
                          const EdgeInsets.symmetric(horizontal: 5),
                      width: isSelected ? 66 : 56,
                      height: isSelected ? 66 : 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.accent
                              : Colors.white.withOpacity(0.6),
                          width: isSelected ? 2.5 : 1.5,
                        ),
                        boxShadow: isSelected
                            ? AppColors.accentShadow
                            : AppColors.cardShadow,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: images[i].isEmpty
                            ? Container(
                                color: AppColors.surfaceVariant,
                                child: const Icon(
                                  Icons.image_outlined,
                                  size: 18,
                                  color: AppColors.textHint,
                                ),
                              )
                            : Image.network(
                                images[i],
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: AppColors.surfaceVariant,
                                  child: const Icon(
                                    Icons.image_outlined,
                                    size: 18,
                                    color: AppColors.textHint,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  TAB BAR
// ══════════════════════════════════════════════════════════

class _StyledTabBar extends StatelessWidget {
  final TabController controller;

  const _StyledTabBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          gradient: AppColors.accentGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppColors.accentShadow,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AppColors.white,
        unselectedLabelColor: AppColors.textHint,
        labelStyle: AppTypography.labelMedium.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
        unselectedLabelStyle:
            AppTypography.labelMedium.copyWith(fontSize: 13),
        padding: const EdgeInsets.all(4),
        tabs: const [
          Tab(text: 'Description'),
          Tab(text: 'Specs'),
          Tab(text: 'Reviews'),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  TAB CONTENT
// ══════════════════════════════════════════════════════════

class _DescriptionTab extends StatelessWidget {
  final String description;
  const _DescriptionTab({required this.description});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Text(
        description.isEmpty ? 'No description available.' : description,
        style: AppTypography.bodyMedium.copyWith(height: 1.7, fontSize: 14),
      ),
    );
  }
}

/// ✅ Specs — بيعرض بيانات الـ variants الفعلية
class _SpecsTab extends StatelessWidget {
  final ProductModel product;
  const _SpecsTab({required this.product});

  @override
  Widget build(BuildContext context) {
    final specs = <(String, String)>[
      ('Category', product.categoryName),
      ('Available Colors', product.availableColors.length.toString()),
      ('Available Sizes', product.availableSizes.join(', ')),
      ('Status', product.isAvailable ? 'Available' : 'Unavailable'),
      ('Stock', product.inStock ? 'In Stock' : 'Out of Stock'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: specs.map((s) => _SpecRow(label: s.$1, value: s.$2)).toList(),
    );
  }
}

class _ReviewsTab extends StatelessWidget {
  final double rating;
  final int reviewsCount;

  const _ReviewsTab(
      {required this.rating, required this.reviewsCount});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ...List.generate(
                5,
                (i) => Icon(
                  i < rating.round()
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  size: 20,
                  color: i < rating.round()
                      ? AppColors.starFilled
                      : AppColors.starEmpty,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$rating',
                style: AppTypography.labelLarge,
              ),
              const SizedBox(width: 8),
              Text(
                '($reviewsCount reviews)',
                style: AppTypography.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (reviewsCount == 0)
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Icon(Icons.rate_review_outlined,
                      size: 40,
                      color: AppColors.textHint.withOpacity(0.4)),
                  const SizedBox(height: 8),
                  Text('No reviews yet',
                      style: AppTypography.bodyMedium
                          .copyWith(color: AppColors.textHint)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  SPEC ROW
// ══════════════════════════════════════════════════════════

class _SpecRow extends StatelessWidget {
  final String label;
  final String value;

  const _SpecRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: AppTypography.labelMedium
                  .copyWith(color: AppColors.textHint),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
//  BOTTOM BAR — ✅ يستلم product + size + color
// ══════════════════════════════════════════════════════════

class _ProductBottomBar extends StatefulWidget {
  final ProductModel product;
  final String selectedSize;
  final String selectedColor;

  const _ProductBottomBar({
    required this.product,
    required this.selectedSize,
    required this.selectedColor,
  });

  @override
  State<_ProductBottomBar> createState() => _ProductBottomBarState();
}

class _ProductBottomBarState extends State<_ProductBottomBar> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    final isLoggedIn =
        context.watch<AuthCubit>().state.status == AuthStatus.success;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        AppSpacing.lg,
        AppSpacing.pagePadding,
        AppSpacing.pagePadding + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Quantity control
          _QuantityControl(
            quantity: _qty,
            onIncrement: () => setState(() => _qty++),
            onDecrement: () {
              if (_qty > 1) setState(() => _qty--);
            },
          ),
          const SizedBox(width: AppSpacing.lg),

          // ✅ Add to Cart button
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!isLoggedIn) {
                  // Guest → اعرض dialog تسجيل الدخول
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      title: const Text('Sign In Required'),
                      content: const Text(
                          'Sign in to add items to your cart.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            context.push(AppRoutes.login);
                          },
                          child: Text('Sign In',
                              style:
                                  TextStyle(color: AppColors.accent)),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                if (widget.selectedSize.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a size')),
                  );
                  return;
                }

                context.read<CartCubit>().addToCart(
                      productId: widget.product.id,
                      quantity: _qty,
                      size: widget.selectedSize,
                      color: widget.selectedColor.isEmpty
                          ? '#000000'
                          : widget.selectedColor,
                    );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${widget.product.name} added to cart!'),
                    backgroundColor: AppColors.success,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  gradient: widget.product.inStock
                      ? AppColors.accentGradient
                      : LinearGradient(
                          colors: [
                            AppColors.textHint,
                            AppColors.textHint,
                          ],
                        ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow:
                      widget.product.inStock ? AppColors.accentShadow : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_bag_outlined,
                        color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      widget.product.inStock
                          ? AppStrings.addToCart
                          : 'Out of Stock',
                      style: AppTypography.buttonLarge.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Quantity Control ─────────────────────────────────────

class _QuantityControl extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _QuantityControl({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QtyBtn(icon: Icons.remove_rounded, onTap: onDecrement),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              '$quantity',
              style: AppTypography.h3.copyWith(fontSize: 16),
            ),
          ),
          _QtyBtn(
              icon: Icons.add_rounded, onTap: onIncrement, filled: true),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const _QtyBtn(
      {required this.icon, required this.onTap, this.filled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 46,
        decoration: BoxDecoration(
          gradient: filled ? AppColors.accentGradient : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 18,
          color: filled ? AppColors.white : AppColors.textSecondary,
        ),
      ),
    );
  }
}

// ─── Helper widgets ───────────────────────────────────────

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: AppColors.divider);
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.h3.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
    );
  }
}