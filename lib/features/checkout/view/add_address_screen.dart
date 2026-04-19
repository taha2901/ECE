import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/core/widgets/common_widgets.dart';
import 'package:real_ecommerce/features/checkout/view/add_address_sheet.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('My Addresses')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const AddAddressSheet(),
        ),
        backgroundColor: AppColors.accent,
        icon: const Icon(Icons.add_location_alt_rounded, color: AppColors.white),
        label: Text(
          'Add Address',
          style: AppTypography.labelMedium.copyWith(color: AppColors.white),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        itemCount: 3,
        itemBuilder: (_, i) => AddressCard(isDefault: i == 0),
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  final bool isDefault;

  const AddressCard({super.key, required this.isDefault});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: isDefault
            ? Border.all(color: AppColors.accent, width: 1.5)
            : null,
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDefault
                      ? AppColors.accent.withOpacity(0.1)
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  Icons.home_outlined,
                  color: isDefault ? AppColors.accent : AppColors.textHint,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Home', style: AppTypography.labelLarge),
                  if (isDefault)
                    AppBadge(
                      label: 'Default',
                      backgroundColor: AppColors.accent.withOpacity(0.1),
                      textColor: AppColors.accent,
                      isSmall: true,
                    ),
                ],
              ),
              const Spacer(),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert_rounded, size: 20),
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 16),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 16, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '123 El-Tahrir St, Zamalek\nCairo, Egypt 12345',
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(Icons.phone_outlined, size: 14, color: AppColors.textHint),
              const SizedBox(width: 4),
              Text('+20 100 000 0000', style: AppTypography.bodySmall),
            ],
          ),
          if (!isDefault) ...[
            const SizedBox(height: AppSpacing.lg),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: AppColors.accent,
                padding: EdgeInsets.zero,
              ),
              child: const Text('Set as Default'),
            ),
          ],
        ],
      ),
    );
  }
}
