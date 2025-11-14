enum ProductCategory {
  groceries,
  electronics,
  cars,
  phones,
  appliances,
  fashion,
  furniture,
  other
}

class ProductModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final ProductCategory category;
  final String sellerId;
  final String sellerName;
  final String sellerLocation;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final int stockQuantity;
  final bool isAvailable;
  final DateTime createdAt;

  // Additional getters for compatibility
  String get name => title;
  String get imageUrl => images.isNotEmpty ? images.first : '';
  int get stock => stockQuantity;
  double get discount => 0.0; // No discount field in model
  double get originalPrice => price; // Same as price for now
  bool get isFavorite => false; // This will be managed by provider

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.sellerId,
    required this.sellerName,
    required this.sellerLocation,
    required this.images,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.stockQuantity = 0,
    this.isAvailable = true,
    required this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: ProductCategory.values.firstWhere(
        (e) => e.toString() == 'ProductCategory.${json['category']}',
        orElse: () => ProductCategory.other,
      ),
      sellerId: json['sellerId'] ?? '',
      sellerName: json['sellerName'] ?? '',
      sellerLocation: json['sellerLocation'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      stockQuantity: json['stockQuantity'] ?? 0,
      isAvailable: json['isAvailable'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category': category.toString().split('.').last,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerLocation': sellerLocation,
      'images': images,
      'rating': rating,
      'reviewCount': reviewCount,
      'stockQuantity': stockQuantity,
      'isAvailable': isAvailable,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
