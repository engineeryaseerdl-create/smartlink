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
    // Handle buyer data
    String buyerId = '';
    String buyerName = '';
    String buyerPhone = '';
    String buyerLocation = '';
    
    if (json['buyer'] != null) {
      if (json['buyer'] is String) {
        buyerId = json['buyer'];
      } else if (json['buyer'] is Map) {
        buyerId = json['buyer']['_id'] ?? json['buyer']['id'] ?? '';
        buyerName = json['buyer']['name'] ?? '';
        buyerPhone = json['buyer']['phone'] ?? '';
        if (json['buyer']['location'] != null) {
          if (json['buyer']['location'] is String) {
            buyerLocation = json['buyer']['location'];
          } else if (json['buyer']['location'] is Map) {
            buyerLocation = json['buyer']['location']['address'] ?? '';
          }
        }
      }
    }

    // Handle seller data
    String sellerId = '';
    String sellerName = '';
    String sellerLocation = '';
    
    if (json['seller'] != null) {
      if (json['seller'] is String) {
        sellerId = json['seller'];
      } else if (json['seller'] is Map) {
        sellerId = json['seller']['_id'] ?? json['seller']['id'] ?? '';
        sellerName = json['seller']['businessName'] ?? json['seller']['name'] ?? '';
        if (json['seller']['location'] != null) {
          if (json['seller']['location'] is String) {
            sellerLocation = json['seller']['location'];
          } else if (json['seller']['location'] is Map) {
            sellerLocation = json['seller']['location']['address'] ?? '';
          }
        }
      }
    }

    // Handle rider data
    String? riderId;
    String? riderName;
    
    if (json['rider'] != null) {
      if (json['rider'] is String) {
        riderId = json['rider'];
      } else if (json['rider'] is Map) {
        riderId = json['rider']['_id'] ?? json['rider']['id'];
        riderName = json['rider']['name'];
      }
    }

    // Handle delivery address
    String deliveryLoc = '';
    if (json['deliveryAddress'] != null) {
      if (json['deliveryAddress'] is String) {
        deliveryLoc = json['deliveryAddress'];
      } else if (json['deliveryAddress'] is Map) {
        final addr = json['deliveryAddress'];
        deliveryLoc = '${addr['street'] ?? ''}, ${addr['city'] ?? ''}, ${addr['state'] ?? ''}'.trim();
      }
    }

    // Map backend status to frontend enum
    String statusStr = json['status'] ?? 'pending';
    OrderStatus orderStatus;
    switch (statusStr) {
      case 'confirmed':
      case 'preparing':
        orderStatus = OrderStatus.confirmed;
        break;
      case 'ready':
      case 'assigned':
        orderStatus = OrderStatus.pickupReady;
        break;
      case 'picked_up':
      case 'in_transit':
        orderStatus = OrderStatus.inTransit;
        break;
      case 'delivered':
        orderStatus = OrderStatus.delivered;
        break;
      case 'cancelled':
        orderStatus = OrderStatus.cancelled;
        break;
      default:
        orderStatus = OrderStatus.pending;
    }

    return OrderModel(
      id: json['_id'] ?? json['id'] ?? '',
      buyerId: buyerId.isNotEmpty ? buyerId : (json['buyerId'] ?? ''),
      buyerName: buyerName.isNotEmpty ? buyerName : (json['buyerName'] ?? ''),
      buyerPhone: buyerPhone.isNotEmpty ? buyerPhone : (json['buyerPhone'] ?? ''),
      buyerLocation: deliveryLoc.isNotEmpty ? deliveryLoc : (buyerLocation.isNotEmpty ? buyerLocation : (json['buyerLocation'] ?? '')),
      sellerId: sellerId.isNotEmpty ? sellerId : (json['sellerId'] ?? ''),
      sellerName: sellerName.isNotEmpty ? sellerName : (json['sellerName'] ?? ''),
      sellerLocation: sellerLocation.isNotEmpty ? sellerLocation : (json['sellerLocation'] ?? ''),
      items: (json['items'] as List? ?? [])
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: orderStatus,
      riderId: riderId ?? json['riderId'],
      riderName: riderName ?? json['riderName'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      deliveredAt: json['actualDeliveryTime'] != null
          ? DateTime.parse(json['actualDeliveryTime'])
          : (json['deliveredAt'] != null ? DateTime.parse(json['deliveredAt']) : null),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      deliveryType: json['deliveryType'] ?? 'okada',
      trackingHistory: (json['trackingHistory'] as List? ?? [])
          .map((tracking) => OrderTracking.fromJson(tracking))
          .toList(),
      trackingCode: json['orderNumber'] ?? json['trackingCode'],
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
    // Handle product data (can be ID string or populated object)
    String productId = '';
    String productTitle = '';
    String productImage = '';
    
    if (json['product'] != null) {
      if (json['product'] is String) {
        productId = json['product'];
      } else if (json['product'] is Map) {
        productId = json['product']['_id'] ?? json['product']['id'] ?? '';
        productTitle = json['product']['name'] ?? json['product']['title'] ?? '';
        if (json['product']['images'] is List && (json['product']['images'] as List).isNotEmpty) {
          productImage = json['product']['images'][0];
        }
      }
    }

    return OrderItem(
      productId: productId.isNotEmpty ? productId : (json['productId'] ?? ''),
      productTitle: productTitle.isNotEmpty ? productTitle : (json['productTitle'] ?? ''),
      productImage: productImage.isNotEmpty ? productImage : (json['productImage'] ?? ''),
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
