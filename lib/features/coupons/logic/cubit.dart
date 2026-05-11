import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/features/coupons/data/repo/coupon_repository.dart';
import 'package:real_ecommerce/features/coupons/logic/states.dart';

class CouponCubit extends Cubit<CouponState> {
  final CouponRepository _repository;

  CouponCubit(this._repository) : super(const CouponInitial());

  Future<void> loadCoupons() async {
    emit(const CouponLoading());

    final result = await _repository.getActiveCoupons();
    result.when(
      success: (coupons) => emit(CouponLoaded(coupons)),
      failure: (error) => emit(CouponError(error.apiErrorModel.message ?? 'Unable to load coupons')),
    );
  }
}
