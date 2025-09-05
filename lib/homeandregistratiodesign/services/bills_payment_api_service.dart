import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

const Uuid uuid = Uuid();

/// A service class for handling all bill payments via the Central Orchestrator.
class BillsPaymentApiService {
  // Base URL (switches between local dev and prod automatically)
  static const String _baseUrl = kDebugMode
      ? 'http://localhost:3000'
      : 'https://api.ansvel.com';

  /// Retrieves the Firebase Authentication ID token for the current user.
  /// This token is sent with every request to authenticate the user on the backend.
  Future<String> _getAuthToken() async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken(true);
    if (token == null) {
      throw Exception('User not authenticated. Please log in again.');
    }
    return token;
  }

  /// Handles API responses consistently, parsing JSON and throwing
  /// a formatted exception on failure.
  dynamic _handleResponse(http.Response response) {
    final responseBody = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseBody;
    } else {
      final errorMessage = responseBody['message'] ?? 'An unknown error occurred.';
      throw Exception('API Error: $errorMessage');
    }
  }

  // ------------------- CORALPAY ENDPOINTS -------------------

  /// Fetches the list of all available biller categories from the orchestrator.
  /// This corresponds to the `GET /bills/categories` endpoint in the adapter.
  Future<List<dynamic>> getBillerCategories() async {
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/gateway/bills/categories');

    try {
      final response = await http
          .get(uri, headers: {'Authorization': 'Bearer $token'})
          .timeout(const Duration(seconds: 20));
      return _handleResponse(response)['responseData'] as List<dynamic>;
    } on SocketException {
      throw Exception('Network Error: Please check your internet connection.');
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches a list of all billers within a specific category.
  /// This corresponds to the `GET /bills/billers/:categorySlug` endpoint.
  Future<List<dynamic>> getBillersByCategory(String categorySlug) async {
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/gateway/bills/billers/$categorySlug');

    try {
      final response = await http
          .get(uri, headers: {'Authorization': 'Bearer $token'})
          .timeout(const Duration(seconds: 20));
      return _handleResponse(response)['responseData'] as List<dynamic>;
    } on SocketException {
      throw Exception('Network Error: Please check your internet connection.');
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches a list of available packages for a specific biller.
  /// This corresponds to the `GET /bills/packages/:billerSlug` endpoint.
  Future<List<dynamic>> getPackagesByBiller(String billerSlug) async {
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/gateway/bills/packages/$billerSlug');

    try {
      final response = await http
          .get(uri, headers: {'Authorization': 'Bearer $token'})
          .timeout(const Duration(seconds: 20));
      return _handleResponse(response)['responseData'] as List<dynamic>;
    } on SocketException {
      throw Exception('Network Error: Please check your internet connection.');
    } catch (e) {
      rethrow;
    }
  }

  /// Looks up a customer's account on a specific biller.
  /// This corresponds to the `POST /bills/customer-lookup` endpoint.
  Future<Map<String, dynamic>> customerLookup({
    required String customerId,
    required String billerSlug,
    String? productName,
  }) async {
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/gateway/bills/customer-lookup');

    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'customerId': customerId,
              'billerSlug': billerSlug,
              if (productName != null) 'productName': productName,
            }),
          )
          .timeout(const Duration(seconds: 30));
      return _handleResponse(response)['responseData'] as Map<String, dynamic>;
    } on SocketException {
      throw Exception('Network Error: Please check your internet connection.');
    } catch (e) {
      rethrow;
    }
  }

  /// Vends value to a customer's account after a successful payment.
  /// This corresponds to the `POST /bills/vend` endpoint.
  Future<Map<String, dynamic>> vendBillPayment({
    required String paymentReference,
    required String customerId,
    required String packageSlug,
    required double amount,
    required String phoneNumber,
    String? customerName,
    String? email,
  }) async {
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/gateway/bills/vend');

    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'paymentReference': paymentReference,
              'customerId': customerId,
              'packageSlug': packageSlug,
              'amount': amount,
              'phoneNumber': phoneNumber,
              'channel': 'MOBILE',
              if (customerName != null) 'customerName': customerName,
              if (email != null) 'email': email,
            }),
          )
          .timeout(const Duration(seconds: 45));
      return _handleResponse(response);
    } on SocketException {
      throw Exception('Network Error: Please check your internet connection.');
    } catch (e) {
      rethrow;
    }
  }
}