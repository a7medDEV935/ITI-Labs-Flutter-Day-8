import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com';

  // Fetch all products
  static Future<List<ProductModel>> fetchProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/products'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
