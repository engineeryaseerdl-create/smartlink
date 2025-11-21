import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';

class OrderProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _error;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> loadOrders({String? status, String? role}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;
      if (role != null) queryParams['role'] = role;
      
      final response = await _apiService.get('/orders', queryParams: queryParams);
      
      if (response['success']) {
        _orders = (response['orders'] as List)
            .map((json) => OrderModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<OrderModel> getOrdersForBuyer(String buyerId) {
    return _orders.where((order) => order.buyerId == buyerId).toList();
  }

  List<OrderModel> getOrdersForSeller(String sellerId) {
    // If orders were loaded with role='seller', they're already filtered
    // Just return all orders since backend already filtered by seller
    return _orders;
  }

  List<OrderModel> getOrdersForRider(String riderId) {
    return _orders.where((order) => order.riderId == riderId).toList();
  }

  Future<OrderModel?> createOrder({
    required List<Map<String, dynamic>> items,
    required Map<String, dynamic> deliveryAddress,
    String paymentMethod = 'cash_on_delivery',
    String? notes,
  }) async {
    try {
      final response = await _apiService.post('/orders', data: {
        'items': items,
        'deliveryAddress': deliveryAddress,
        'paymentMethod': paymentMethod,
        if (notes != null) 'notes': notes,
      });
      
      if (response['success']) {
        final order = OrderModel.fromJson(response['order']);
        _orders.insert(0, order);
        notifyListeners();
        return order;
      }
    } catch (e) {
      debugPrint('Error creating order: $e');
      rethrow;
    }
    return null;
  }

  Future<void> updateOrderStatus(String orderId, String status, {Map<String, double>? location, String? note, BuildContext? context}) async {
    try {
      final response = await _apiService.put('/orders/$orderId/status', data: {
        'status': status,
        if (location != null) 'location': location,
        if (note != null) 'note': note,
      });
      
      if (response['success']) {
        final updatedOrder = OrderModel.fromJson(response['order']);
        final index = _orders.indexWhere((o) => o.id == orderId);
        if (index != -1) {
          final oldOrder = _orders[index];
          _orders[index] = updatedOrder;
          notifyListeners();
          
          // Show notification if context is provided
          if (context != null && context.mounted) {
            NotificationService.showOrderStatusUpdate(
              context,
              updatedOrder,
              updatedOrder.status,
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error updating order status: $e');
      rethrow;
    }
  }

  Future<void> assignRider(String orderId, String riderId, {BuildContext? context}) async {
    try {
      final response = await _apiService.put('/orders/$orderId/assign-rider', data: {
        'riderId': riderId,
      });
      
      if (response['success']) {
        final updatedOrder = OrderModel.fromJson(response['order']);
        final index = _orders.indexWhere((o) => o.id == orderId);
        if (index != -1) {
          _orders[index] = updatedOrder;
          notifyListeners();
          
          // Show notification if context is provided
          if (context != null && context.mounted) {
            NotificationService.showOrderStatusUpdate(
              context,
              updatedOrder,
              OrderStatus.assigned,
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error assigning rider: $e');
      rethrow;
    }
  }

  OrderModel? getOrderById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<OrderModel> createDirectOrder({
    required ProductModel product,
    required int quantity,
    required String buyerId,
    required String buyerName,
    required String buyerPhone,
    required String buyerLocation,
    required String paymentMethod,
  }) async {
    try {
      final order = await createOrder(
        items: [{
          'product': product.id,
          'quantity': quantity,
        }],
        deliveryAddress: {
          'street': buyerLocation,
          'city': 'Lagos',
          'state': 'Lagos',
        },
        paymentMethod: paymentMethod,
      );
      return order!;
    } catch (e) {
      // Fallback to local order creation
      final order = OrderModel(
        id: 'order_${DateTime.now().millisecondsSinceEpoch}',
        buyerId: buyerId,
        buyerName: buyerName,
        buyerPhone: buyerPhone,
        buyerLocation: buyerLocation,
        sellerId: product.sellerId,
        sellerName: product.sellerName,
        sellerLocation: product.sellerLocation,
        items: [
          OrderItem(
            productId: product.id,
            productTitle: product.title,
            productImage: product.images.first,
            quantity: quantity,
            price: product.price,
          ),
        ],
        totalAmount: product.price * quantity,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
      );
      _orders.insert(0, order);
      notifyListeners();
      return order;
    }
  }
}
