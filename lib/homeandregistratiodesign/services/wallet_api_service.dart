import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:ansvel/homeandregistratiodesign/controllers/auth_controller.dart';

const Uuid uuid = Uuid();

/// Unified Wallet & Payments API Service for Ansvel
class WalletApiService {
  // Base URL (switches between local dev and prod automatically)
  static const String _baseUrl = kDebugMode
      ? 'http://localhost:3000'
      : 'https://api.ansvel.com';

  /// Get Firebase Auth Token
  Future<String> _getAuthToken() async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken(true);
    if (token == null) {
      throw Exception('User not authenticated. Please log in again.');
    }
    return token;
  }

  /// Handle API responses consistently
  dynamic _handleResponse(http.Response response) {
    final responseBody = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseBody;
    } else {
      final errorMessage =
          responseBody['message'] ?? 'An unknown error occurred.';
      throw Exception('API Error: $errorMessage');
    }
  }

  // ------------------- WALLET CREATION -------------------

  Future<Map<String, dynamic>> createWallet({
    required String provider,
    required String bvn,
    required String dob,
    required String country,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String address,
    String? encryptedPin,
  }) async {
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/gateway/wallet/create');

    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'provider': provider,
              'bvn': bvn,
              'firstName': firstName,
              'lastName': lastName,
              'dateOfBirth': dob,
              'phoneNumber': phoneNumber,
              'address': address,
              'country': country,
              if (encryptedPin != null) 'encryptedTransactionPin': encryptedPin,
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

  // ------------------- WALLET TRANSACTIONS -------------------

  Future<Map<String, dynamic>> debitWallet({
    required double amount,
    required String reference,
    required String customerId,
    required String provider,
  }) async {
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/gateway/wallet/debit');

    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'provider': provider,
              'amount': amount,
              'reference': reference,
              'customerId': customerId,
            }),
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      throw Exception('Network Error: Please check your internet connection.');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> reverseFailedBillPayment({
    required double amount,
    required String customerId,
    required String originalReference,
    required String provider,
  }) async {
    final token = await _getAuthToken();
    final reversalReference =
        'reversal-${originalReference}-${uuid.v4().substring(0, 8)}';

    final uri = Uri.parse('$_baseUrl/gateway/wallet/credit');

    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'provider': provider,
              'amount': amount,
              'reference': reversalReference,
              'customerId': customerId,
            }),
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      throw Exception('Network Error: Please check your internet connection.');
    } catch (e) {
      rethrow;
    }
  }

  // ------------------- TRANSFERS -------------------

  Future<Map<String, dynamic>> verifyBankAccount({
    required String accountNumber,
    required String sortCode,
    required String provider,
  }) async {
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/gateway/transfer/account/details').replace(
      queryParameters: {
        'provider': provider,
        'accountNumber': accountNumber,
        'sortCode': sortCode,
      },
    );

    try {
      final response = await http
          .get(uri, headers: {'Authorization': 'Bearer $token'})
          .timeout(const Duration(seconds: 20));
      return _handleResponse(response);
    } on SocketException {
      throw Exception('Network Error: Please check your internet connection.');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> transferToBank({
    required String accountNumber,
    required String accountName,
    required String sortCode,
    required double amount,
    required String narration,
    required String encryptedPin,
    required String provider,
  }) async {
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/gateway/transfer/bank');

    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'provider': provider,
              'accountNumber': accountNumber,
              'accountName': accountName,
              'sortCode': sortCode,
              'amount': amount,
              'narration': narration,
              'encryptedTransactionPin': encryptedPin,
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

  Future<Map<String, dynamic>> transferToWallet({
    required String recipientUsername,
    required double amount,
    required String narration,
    required String encryptedPin,
    required String provider,
  }) async {
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/gateway/transfer/internal');

    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'provider': provider,
              'recipientUsername': recipientUsername,
              'amount': amount,
              'narration': narration,
              'encryptedTransactionPin': encryptedPin,
            }),
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      throw Exception('Network Error: Please check your internet connection.');
    } catch (e) {
      rethrow;
    }
  }

  // ------------------- BALANCE & STATEMENTS -------------------

  Future<Map<String, dynamic>> getWalletBalance({
    required String customerId,
    required String provider,
  }) async {
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/gateway/wallet/balance').replace(
      queryParameters: {'provider': provider, 'customerId': customerId},
    );

    try {
      final response = await http
          .get(uri, headers: {'Authorization': 'Bearer $token'})
          .timeout(const Duration(seconds: 20));

      return _handleResponse(response);
    } on SocketException {
      throw Exception('Network Error: Please check your internet connection.');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getTransactionHistory() async {
    final token = await _getAuthToken();
    final uri = Uri.parse(
      '$_baseUrl/gateway/wallet/transactions?provider=providus',
    );

    try {
      final response = await http
          .get(uri, headers: {'Authorization': 'Bearer $token'})
          .timeout(const Duration(seconds: 30));

      final data = _handleResponse(response);
      return data['transactions'] as List<dynamic>;
    } on SocketException {
      throw Exception('Network Error: Please check your internet connection.');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getAccountStatement({
    required String customerId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/gateway/wallet/statement').replace(
      queryParameters: {
        'customerId': customerId,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      },
    );

    try {
      final response = await http
          .get(uri, headers: {'Authorization': 'Bearer $token'})
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response) as List<dynamic>;
    } on SocketException {
      throw Exception('Network Error: Please check your internet connection.');
    } catch (e) {
      rethrow;
    }
  }

  // ------------------- BANKS -------------------

  Future<List<dynamic>> getBankList(String countryCode) async {
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/gateway/banks/$countryCode');

    try {
      final response = await http
          .get(uri, headers: {'Authorization': 'Bearer $token'})
          .timeout(const Duration(seconds: 20));

      return _handleResponse(response) as List<dynamic>;
    } on SocketException {
      throw Exception('Network Error: Please check your internet connection.');
    } catch (e) {
      rethrow;
    }
  }

  // ------------------- CHECKOUT -------------------

  Future<Map<String, dynamic>> processCheckout({
    required String fromWalletId,
    required String toCustomerId,
    required double amount,
    required String encryptedPin,
  }) async {
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/gateway/wallet/checkout');

    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'provider': 'providus',
              'fromWalletId': fromWalletId,
              'toCustomerId': toCustomerId,
              'amount': amount,
              'encryptedTransactionPin': encryptedPin,
            }),
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      throw Exception('Network Error: Please check your internet connection.');
    } catch (e) {
      rethrow;
    }
  }
}
