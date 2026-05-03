import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/core/themes/app_typography.dart';
import 'package:real_ecommerce/features/address/data/models/address_model.dart';
import 'package:real_ecommerce/features/address/logic/address_cubit.dart';
import 'map_page.dart';

class MyAddressesPage extends StatelessWidget {
  const MyAddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Addresses', style: AppTypography.h3)),
      body: BlocBuilder<AddressCubit, AddressState>(
        builder: (context, state) {
          if (state.addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('No saved addresses', style: AppTypography.h3),
                  const SizedBox(height: 8),
                  Text('Add your first delivery address', style: AppTypography.bodyMedium),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.addresses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final address = state.addresses[i];
              return _AddressTile(
                address: address,
                onEdit: () async {
                  final result = await MapPage.open(context, existingAddress: address);
                  if (result != null && context.mounted) {
                    context.read<AddressCubit>().removeAddress(address.id);
                    context.read<AddressCubit>().addAddress(result);
                  }
                },
                onDelete: () => context.read<AddressCubit>().removeAddress(address.id),
                onSetDefault: () => context.read<AddressCubit>().setDefault(address.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          final result = await MapPage.open(context);
          if (result != null && context.mounted) {
            context.read<AddressCubit>().addAddress(result);
          }
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Address', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class _AddressTile extends StatelessWidget {
  final AddressModel address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const _AddressTile({
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: address.isDefault ? AppColors.primary : AppColors.divider,
          width: address.isDefault ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              address.label.toLowerCase() == 'work' ? Icons.work_outline : Icons.home_outlined,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(address.label, style: AppTypography.labelLarge),
                    if (address.isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Default', style: TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(address.fullAddress, style: AppTypography.bodySmall, maxLines: 2),
              ],
            ),
          ),
          PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(value: 'default', child: Text('Set as Default')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
            onSelected: (val) {
              if (val == 'edit') onEdit();
              if (val == 'default') onSetDefault();
              if (val == 'delete') onDelete();
            },
          ),
        ],
      ),
    );
  }
}