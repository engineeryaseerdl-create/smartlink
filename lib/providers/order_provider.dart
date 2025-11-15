import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../services/mock_data_service.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel> _orders = [];
  bool _isLoading = false;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));
    _orders = await MockDataService.loadOrders();

    _isLoading = false;
    notifyListeners();
  }

  List<OrderModel> getOrdersForBuyer(String buyerId) {
    return _orders.where((order) => order.buyerId == buyerId).toList();
  }

  List<OrderModel> getOrdersForSeller(String sellerId) {
    return _orders.where((order) => order.sellerId == sellerId).toList();
  }

  List<OrderModel> getOrdersForRider(String riderId) {
    return _orders.where((order) => order.riderId == riderId).toList();
  }

  void addOrder(OrderModel order) {
    _orders.add(order);
    notifyListeners();
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final order = _orders[index];
      _orders[index] = OrderModel(
        id: order.id,
        buyerId: order.buyerId,
        buyerName: order.buyerName,
        buyerPhone: order.buyerPhone,
        buyerLocation: order.buyerLocation,
        sellerId: order.sellerId,
        sellerName: order.sellerName,
        sellerLocation: order.sellerLocation,
        items: order.items,
        totalAmount: order.totalAmount,
        status: status,
        riderId: order.riderId,
        riderName: order.riderName,
        createdAt: order.createdAt,
        deliveredAt:
            status == OrderStatus.delivered ? DateTime.now() : order.deliveredAt,
        deliveryType: order.deliveryType,
      );
      notifyListeners();
    }
  }

  Future<void> assignRider(String orderId, String riderId) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final order = _orders[index];
      _orders[index] = OrderModel(
        id: order.id,
        buyerId: order.buyerId,
        buyerName: order.buyerName,
        buyerPhone: order.buyerPhone,
        buyerLocation: order.buyerLocation,
        sellerId: order.sellerId,
        sellerName: order.sellerName,
        sellerLocation: order.sellerLocation,
        items: order.items,
        totalAmount: order.totalAmount,
        status: OrderStatus.pickupReady,
        riderId: riderId,
        riderName: 'Rider #${riderId.substring(0, 8)}',
        createdAt: order.createdAt,
        deliveredAt: order.deliveredAt,
        deliveryType: order.deliveryType,
      );
      notifyListeners();
    }
  }

  OrderModel? getOrderById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (e) {
      return null;
    }
  }
}
