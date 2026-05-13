import 'package:flutter/material.dart';
import 'package:real_ecommerce/core/helpers/responsive.dart';
import 'package:real_ecommerce/features/home/data/models/product_model.dart';
import 'package:real_ecommerce/features/home/view/widgets/details/product_detail_screen_desktop.dart';
import 'package:real_ecommerce/features/home/view/widgets/details/product_detail_screen_mobile.dart';

/// شاشة تفاصيل المنتج — الـ state هنا، والـ UI في ملفات الـ layout المنفصلة.
class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  int _selectedImage = 0;
  late String _selectedSize;
  late String _selectedColorHex;
  late String _selectedColorName;
  bool _isWishlisted = false;

  late final TabController _tabController;
  late final PageController _pageController;
  late final List<String> _galleryImages;
  late final List<String> _sizes;

  @override
  void initState() {
    super.initState();
    _galleryImages = [
      widget.product.image,
      ...widget.product.variants.map((v) => v.image),
    ];

    _sizes = widget.product.availableSizes.isNotEmpty
        ? widget.product.availableSizes
        : ['M'];

    _selectedSize = _sizes.first;
    if (widget.product.variants.isNotEmpty) {
      final initialVariant = widget.product.variants.first;
      _selectedColorHex = initialVariant.colorHex;
      _selectedColorName = initialVariant.color;
    } else {
      _selectedColorHex = '#0A0F1E';
      _selectedColorName = '';
    }

    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onImageSelect(int i) {
    setState(() => _selectedImage = i);
    _pageController.animateToPage(
      i,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final shared = (
      product: widget.product,
      galleryImages: _galleryImages,
      selectedImage: _selectedImage,
      selectedSize: _selectedSize,
      selectedColorHex: _selectedColorHex,
      selectedColorName: _selectedColorName,
      isWishlisted: _isWishlisted,
      sizes: _sizes,
      tabController: _tabController,
      pageController: _pageController,
      onImageSelect: _onImageSelect,
      onSizeSelect: (String s) => setState(() => _selectedSize = s),
      onColorSelect: (String c) {
        if (widget.product.variants.isEmpty) return;
        final selectedVariant = widget.product.variants.firstWhere(
          (v) => v.colorHex == c,
          orElse: () => widget.product.variants.first,
        );
        setState(() {
          _selectedColorHex = c;
          _selectedColorName = selectedVariant.color;
        });
      },
      onWishlistToggle: () => setState(() => _isWishlisted = !_isWishlisted),
    );

    return Responsive(
      mobile: ProductDetailMobile(
        product: shared.product,
        galleryImages: shared.galleryImages,
        selectedImage: shared.selectedImage,
        selectedSize: shared.selectedSize,
        selectedColorHex: shared.selectedColorHex,
        selectedColorName: shared.selectedColorName,
        isWishlisted: shared.isWishlisted,
        sizes: shared.sizes,
        tabController: shared.tabController,
        pageController: shared.pageController,
        onImageSelect: shared.onImageSelect,
        onSizeSelect: shared.onSizeSelect,
        onColorSelect: shared.onColorSelect,
        onWishlistToggle: shared.onWishlistToggle,
      ),
      desktop: ProductDetailDesktop(
        product: shared.product,
        galleryImages: shared.galleryImages,
        selectedImage: shared.selectedImage,
        selectedSize: shared.selectedSize,
        selectedColorHex: shared.selectedColorHex,
        selectedColorName: shared.selectedColorName,
        isWishlisted: shared.isWishlisted,
        sizes: shared.sizes,
        tabController: shared.tabController,
        pageController: shared.pageController,
        onImageSelect: shared.onImageSelect,
        onSizeSelect: shared.onSizeSelect,
        onColorSelect: shared.onColorSelect,
        onWishlistToggle: shared.onWishlistToggle,
      ),
    );
  }
}
