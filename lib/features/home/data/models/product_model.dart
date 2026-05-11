
// ══════════════════════════════════════════════════════════
//  PRODUCT MODELS
// ══════════════════════════════════════════════════════════

class ProductResponseModel {
  final int count;
  final String? next;
  final String? previous;
  final List<ProductModel> results;

  ProductResponseModel({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductResponseModel(
      count: json['count'] as int,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ProductModel {
  final int id;
  final String name;
  final String price;
  final int category;
  final String categoryName;
  final String image;
  final String description;
  final List<VariantModel> variants;
  final bool isAvailable;
  final double rating;
  final int reviews;
  final bool inStock;
  final bool featured;
  final bool trending;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.categoryName,
    required this.image,
    required this.description,
    required this.variants,
    required this.isAvailable,
    required this.rating,
    required this.reviews,
    required this.inStock,
    required this.featured,
    required this.trending,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    try {
      final variantsList = json['variants'] as List<dynamic>?;
      final variants = variantsList != null
          ? variantsList
              .map((e) => VariantModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : <VariantModel>[];

      return ProductModel(
        id: json['id'] as int,
        name: json['name'] as String,
        price: json['price'] as String,
        category: json['category'] as int,
        categoryName: json['category_name'] as String? ?? 'Unknown',
        image: json['image'] as String? ?? '',
        description: json['description'] as String? ?? '',
        variants: variants,
        isAvailable: json['is_available'] as bool? ?? true,
        rating: ((json['rating'] as num?) ?? 0).toDouble(),
        reviews: json['reviews'] as int? ?? 0,
        inStock: json['in_stock'] as bool? ?? true,
        featured: json['featured'] as bool? ?? false,
        trending: json['trending'] as bool? ?? false,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : DateTime.now(),
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'] as String)
            : DateTime.now(),
      );
    } catch (e) {
      print('Error parsing product: $e');
      rethrow;
    }
  }

  /// Computed helpers
  double get priceValue => double.tryParse(price) ?? 0.0;
  String get formattedPrice => '\$${priceValue.toStringAsFixed(2)}';
  String get formattedRating => rating.toStringAsFixed(1);
  String get formattedReviews =>
      reviews >= 1000 ? '${(reviews / 1000).toStringAsFixed(1)}k' : '$reviews';

  List<String> get availableColors {
    try {
      return variants.where((v) => v.totalStock > 0).map((v) => v.color).toList();
    } catch (e) {
      print('Error getting availableColors: $e');
      return [];
    }
  }

  List<String> get availableSizes {
    try {
      return variants
          .expand((v) => v.sizes.where((s) => s.quantity > 0).map((s) => s.size))
          .toSet()
          .toList();
    } catch (e) {
      print('Error getting availableSizes: $e');
      return [];
    }
  }

  VariantModel? variantForColorHex(String colorHex) {
    try {
      return variants.firstWhere(
        (v) => v.colorHex.toLowerCase() == colorHex.trim().toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  SizeModel? sizeForVariant(String colorHex, String size) {
    final variant = variantForColorHex(colorHex);
    if (variant == null) return null;
    try {
      return variant.sizes.firstWhere(
        (s) => s.size.toLowerCase() == size.trim().toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  bool isVariantAvailable(String colorHex, String size) {
    final selectedSize = sizeForVariant(colorHex, size);
    return selectedSize != null && selectedSize.quantity > 0;
  }

  int availableQuantity(String colorHex, String size) {
    return sizeForVariant(colorHex, size)?.quantity ?? 0;
  }
}

class VariantModel {
  final int id;
  final String color;
  final String colorHex;
  final String image;
  final int totalStock;
  final List<SizeModel> sizes;

  VariantModel({
    required this.id,
    required this.color,
    required this.colorHex,
    required this.image,
    required this.totalStock,
    required this.sizes,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    final sizesData = json['sizes'];
    final parsedSizes = sizesData is List<dynamic>
        ? sizesData
            .map((e) => SizeModel.fromJson(e as Map<String, dynamic>))
            .toList()
        : <SizeModel>[];

    return VariantModel(
      id: json['id'] as int? ?? 0,
      color: json['color'] as String? ?? '',
      colorHex: json['color_hex'] as String? ?? '',
      image: json['image'] as String? ?? '',
      totalStock: json['total_stock'] as int? ?? 0,
      sizes: parsedSizes,
    );
  }
}

class SizeModel {
  final int id;
  final String size;
  final int quantity;

  SizeModel({
    required this.id,
    required this.size,
    required this.quantity,
  });

  factory SizeModel.fromJson(Map<String, dynamic> json) {
    return SizeModel(
      id: json['id'] as int,
      size: json['size'] as String,
      quantity: json['quantity'] as int,
    );
  }
}

// ══════════════════════════════════════════════════════════
//  MOCK DATA (for fallback)
// ══════════════════════════════════════════════════════════

// class ProductMockData {

//   ProductMockData._();

//   static const List<ProductModel> featured = [
//     ProductModel(
//       id: 'p1',
//       name: 'Samsung Galaxy S25',
//       brand: 'Samsung',
//       imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=300&h=300&fit=crop',
//       price: 299,
//       originalPrice: 399,
//       rating: 4.3,
//       reviewCount: 2400,
//       discount: '-25%',
//       isFeatured: true,
//       categoryId: 'electronics',
//       colors: ['#1A1A2E', '#E2E8F0', '#6366F1'],
//       sizes: [],
//     ),
//     ProductModel(
//       id: 'p2',
//       name: 'Nike Air Max 2025',
//       brand: 'Nike',
//       imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300&h=300&fit=crop',
//       price: 149,
//       originalPrice: 199,
//       rating: 4.7,
//       reviewCount: 3800,
//       discount: '-25%',
//       isFeatured: true,
//       categoryId: 'fashion',
//       colors: ['#000000', '#FFFFFF', '#F97316'],
//       sizes: ['38', '39', '40', '41', '42', '43', '44'],
//     ),
//     ProductModel(
//       id: 'p3',
//       name: 'Chanel N°5 EDP',
//       brand: 'Chanel',
//       imageUrl: 'https://images.unsplash.com/photo-1585386959984-a4155224a1ad?w=300&h=300&fit=crop',
//       price: 189,
//       originalPrice: 249,
//       rating: 4.5,
//       reviewCount: 1200,
//       discount: '-24%',
//       isFeatured: true,
//       categoryId: 'beauty',
//       colors: ['#F5E6D3', '#D4A96A'],
//       sizes: ['30ml', '50ml', '100ml'],
//     ),
//     ProductModel(
//       id: 'p4',
//       name: 'Adidas Ultraboost',
//       brand: 'Adidas',
//       imageUrl: 'https://images.unsplash.com/photo-1491553895911-0055eca6402d?w=300&h=300&fit=crop',
//       price: 179,
//       originalPrice: 229,
//       rating: 4.8,
//       reviewCount: 5100,
//       discount: '-22%',
//       isFeatured: true,
//       categoryId: 'sports',
//       colors: ['#1A1A2E', '#FFFFFF', '#22C55E'],
//       sizes: ['39', '40', '41', '42', '43'],
//     ),
//     ProductModel(
//       id: 'p5',
//       name: 'Sony WH-1000XM5',
//       brand: 'Sony',
//       imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300&h=300&fit=crop',
//       price: 349,
//       originalPrice: 449,
//       rating: 4.9,
//       reviewCount: 7200,
//       discount: '-22%',
//       isFeatured: true,
//       categoryId: 'electronics',
//       colors: ['#1A1A2E', '#F5E6D3'],
//       sizes: [],
//     ),
//     ProductModel(
//       id: 'p6',
//       name: 'Ray-Ban Aviator',
//       brand: 'Ray-Ban',
//       imageUrl: 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=300&h=300&fit=crop',
//       price: 179,
//       originalPrice: 229,
//       rating: 4.2,
//       reviewCount: 980,
//       discount: '-22%',
//       isFeatured: true,
//       categoryId: 'fashion',
//       colors: ['#D4A96A', '#1A1A2E'],
//       sizes: [],
//     ),
//     ProductModel(
//       id: 'p7',
//       name: 'Apple Watch Ultra',
//       brand: 'Apple',
//       imageUrl: 'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=300&h=300&fit=crop',
//       price: 799,
//       originalPrice: 999,
//       rating: 4.8,
//       reviewCount: 4300,
//       discount: '-20%',
//       isFeatured: true,
//       categoryId: 'electronics',
//       colors: ['#E2E8F0', '#D4A96A', '#1A1A2E'],
//       sizes: ['40mm', '44mm'],
//     ),
//     ProductModel(
//       id: 'p8',
//       name: 'Dyson AirWrap',
//       brand: 'Dyson',
//       imageUrl: 'https://images.unsplash.com/photo-1585386959984-a4155224a1ad?w=300&h=300&fit=crop',
//       price: 599,
//       originalPrice: 799,
//       rating: 4.6,
//       reviewCount: 2100,
//       discount: '-25%',
//       isFeatured: true,
//       categoryId: 'beauty',
//       colors: ['#C084FC', '#F5E6D3'],
//       sizes: [],
//     ),
//   ];

//   static const List<ProductModel> newArrivals = [
//     ProductModel(
//       id: 'n1',
//       name: 'iPad Pro M4',
//       brand: 'Apple',
//       imageUrl: 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=300&h=300&fit=crop',
//       price: 1099,
//       originalPrice: 1099,
//       rating: 4.9,
//       reviewCount: 320,
//       discount: '',
//       isNew: true,
//       categoryId: 'electronics',
//       colors: ['#E2E8F0', '#6366F1'],
//       sizes: ['11"', '13"'],
//     ),
//     ProductModel(
//       id: 'n2',
//       name: 'Levi\'s 501 Original',
//       brand: 'Levi\'s',
//       imageUrl: 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=300&h=300&fit=crop',
//       price: 89,
//       originalPrice: 119,
//       rating: 4.4,
//       reviewCount: 870,
//       discount: '-25%',
//       isNew: true,
//       categoryId: 'fashion',
//       colors: ['#1A1A2E', '#6B7280', '#D4A96A'],
//       sizes: ['S', 'M', 'L', 'XL', 'XXL'],
//     ),
//     ProductModel(
//       id: 'n3',
//       name: 'La Mer Moisturizer',
//       brand: 'La Mer',
//       imageUrl: 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=300&h=300&fit=crop',
//       price: 199,
//       originalPrice: 199,
//       rating: 4.7,
//       reviewCount: 460,
//       discount: '',
//       isNew: true,
//       categoryId: 'beauty',
//       colors: ['#1E3A5F'],
//       sizes: ['30ml', '60ml'],
//     ),
//     ProductModel(
//       id: 'n4',
//       name: 'Garmin Fenix 8',
//       brand: 'Garmin',
//       imageUrl: 'https://images.unsplash.com/photo-1544117519-31a4b719223d?w=300&h=300&fit=crop',
//       price: 699,
//       originalPrice: 849,
//       rating: 4.8,
//       reviewCount: 1100,
//       discount: '-18%',
//       isNew: true,
//       categoryId: 'sports',
//       colors: ['#1A1A2E', '#E2E8F0', '#D4A96A'],
//       sizes: ['42mm', '47mm'],
//     ),
//     ProductModel(
//       id: 'n5',
//       name: 'IKEA Kallax Shelf',
//       brand: 'IKEA',
//       imageUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=300&h=300&fit=crop',
//       price: 59,
//       originalPrice: 79,
//       rating: 4.3,
//       reviewCount: 2200,
//       discount: '-25%',
//       isNew: true,
//       categoryId: 'home',
//       colors: ['#FFFFFF', '#1A1A2E', '#D4A96A'],
//       sizes: ['1x4', '2x2', '2x4', '4x4'],
//     ),
//     ProductModel(
//       id: 'n6',
//       name: 'Zara Trench Coat',
//       brand: 'Zara',
//       imageUrl: 'https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=300&h=300&fit=crop',
//       price: 129,
//       originalPrice: 169,
//       rating: 4.5,
//       reviewCount: 630,
//       discount: '-24%',
//       isNew: true,
//       categoryId: 'fashion',
//       colors: ['#D4A96A', '#1A1A2E', '#E2E8F0'],
//       sizes: ['XS', 'S', 'M', 'L', 'XL'],
//     ),
//   ];
// }
