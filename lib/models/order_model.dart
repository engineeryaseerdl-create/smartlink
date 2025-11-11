enum OrderStatus { pending, confirmed, pickupReady, inTransit, delivered, cancelled }

class OrderModel {
  final String id;
  final String buyerId;
  final String buyerName;
  final String buyerPhone;
  final String buyerLocation;
  final String sellerId;
  final String sellerName;
  final String sellerLocation;
  final List<OrderItem> items;
  final double totalAmount;
  final OrderStatus status;
  final String? riderId;
  final String? riderName;
  final DateTime createdAt;
  final DateTime? deliveredAt;
  final String deliveryType;

  OrderModel({
    required this.id,
    required this.buyerId,
    required this.buyerName,
    required this.buyerPhone,
    required this.buyerLocation,
    required this.sellerId,
    required this.sellerName,
    required this.sellerLocation,
    required this.items,
    required this.totalAmount,
    required this.status,
    this.riderId,
    this.riderName,
    required this.createdAt,
    this.deliveredAt,
    this.deliveryType = 'okada',
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      buyerId: json['buyerId'] ?? '',
      buyerName: json['buyerName'] ?? '',
      buyerPhone: json['buyerPhone'] ?? '',
      buyerLocation: json['buyerLocation'] ?? '',
      sellerId: json['sellerId'] ?? '',
      sellerName: json['sellerName'] ?? '',
      sellerLocation: json['sellerLocation'] ?? '',
      items: (json['items'] as List? ?? [])
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${json['status']}',
        orElse: () => OrderStatus.pending,
      ),
      riderId: json['riderId'],
      riderName: json['riderName'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      deliveredAt: json['deliveredAt'] != null
          ? DateTime.parse(json['deliveredAt'])
          : null,
      deliveryType: json['deliveryType'] ?? 'okada',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'buyerPhone': buyerPhone,
      'buyerLocation': buyerLocation,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerLocation': sellerLocation,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status.toString().split('.').last,
      'riderId': riderId,
      'riderName': riderName,
      'createdAt': createdAt.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
      'deliveryType': deliveryType,
    };
  }
}

class OrderItem {
  final String productId;
  final String productTitle;
  final String productImage;
  final int quantity;
  final double price;

  OrderItem({
    required this.productId,
    required this.productTitle,
    required this.productImage,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] ?? '',
      productTitle: json['productTitle'] ?? '',
      productImage: json['productImage'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productTitle': productTitle,
      'productImage': productImage,
      'quantity': quantity,
      'price': price,
    };
  }
}
