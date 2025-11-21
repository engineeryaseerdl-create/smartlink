import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class ComparisonProvider with ChangeNotifier {
  final List<ProductModel> _products = [];

  List<ProductModel> get products => _products;

  bool isInComparison(String productId) {
    return _products.any((p) => p.id == productId);
  }

  void addProduct(ProductModel product) {
    if (_products.length < 2 && !isInComparison(product.id)) {
      _products.add(product);
      notifyListeners();
    }
  }

  void removeProduct(String productId) {
    _products.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  void clearComparison() {
    _products.clear();
    notifyListeners();
  }
}
