import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';

import '../../../core/constants/app_constants.dart';

class AddAddressSheet extends StatelessWidget {
  const AddAddressSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.xxl),
          topRight: Radius.circular(AppRadius.xxl),
        ),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.pagePadding,
        right: AppSpacing.pagePadding,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.pagePadding,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Add New Address', style: AppTypography.h2),
            const SizedBox(height: AppSpacing.xxl),
            const AppTextField(
              label: 'Full Name',
              hint: 'Enter your name',
              prefixIcon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: AppSpacing.xl),
            const AppTextField(
              label: 'Phone Number',
              hint: '+20 1XX XXX XXXX',
              prefixIcon: Icons.phone_outlined,
            ),
            const SizedBox(height: AppSpacing.xl),
            const AppTextField(
              label: 'Street Address',
              hint: 'Street, building, apartment',
              prefixIcon: Icons.location_on_outlined,
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: const [
                Expanded(
                  child: AppTextField(label: 'City', hint: 'City'),
                ),
                SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: AppTextField(label: 'Postal Code', hint: 'ZIP'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            const AppTextField(
              label: 'Country',
              hint: 'Egypt',
              prefixIcon: Icons.flag_outlined,
            ),
            const SizedBox(height: AppSpacing.xxl),
            GradientButton(
              label: 'Save Address',
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
