import 'dart:convert';
// import 'package:ansvel/controllers/auth_controller.dart';
import 'package:ansvel/homeandregistratiodesign/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

const Uuid uuid = Uuid();

class WalletApiService {
  // IMPORTANT: Replace with your deployed Central Orchestrator URL
  final String _baseUrl = 'https://api.ansvel.com/api';

  // Helper method to get the current user's Firebase ID token
  Future<String> _getAuthToken() async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) {
      throw Exception('User not authenticated. Please log in again.');
    }
    return token;
  }

  // Creates the first wallet during the initial user onboarding
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
    final response = await http.post(
      Uri.parse('$_baseUrl/wallet/create'),
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
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create wallet: ${response.body}');
    }
  }

  // Creates an additional wallet for an existing user
  Future<Map<String, dynamic>> createAdditionalWallet({
    required AuthController authController,
    required String bankName,
    required String country,
    required String encryptedPin,
  }) async {
    final token = await _getAuthToken();
    final user = authController.currentUser;
    if (user == null) throw Exception('User data not found.');

    final response = await http.post(
      Uri.parse('$_baseUrl/wallet/create'),
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
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create wallet: ${response.body}');
    }
  }

  // Debits a customer's Providus wallet. This is Step 1 of the bill payment process.
  Future<Map<String, dynamic>> debitWallet({
    required double amount,
    required String reference,
    required String customerId, // Providus Customer ID from user's wallet data
  }) async {
    final token = await _getAuthToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/wallet/debit'),
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
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Wallet debit failed: ${jsonDecode(response.body)['message'] ?? response.body}',
      );
    }
  }

  // Reverses a failed bill payment by crediting the user's wallet.
  Future<Map<String, dynamic>> reverseFailedBillPayment({
    required double amount,
    required String
    customerId, // The Providus Customer ID of the user to be refunded
    required String originalReference,
  }) async {
    final token = await _getAuthToken();

    // Generate a new, unique reference for the reversal transaction itself.
    final reversalReference =
        'reversal-${originalReference}-${uuid.v4().substring(0, 8)}';

    final response = await http.post(
      Uri.parse(
        '$_baseUrl/wallet/credit',
      ), // Calling the existing credit endpoint
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
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to process reversal: ${response.body}');
    }
  }

  // --- THIS METHOD WAS MISSING ---
  /// Verifies an external bank account number and returns the account name.
  Future<Map<String, dynamic>> verifyBankAccount({
    required String accountNumber,
    required String sortCode,
  }) async {
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/transfer/account/details').replace(
      queryParameters: {
        'provider': 'providus', // Or determined by source wallet
        'accountNumber': accountNumber,
        'sortCode': sortCode,
      },
    );

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Account could not be verified.');
      }
    } else {
      throw Exception('Account verification failed: ${response.body}');
    }
  }

  // Transfers funds from the user's wallet to an external bank account
  Future<Map<String, dynamic>> transferToBank({
    required String accountNumber,
    required String accountName,
    required String sortCode,
    required double amount,
    required String narration,
    required String encryptedPin,
  }) async {
    final token = await _getAuthToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/wallet/transfer/bank'),
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
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to complete transfer: ${response.body}');
    }
  }

  // Transfers funds to another Ansvel user's wallet
  Future<Map<String, dynamic>> transferToWallet({
    required String recipientUsername,
    required double amount,
    required String narration,
    required String encryptedPin,
  }) async {
    final token = await _getAuthToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/wallet/transfer/internal'),
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
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to complete transfer: ${response.body}');
    }
  }

  // Fetches the user's wallet balance for a specific wallet
  Future<Map<String, dynamic>> getWalletBalance({
    required String accountNumber,
    required String provider,
  }) async {
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/wallet/balance').replace(
      queryParameters: {'provider': provider, 'accountNumber': accountNumber},
    );

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get balance: ${response.body}');
    }
  }

  // Fetches the user's transaction history
  Future<List<dynamic>> getTransactionHistory() async {
    final token = await _getAuthToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/wallet/transactions?provider=providus'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final decodedBody = jsonDecode(response.body);
      return decodedBody['transactions'] as List<dynamic>;
    } else {
      throw Exception('Failed to fetch transaction history: ${response.body}');
    }
  }

  // Fetches the list of banks for a specific country
  Future<List<dynamic>> getBankList(String countryCode) async {
    final token = await _getAuthToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/banks/$countryCode'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to fetch bank list: ${response.body}');
    }
  }

  // Processes a payment gateway checkout request
  Future<Map<String, dynamic>> processCheckout({
    required String fromWalletId,
    required String toCustomerId,
    required double amount,
    required String encryptedPin,
  }) async {
    final token = await _getAuthToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/wallet/checkout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'provider': 'providus', // Or determined by fromWalletId
        'fromWalletId': fromWalletId,
        'toCustomerId': toCustomerId,
        'amount': amount,
        'encryptedTransactionPin': encryptedPin,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Checkout failed: ${response.body}');
    }
  }
}
