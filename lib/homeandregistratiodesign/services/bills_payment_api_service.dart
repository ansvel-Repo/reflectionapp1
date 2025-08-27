import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class BillsPaymentApiService {
  // IMPORTANT: Replace with your deployed Central Orchestrator URL
  final String _baseUrl = 'https://api.ansvel.com/api';

  Future<String?> _getAuthToken() async {
    return await FirebaseAuth.instance.currentUser?.getIdToken();
  }

  Future<List<dynamic>> getBillerCategories() async {
    final token = await _getAuthToken();
    if (token == null) throw Exception('User not authenticated');

    final response = await http.get(
      Uri.parse('$_baseUrl/bills/categories?provider=coralpay'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['responseData'];
    } else {
      throw Exception('Failed to fetch biller categories');
    }
  }

  Future<List<dynamic>> getBillersByCategory(String categorySlug) async {
    final token = await _getAuthToken();
    if (token == null) throw Exception('User not authenticated');

    final response = await http.get(
      Uri.parse('$_baseUrl/bills/billers/$categorySlug?provider=coralpay'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['responseData'];
    } else {
      throw Exception('Failed to fetch billers');
    }
  }

  Future<List<dynamic>> getPackagesByBiller(String billerSlug) async {
    final token = await _getAuthToken();
    if (token == null) throw Exception('User not authenticated');
    
    final response = await http.get(
      Uri.parse('$_baseUrl/bills/packages/$billerSlug?provider=coralpay'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['responseData'];
    } else {
      throw Exception('Failed to fetch packages');
    }
  }

  Future<Map<String, dynamic>> vendBillPayment({
    required String paymentReference,
    required String customerId,
    required String packageSlug,
    required double amount,
    required String phoneNumber,
  }) async {
    final token = await _getAuthToken();
    if (token == null) throw Exception('User not authenticated');
    
    final response = await http.post(
      Uri.parse('$_baseUrl/bills/vend'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode({
        'provider': 'coralpay',
        'paymentReference': paymentReference,
        'customerId': customerId,
        'packageSlug': packageSlug,
        'amount': amount,
        'phoneNumber': phoneNumber,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to complete bill payment: ${response.body}');
    }
  }
}