import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/user_model.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';
import '../models/rider_model.dart';

class MockDataService {
  static Future<List<ProductModel>> loadProducts() async {
    final String response =
        await rootBundle.loadString('assets/mock_data/products.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }

  static Future<List<RiderModel>> loadRiders() async {
    final String response =
        await rootBundle.loadString('assets/mock_data/riders.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => RiderModel.fromJson(json)).toList();
  }

  static Future<List<UserModel>> loadUsers() async {
    final String response =
        await rootBundle.loadString('assets/mock_data/users.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  static Future<List<OrderModel>> loadOrders() async {
    final String response =
        await rootBundle.loadString('assets/mock_data/orders.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => OrderModel.fromJson(json)).toList();
  }
}
