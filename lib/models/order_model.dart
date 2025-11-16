enum OrderStatus { pending, confirmed, pickupReady, inTransit, delivered, cancelled }

class OrderTracking {
  final String id;
  final String orderId;
  final OrderStatus status;
  final String description;
  final String? location;
  final DateTime timestamp;
  final String? riderNote;

  OrderTracking({
    required this.id,
    required this.orderId,
    required this.status,
    required this.description,
    this.location,
    required this.timestamp,
    this.riderNote,
  });

  factory OrderTracking.fromJson(Map<String, dynamic> json) {
    return OrderTracking(
      id: json['id'] ?? '',
      orderId: json['orderId'] ?? '',
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${json['status']}',
        orElse: () => OrderStatus.pending,
      ),
      description: json['description'] ?? '',
      location: json['location'],
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      riderNote: json['riderNote'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'status': status.toString().split('.').last,
      'description': description,
      'location': location,
      'timestamp': timestamp.toIso8601String(),
      'riderNote': riderNote,
    };
  }
}

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
  final DateTime? updatedAt;
  final String deliveryType;
  final List<OrderTracking> trackingHistory;
  final String? trackingCode;

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
    this.updatedAt,
    this.deliveryType = 'okada',
    this.trackingHistory = const [],
    this.trackingCode,
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
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      deliveryType: json['deliveryType'] ?? 'okada',
      trackingHistory: (json['trackingHistory'] as List? ?? [])
          .map((tracking) => OrderTracking.fromJson(tracking))
          .toList(),
      trackingCode: json['trackingCode'],
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
      'updatedAt': updatedAt?.toIso8601String(),
      'deliveryType': deliveryType,
      'trackingHistory': trackingHistory.map((tracking) => tracking.toJson()).toList(),
      'trackingCode': trackingCode,
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
