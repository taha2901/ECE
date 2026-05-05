// import 'package:flutter/material.dart';
// import 'package:real_ecommerce/core/constants/app_constants.dart';
// import 'package:real_ecommerce/core/themes/app_colors.dart';
// import 'package:real_ecommerce/core/themes/app_typography.dart';

// class PriceRow extends StatelessWidget {
//   const PriceRow({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Text('\$149.99', style: AppTypography.priceLarge),
//         const SizedBox(width: AppSpacing.md),
//         Text('\$199.99', style: AppTypography.priceStrikethrough),
//         const Spacer(),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//           decoration: BoxDecoration(
//             gradient: AppColors.accentGradient,
//             borderRadius: BorderRadius.circular(AppRadius.pill),
//           ),
//           child: Text(
//             'SAVE 25%',
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 11,
//               fontWeight: FontWeight.w800,
//               letterSpacing: 0.5,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
