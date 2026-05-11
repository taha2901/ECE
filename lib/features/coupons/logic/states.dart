import 'package:equatable/equatable.dart';

import '../data/models/coupon_model.dart';

abstract class CouponState extends Equatable {
  const CouponState();

  @override
  List<Object?> get props => [];
}

class CouponInitial extends CouponState {
  const CouponInitial();
}

class CouponLoading extends CouponState {
  const CouponLoading();
}

class CouponLoaded extends CouponState {
  final List<CouponModel> coupons;

  const CouponLoaded(this.coupons);

  @override
  List<Object?> get props => [coupons];
}

class CouponError extends CouponState {
  final String message;

  const CouponError(this.message);

  @override
  List<Object?> get props => [message];
}
