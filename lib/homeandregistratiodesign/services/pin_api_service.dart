import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class PinApiService {
  final String _baseUrl = 'YOUR_ORCHESTRATOR_URL'; // Replace with your URL

  Future<String?> _getAuthToken() async {
    return await FirebaseAuth.instance.currentUser?.getIdToken();
  }

  Future<void> setPin(String encryptedPin) async {
    final token = await _getAuthToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.post(
      Uri.parse('$_baseUrl/pin/setup'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode({'pin': encryptedPin}), // DTO expects 'pin'
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to set PIN: ${response.body}');
    }
  }

  Future<void> initiatePinReset(String newEncryptedPin) async {
    final token = await _getAuthToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.post(
      Uri.parse('$_baseUrl/pin/reset/initiate'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode({'newPin': newEncryptedPin}), // DTO expects 'newPin'
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to initiate PIN reset: ${response.body}');
    }
  }

  Future<void> cancelPinReset() async {
    final token = await _getAuthToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.patch(
      Uri.parse('$_baseUrl/pin/reset/cancel'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to cancel PIN reset: ${response.body}');
    }
  }
}