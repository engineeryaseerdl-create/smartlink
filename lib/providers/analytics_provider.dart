import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class AnalyticsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  Map<String, dynamic>? _sellerAnalytics;
  Map<String, dynamic>? _riderAnalytics;
  bool _isLoading = false;

  Map<String, dynamic>? get sellerAnalytics => _sellerAnalytics;
  Map<String, dynamic>? get riderAnalytics => _riderAnalytics;
  bool get isLoading => _isLoading;

  Future<void> loadSellerAnalytics(String period) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.get('/analytics/seller', queryParams: {
        'period': period,
      });

      if (response['success']) {
        _sellerAnalytics = response['analytics'];
      }
    } catch (e) {
      debugPrint('Error loading seller analytics: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadRiderAnalytics(String period) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.get('/analytics/rider', queryParams: {
        'period': period,
      });

      if (response['success']) {
        _riderAnalytics = response['analytics'];
      }
    } catch (e) {
      debugPrint('Error loading rider analytics: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}