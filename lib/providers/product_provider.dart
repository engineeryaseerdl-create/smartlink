import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = false;
  String _searchQuery = '';
  ProductCategory? _selectedCategory;
  final Set<String> _favoriteIds = {};
  String _sortBy = 'name';
  String? _sortByFilter;
  bool _freeDeliveryOnly = false;
  String? _error;

  List<ProductModel> get products => _filteredProducts;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  ProductCategory? get selectedCategory => _selectedCategory;
  String? get sortBy => _sortByFilter;
  bool get freeDeliveryOnly => _freeDeliveryOnly;
  String? get error => _error;

  Future<void> loadProducts({String? category, String? search}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final queryParams = <String, dynamic>{};
      if (category != null) queryParams['category'] = category;
      if (search != null) queryParams['q'] = search;
      
      debugPrint('Loading products from API...');
      final response = await _apiService.get('/products', queryParams: queryParams);
      debugPrint('API Response: $response');
      
      if (response['success'] == true) {
        final productsList = response['products'] as List?;
        if (productsList != null) {
          _products = productsList
              .map((json) => ProductModel.fromJson(json))
              .toList();
          _filteredProducts = _products;
          debugPrint('Loaded ${_products.length} products');
        }
      } else {
        debugPrint('API returned success=false');
      }
    } catch (e, stackTrace) {
      _error = e.toString();
      debugPrint('Error loading products: $e');
      debugPrint('Stack trace: $stackTrace');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Alias for enhanced buyer screen
  Future<void> fetchProducts() => loadProducts();

  void searchProducts(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void filterByCategory(ProductCategory? category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredProducts = _products.where((product) {
      final matchesSearch = _searchQuery.isEmpty ||
          product.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final matchesCategory =
          _selectedCategory == null || product.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    notifyListeners();
  }

  Future<void> addProduct(ProductModel product, {String? customCategory}) async {
    try {
      final response = await _apiService.post('/products', data: product.toJson(customCategory: customCategory));
      
      if (response['success']) {
        final newProduct = ProductModel.fromJson(response['product']);
        _products.add(newProduct);
        _applyFilters();
      }
    } catch (e) {
      debugPrint('Error adding product: $e');
      rethrow;
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      final response = await _apiService.put('/products/${product.id}', data: product.toJson());
      
      if (response['success']) {
        final updatedProduct = ProductModel.fromJson(response['product']);
        final index = _products.indexWhere((p) => p.id == product.id);
        if (index != -1) {
          _products[index] = updatedProduct;
          _applyFilters();
        }
      }
    } catch (e) {
      debugPrint('Error updating product: $e');
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _apiService.delete('/products/$productId');
      _products.removeWhere((p) => p.id == productId);
      _applyFilters();
    } catch (e) {
      debugPrint('Error deleting product: $e');
      rethrow;
    }
  }

  ProductModel? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Missing methods needed by enhanced buyer screen
  Future<void> toggleFavorite(String productId) async {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    notifyListeners();
  }

  Future<void> addToCart(String productId, int quantity) async {
    // Implementation would depend on cart provider
    // For now, just simulate the action
    await Future.delayed(const Duration(milliseconds: 200));
  }

  void sortProducts(String sortBy) {
    _sortBy = sortBy;
    switch (sortBy) {
      case 'name':
        _filteredProducts.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'price_low':
        _filteredProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        _filteredProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        _filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    notifyListeners();
  }

  bool isFavorite(String productId) => _favoriteIds.contains(productId);

  void setSortBy(String? sortBy) {
    _sortByFilter = sortBy;
    if (sortBy != null) {
      switch (sortBy) {
        case 'price_asc':
          _filteredProducts.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'price_desc':
          _filteredProducts.sort((a, b) => b.price.compareTo(a.price));
          break;
        case 'rating':
          _filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case 'newest':
          _filteredProducts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
      }
    } else {
      _applyFilters();
    }
    notifyListeners();
  }

  void setFreeDeliveryFilter(bool freeOnly) {
    _freeDeliveryOnly = freeOnly;
    _applyFilters();
    notifyListeners();
  }

  List<ProductModel> getSimilarProducts(ProductModel product, {int limit = 4}) {
    return _products
        .where((p) => 
            p.id != product.id && 
            p.category == product.category)
        .take(limit)
        .toList();
  }
}
