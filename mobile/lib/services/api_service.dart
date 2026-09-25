import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const apiUrl = String.fromEnvironment(
    'SA3R_API_URL',
    defaultValue: 'https://bpphsjvbvfalsclyuecm.supabase.co/functions/v1/sa3r-api',
  );

  Future<bool> health() async {
    final response = await http.get(Uri.parse('$apiUrl/health'));
    return response.statusCode == 200;
  }

  Future<List<Product>> searchProducts(String query) async {
    final uri = Uri.parse('$apiUrl/products').replace(
      queryParameters: query.trim().isEmpty ? null : {'q': query.trim()},
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) throw Exception('تعذر الاتصال بالخادم');
    final data = jsonDecode(response.body) as List;
    return data.map((e) => Product.fromJson(e)).toList();
  }

  Future<Product> getProduct(String id) async {
    final response = await http.get(Uri.parse('$apiUrl/products/$id'));
    if (response.statusCode != 200) throw Exception('المنتج غير موجود');
    return Product.fromJson(jsonDecode(response.body));
  }
}
