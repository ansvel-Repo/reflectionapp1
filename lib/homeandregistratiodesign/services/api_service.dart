// lib/services/api_service.dart
// Single place for all backend calls. Swap baseUrl & adapterApiKey to your values.

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tokenized_card.dart';

class ApiService {
  ApiService._private();
  static final ApiService instance = ApiService._private();

  // configure these
  final String baseUrl = 'https://your-backend-domain.com'; // <- replace
  final String adapterApiKey = 'YOUR_ADAPTER_API_KEY'; // <- replace

  Map<String, String> get _defaultHeaders => {
        'Content-Type': 'application/json',
        'x-api-key': adapterApiKey,
      };

  Future<Map<String, dynamic>?> fetchFeePreview(double amountNgn) async {
    final uri = Uri.parse('$baseUrl/paystack/fee?amount=${amountNgn.toString()}');
    final res = await http.get(uri, headers: _defaultHeaders);
    if (res.statusCode == 200) {
      return json.decode(res.body) as Map<String, dynamic>;
    }
    return null;
  }

  /// Initialize transaction on server; server returns Paystack initialize response (under 'data')
  Future<Map<String, dynamic>?> initTransaction({
    required String email,
    required double amountNgn,
    required String reference,
  }) async {
    final uri = Uri.parse('$baseUrl/paystack/init');
    final body = json.encode({
      'email': email,
      'amount': amountNgn,
      'reference': reference,
      'currency': 'NGN',
    });
    final res = await http.post(uri, headers: _defaultHeaders, body: body);
    if (res.statusCode == 200) return json.decode(res.body) as Map<String, dynamic>;
    return null;
  }

  /// Verify transaction
  Future<Map<String, dynamic>?> verifyTransaction(String reference) async {
    final uri = Uri.parse('$baseUrl/paystack/verify');
    final res = await http.post(uri, headers: _defaultHeaders, body: json.encode({'reference': reference}));
    if (res.statusCode == 200) return json.decode(res.body) as Map<String, dynamic>;
    return null;
  }

  /// Get saved cards for current user (backend should use x-user-id or token to identify)
  Future<List<TokenizedCard>> getSavedCards({required String userId}) async {
    final uri = Uri.parse('$baseUrl/cards');
    final headers = Map<String, String>.from(_defaultHeaders);
    headers['x-user-id'] = userId;
    final res = await http.get(uri, headers: headers);
    if (res.statusCode == 200) {
      final list = json.decode(res.body);
      if (list is List) {
        return list.map((e) => TokenizedCard.fromJson(e)).toList();
      }
    }
    return [];
  }

  /// Save a tokenized card into backend DB
  Future<bool> saveCard({required String userId, required String authCode, required Map<String, dynamic> cardInfo}) async {
    final uri = Uri.parse('$baseUrl/cards');
    final headers = Map<String, String>.from(_defaultHeaders);
    headers['x-user-id'] = userId;
    final res = await http.post(uri, headers: headers, body: json.encode({'authCode': authCode, 'cardInfo': cardInfo}));
    return res.statusCode == 200 || res.statusCode == 201;
  }

  /// Charge saved card via backend (backend should call Paystack charge_authorization)
  Future<Map<String, dynamic>?> chargeSavedCard({
    required String userId,
    required String authCode,
    required int amountKobo,
    required String email,
    required String reference,
  }) async {
    final uri = Uri.parse('$baseUrl/paystack/charge_saved');
    final headers = Map<String, String>.from(_defaultHeaders);
    headers['x-user-id'] = userId;
    final res = await http.post(uri, headers: headers, body: json.encode({
      'authCode': authCode,
      'amountKobo': amountKobo,
      'email': email,
      'reference': reference,
    }));
    if (res.statusCode == 200) return json.decode(res.body) as Map<String, dynamic>;
    return null;
  }
}
