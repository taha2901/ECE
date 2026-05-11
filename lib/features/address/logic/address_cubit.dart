import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/features/address/data/models/address_model.dart';
import 'package:real_ecommerce/features/address/data/repo/address_repository.dart';

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
  final AddressRepository _repository;

  AddressCubit(this._repository) : super(const AddressState()) {
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    emit(state.copyWith(isLoading: true));
    final saved = await _repository.getAddresses();
    emit(state.copyWith(addresses: saved, isLoading: false));
  }

  Future<void> addAddress(AddressModel address) async {
    await _repository.addAddress(address);
    await loadAddresses();
  }

  Future<void> updateAddress(AddressModel address) async {
    await _repository.updateAddress(address);
    await loadAddresses();
  }

  Future<void> removeAddress(String id) async {
    await _repository.deleteAddress(id);
    await loadAddresses();
  }

  Future<void> setDefault(String id) async {
    await _repository.setDefaultAddress(id);
    await loadAddresses();
  }
}
