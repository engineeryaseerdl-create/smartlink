import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product_model.dart';

class MockDataService {
  static Future<List<ProductModel>> loadProducts() async {
    try {
      final String response = await rootBundle.loadString('assets/mock_data/products.json');
      final List<dynamic> data = json.decode(response);
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      print('Error loading mock products: $e');
      return [];
    }
  }
}