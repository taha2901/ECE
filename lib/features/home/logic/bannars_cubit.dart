import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/features/home/data/models/bannar_model.dart';

// ══════════════════════════════════════════════════════════
//  STATES
// ══════════════════════════════════════════════════════════

sealed class BannerState {
  const BannerState();
}

final class BannerInitial extends BannerState {
  const BannerInitial();
}

final class BannerLoading extends BannerState {
  const BannerLoading();
}

final class BannerLoaded extends BannerState {
  final List<BannerModel> banners;
  const BannerLoaded(this.banners);
}

final class BannerError extends BannerState {
  final String message;
  const BannerError(this.message);
}

// ══════════════════════════════════════════════════════════
//  CUBIT
// ══════════════════════════════════════════════════════════

class BannerCubit extends Cubit<BannerState> {
  BannerCubit() : super(const BannerInitial());

  Future<void> loadBanners() async {
    emit(const BannerLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      // 🔌 استبدل بـ: await _repository.getBanners()
      emit(BannerLoaded(BannerMockData.banners));
    } catch (e) {
      emit(const BannerError('Failed to load banners.'));
    }
  }

  Future<void> retry() => loadBanners();
}