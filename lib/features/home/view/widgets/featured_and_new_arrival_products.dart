import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_ecommerce/core/constants/app_constants.dart';
import 'package:real_ecommerce/core/themes/app_colors.dart';
import 'package:real_ecommerce/features/home/data/models/product_model.dart';
import 'package:real_ecommerce/features/home/logic/category_cubit.dart';
import 'package:real_ecommerce/features/home/logic/product_cubit.dart';
import 'package:real_ecommerce/features/home/view/widgets/product_widgets.dart';


class FeaturedProductsRow extends StatelessWidget {
  const FeaturedProductsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      buildWhen: (prev, curr) {
        if (prev is CategoryLoaded && curr is CategoryLoaded) {
          return prev.selectedId != curr.selectedId;
        }
        return false;
      },
      builder: (context, catState) {
        final selectedId =
            catState is CategoryLoaded ? catState.selectedId : 'all';
        return BlocBuilder<ProductCubit, ProductState>(
          buildWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
          builder: (context, productState) {
            if (productState is ProductLoading) {
              return const _ProductsShimmer(isRow: true);
            }

            if (productState is! ProductLoaded) {
              return const SizedBox.shrink();
            }
            final products = _filterProducts(
              productState.featured,
              selectedId,
            );

            if (products.isEmpty) {
              return const _EmptyProducts(
                  message: 'No featured products in this category');
            }

            return SizedBox(
              height: 250,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.pagePadding),
                itemCount: products.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.lg),
                itemBuilder: (_, i) =>
                    ProductCardVertical(product: products[i]),
              ),
            );
          },
        );
      },
    );
  }
}


class NewArrivalsGrid extends StatelessWidget {
  const NewArrivalsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      buildWhen: (prev, curr) {
        if (prev is CategoryLoaded && curr is CategoryLoaded) {
          return prev.selectedId != curr.selectedId;
        }
        return false;
      },
      builder: (context, catState) {
        final selectedId =
            catState is CategoryLoaded ? catState.selectedId : 'all';

        return BlocBuilder<ProductCubit, ProductState>(
          buildWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
          builder: (context, productState) {
            if (productState is ProductLoading) {
              return const _ProductsShimmer(isRow: false);
            }

            if (productState is! ProductLoaded) {
              return const SizedBox.shrink();
            }

            final products = _filterProducts(
              productState.trending,
              selectedId,
            );

            if (products.isEmpty) {
              return const _EmptyProducts(
                  message: 'No new arrivals in this category');
            }

            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pagePadding),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.lg,
                  crossAxisSpacing: AppSpacing.lg,
                  childAspectRatio: 0.72,
                ),
                itemCount: products.length,
                itemBuilder: (_, i) =>
                    ProductCardGrid(product: products[i]),
              ),
            );
          },
        );
      },
    );
  }
}


List<ProductModel> _filterProducts(
  List<ProductModel> products,
  String selectedId,
) {
  if (selectedId == 'all') return products;
  return products.where((p) => p.category.toString() == selectedId).toList();
}

class _EmptyProducts extends StatelessWidget {
  final String message;
  const _EmptyProducts({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_rounded,
                size: 40, color: AppColors.textHint.withOpacity(0.5)),
            const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(
                color: AppColors.textHint,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer placeholder بسيط لحين التحميل
class _ProductsShimmer extends StatelessWidget {
  final bool isRow;
  const _ProductsShimmer({required this.isRow});

  @override
  Widget build(BuildContext context) {
    if (isRow) {
      return SizedBox(
        height: 265,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pagePadding),
          itemCount: 4,
          separatorBuilder: (_, __) =>
              const SizedBox(width: AppSpacing.lg),
          itemBuilder: (_, __) => const _ShimmerBox(
              width: 162, height: 265, radius: 20),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pagePadding),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.lg,
          crossAxisSpacing: AppSpacing.lg,
          childAspectRatio: 0.72,
        ),
        itemCount: 4,
        itemBuilder: (_, __) => const _ShimmerBox(radius: 20),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double radius;

  const _ShimmerBox({this.width, this.height, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}