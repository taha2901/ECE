import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/features/home/data/models/category_model.dart';

// ══════════════════════════════════════════════════════════
//  STATES
// ══════════════════════════════════════════════════════════

sealed class CategoryState {
  const CategoryState();
}

final class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

final class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

final class CategoryLoaded extends CategoryState {
  final List<CategoryModel> categories;

  /// الصنف المختار — مش بيسبب أي تأثير على الـ widgets التانية
  final String selectedId;

  const CategoryLoaded({
    required this.categories,
    this.selectedId = 'all',
  });

  CategoryLoaded copyWith({
    List<CategoryModel>? categories,
    String? selectedId,
  }) =>
      CategoryLoaded(
        categories: categories ?? this.categories,
        selectedId: selectedId ?? this.selectedId,
      );
}

final class CategoryError extends CategoryState {
  final String message;
  const CategoryError(this.message);
}

// ══════════════════════════════════════════════════════════
//  CUBIT
// ══════════════════════════════════════════════════════════

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(const CategoryInitial());

  Future<void> loadCategories() async {
    emit(const CategoryLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      // 🔌 استبدل بـ: await _repository.getCategories()
      emit(CategoryLoaded(categories: CategoryMockData.categories));
    } catch (e) {
      emit(const CategoryError('Failed to load categories.'));
    }
  }

  /// بيغير الـ selectedId بس — مش بيأثر على البانرز أو المنتجات
  void selectCategory(String id) {
    final current = state;
    if (current is! CategoryLoaded) return;
    if (current.selectedId == id) return; // نفس الصنف → مفيش emit
    emit(current.copyWith(selectedId: id));
  }

  Future<void> retry() => loadCategories();
}