import 'dart:convert';
// import 'package:ansvel/controllers/auth_controller.dart';
import 'package:ansvel/homeandregistratiodesign/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

const Uuid uuid = Uuid();

/// Unified Wallet & Payments API Service for Ansvel
class WalletApiService {
  // Base URL (switches between local dev and prod automatically)
  static const String _baseUrl = kDebugMode
      ? 'http://localhost:3000'
      : 'https://api.ansvel.com/api';

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

  Future<Map<String, dynamic>> createInitialWallet({
    required String bvn,
    required String dob,
    required String country,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String address,
  }) async {
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/wallet/create');

    final response = await http
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'provider': 'providus',
            'bvn': bvn,
            'firstName': firstName,
            'lastName': lastName,
            'dateOfBirth': dob,
            'phoneNumber': phoneNumber,
            'address': address,
            'country': country,
          }),
        )
        .timeout(const Duration(seconds: 45));

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> createAdditionalWallet({
    required AuthController authController,
    required String bankName,
    required String country,
    required String encryptedPin,
  }) async {
    final token = await _getAuthToken();
    final user = authController.currentUser;
    if (user == null) throw Exception('User data not found.');

    final uri = Uri.parse('$_baseUrl/wallet/create');

    final response = await http
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'provider': bankName.toLowerCase(),
            'firstName': user.firstName,
            'lastName': user.lastName,
            'dateOfBirth': user.dateOfBirth,
            'phoneNumber': user.phoneNumber,
            'email': user.email,
            'address': user.address,
            'country': country,
            'transactionPin': encryptedPin,
          }),
        )
        .timeout(const Duration(seconds: 45));

    return _handleResponse(response);
  }

  // ------------------- WALLET TRANSACTIONS -------------------

  Future<Map<String, dynamic>> debitWallet({
    required double amount,
    required String reference,
    required String customerId,
  }) async {
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/wallet/debit');

    final response = await http
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'provider': 'providus',
            'amount': amount,
            'reference': reference,
            'customerId': customerId,
          }),
        )
        .timeout(const Duration(seconds: 30));

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> reverseFailedBillPayment({
    required double amount,
    required String customerId,
    required String originalReference,
  }) async {
    final token = await _getAuthToken();
    final reversalReference =
        'reversal-${originalReference}-${uuid.v4().substring(0, 8)}';

    final uri = Uri.parse('$_baseUrl/wallet/credit');

    final response = await http
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'provider': 'providus',
            'amount': amount,
            'reference': reversalReference,
            'customerId': customerId,
          }),
        )
        .timeout(const Duration(seconds: 30));

    return _handleResponse(response);
  }

  // ------------------- TRANSFERS -------------------

  Future<Map<String, dynamic>> verifyBankAccount({
    required String accountNumber,
    required String sortCode,
  }) async {
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/transfer/account/details').replace(
      queryParameters: {
        'provider': 'providus',
        'accountNumber': accountNumber,
        'sortCode': sortCode,
      },
    );

    final response = await http
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(const Duration(seconds: 20));

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> transferToBank({
    required String accountNumber,
    required String accountName,
    required String sortCode,
    required double amount,
    required String narration,
    required String encryptedPin,
  }) async {
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/wallet/transfer/bank');

    final response = await http
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'provider': 'providus',
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
  }

  Future<Map<String, dynamic>> transferToWallet({
    required String recipientUsername,
    required double amount,
    required String narration,
    required String encryptedPin,
  }) async {
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/wallet/transfer/internal');

    final response = await http
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'provider': 'providus',
            'recipientUsername': recipientUsername,
            'amount': amount,
            'narration': narration,
            'encryptedTransactionPin': encryptedPin,
          }),
        )
        .timeout(const Duration(seconds: 30));

    return _handleResponse(response);
  }

  // ------------------- BALANCE & STATEMENTS -------------------

  Future<Map<String, dynamic>> getWalletBalance({
    required String accountNumber,
    required String provider,
  }) async {
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/wallet/balance').replace(
      queryParameters: {'provider': provider, 'accountNumber': accountNumber},
    );

    final response = await http
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(const Duration(seconds: 20));

    return _handleResponse(response);
  }

  Future<List<dynamic>> getTransactionHistory() async {
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/wallet/transactions?provider=providus');

    final response = await http
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(const Duration(seconds: 30));

    final data = _handleResponse(response);
    return data['transactions'] as List<dynamic>;
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

    final response = await http
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(const Duration(seconds: 30));

    return _handleResponse(response) as List<dynamic>;
  }

  // ------------------- BANKS -------------------

  Future<List<dynamic>> getBankList(String countryCode) async {
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/banks/$countryCode');

    final response = await http
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(const Duration(seconds: 20));

    return _handleResponse(response) as List<dynamic>;
  }

  // ------------------- CHECKOUT -------------------

  Future<Map<String, dynamic>> processCheckout({
    required String fromWalletId,
    required String toCustomerId,
    required double amount,
    required String encryptedPin,
  }) async {
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/wallet/checkout');

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
  }
}
