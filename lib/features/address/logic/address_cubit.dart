import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/features/address/data/models/address_model.dart';

// ── States ──────────────────────────────────────
class AddressState {
  final List<AddressModel> addresses;
  final bool isLoading;

  const AddressState({
    this.addresses = const [],
    this.isLoading = false,
  });

  AddressState copyWith({List<AddressModel>? addresses, bool? isLoading}) {
    return AddressState(
      addresses: addresses ?? this.addresses,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  AddressModel? get defaultAddress =>
      addresses.where((a) => a.isDefault).firstOrNull ?? addresses.firstOrNull;
}

// ── Cubit ────────────────────────────────────────
class AddressCubit extends Cubit<AddressState> {
  AddressCubit() : super(const AddressState());

  void addAddress(AddressModel address) {
    final updated = List<AddressModel>.from(state.addresses);

    // لو هو default، شيل الـ default من الباقيين
    if (address.isDefault) {
      for (int i = 0; i < updated.length; i++) {
        updated[i] = updated[i].copyWith(isDefault: false);
      }
    }

    updated.add(address);
    emit(state.copyWith(addresses: updated));
  }

  void removeAddress(String id) {
    final updated = state.addresses.where((a) => a.id != id).toList();
    emit(state.copyWith(addresses: updated));
  }

  void setDefault(String id) {
    final updated = state.addresses.map((a) {
      return a.copyWith(isDefault: a.id == id);
    }).toList();
    emit(state.copyWith(addresses: updated));
  }
}