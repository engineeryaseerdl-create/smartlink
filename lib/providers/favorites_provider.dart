import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';

class FavoritesProvider with ChangeNotifier {
  final List<ProductModel> _favorites = [];
  final _supabase = Supabase.instance.client;

  List<ProductModel> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(String productId) {
    return _favorites.any((product) => product.id == productId);
  }

  Future<void> loadFavorites() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        _favorites.clear();
        notifyListeners();
        return;
      }

      final response = await _supabase
          .from('favorites')
          .select('product_data')
          .eq('user_id', userId);

      _favorites.clear();
      for (var item in response) {
        _favorites.add(ProductModel.fromJson(item['product_data']));
      }
      debugPrint('Loaded ${_favorites.length} favorites for user $userId');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  Future<void> toggleFavorite(ProductModel product) async {
    final index = _favorites.indexWhere((p) => p.id == product.id);
    
    if (index >= 0) {
      _favorites.removeAt(index);
      await _removeFromDatabase(product.id);
    } else {
      _favorites.add(product);
      await _addToDatabase(product);
    }
    
    notifyListeners();
  }

  Future<void> _addToDatabase(ProductModel product) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      await _supabase.from('favorites').insert({
        'user_id': userId,
        'product_id': product.id,
        'product_data': product.toJson(),
      });
    } catch (e) {
      debugPrint('Error adding favorite: $e');
    }
  }

  Future<void> _removeFromDatabase(String productId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      await _supabase
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .eq('product_id', productId);
    } catch (e) {
      debugPrint('Error removing favorite: $e');
    }
  }

  void addToFavorites(ProductModel product) {
    if (!isFavorite(product.id)) {
      toggleFavorite(product);
    }
  }

  void removeFromFavorites(String productId) {
    final product = _favorites.firstWhere((p) => p.id == productId);
    toggleFavorite(product);
  }

  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }

  int get favoritesCount => _favorites.length;
}