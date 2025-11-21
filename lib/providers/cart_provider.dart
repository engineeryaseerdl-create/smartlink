import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/cart_model.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  String? _currentUserId;

  List<CartItem> get items => _items;
  double get totalAmount => _items.fold(0, (sum, item) => sum + item.totalPrice);
  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  Future<void> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('current_user');
      if (userJson != null) {
        final user = json.decode(userJson);
        _currentUserId = user['id'];
        final cartData = prefs.getString('cart_$_currentUserId');
        if (cartData != null) {
          final List<dynamic> decoded = json.decode(cartData);
          _items.clear();
          _items.addAll(decoded.map((item) => CartItem.fromJson(item)).toList());
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
  }

  Future<void> _saveCart() async {
    if (_currentUserId == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = json.encode(_items.map((item) => item.toJson()).toList());
      await prefs.setString('cart_$_currentUserId', cartData);
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }

  void addToCart(ProductModel product, {int quantity = 1}) {
    final existingIndex = _items.indexWhere((item) => item.productId == product.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(
        productId: product.id,
        productTitle: product.title,
        productImage: product.images.isNotEmpty ? product.images.first : '',
        price: product.price,
        quantity: quantity,
      ));
    }
    _saveCart();
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    _saveCart();
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      _saveCart();
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _saveCart();
    notifyListeners();
  }

  bool isInCart(String productId) {
    return _items.any((item) => item.productId == productId);
  }

  int getQuantity(String productId) {
    final item = _items.firstWhere(
      (item) => item.productId == productId,
      orElse: () => CartItem(productId: '', productTitle: '', productImage: '', price: 0),
    );
    return item.productId.isNotEmpty ? item.quantity : 0;
  }
}
