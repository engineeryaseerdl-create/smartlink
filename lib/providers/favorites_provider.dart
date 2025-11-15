import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class FavoritesProvider with ChangeNotifier {
  final List<ProductModel> _favorites = [];

  List<ProductModel> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(String productId) {
    return _favorites.any((product) => product.id == productId);
  }

  void toggleFavorite(ProductModel product) {
    final index = _favorites.indexWhere((p) => p.id == product.id);
    
    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(product);
    }
    
    notifyListeners();
  }

  void addToFavorites(ProductModel product) {
    if (!isFavorite(product.id)) {
      _favorites.add(product);
      notifyListeners();
    }
  }

  void removeFromFavorites(String productId) {
    _favorites.removeWhere((product) => product.id == productId);
    notifyListeners();
  }

  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }

  int get favoritesCount => _favorites.length;
}