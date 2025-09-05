// lib/services/paystack_key_manager.dart
// PaystackKeyManager compatible with backend hex encryption (ivHex:cipherHex)

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as enc;

class PaystackKeyManager {
  PaystackKeyManager._private();
  static final PaystackKeyManager instance = PaystackKeyManager._private();

  final _storage = const FlutterSecureStorage();
  final _firestore = FirebaseFirestore.instance;
  static const _cacheKey = 'ps_public_key_cache';

  // ⚠️ Replace with your real 32-char AES secret (must match backend AES_SECRET)
  static const String _aesSecret = 'REPLACE_WITH_YOUR_32_CHAR_AES_SECRET';

  final enc.Key _key = enc.Key.fromUtf8(_aesSecret);
  final enc.IV _iv = enc.IV.fromUtf8('0000000000000000'); // fixed 16-char IV
  late final enc.Encrypter _encrypter =
      enc.Encrypter(enc.AES(_key, mode: enc.AESMode.cbc));

  String? _cachedKey;

  /// Initialize and subscribe to Firestore for live updates
  Future<void> init() async {
    _cachedKey ??= await _storage.read(key: _cacheKey);
    try {
      _firestore.collection('Config').doc('PaystackKey').snapshots().listen(
        (snap) async {
          final data = snap.data();
          if (data == null) return;
          final encKey = data['encryptedKey'] as String?;
          if (encKey == null) return;

          final decrypted = _decrypt(encKey);
          if (decrypted != null && decrypted.isNotEmpty) {
            _cachedKey = decrypted;
            await _storage.write(key: _cacheKey, value: decrypted);
            // 🔑 Log successful key update to monitoring/analytics
            print('Paystack public key updated from Firestore');
          }
        },
        onError: (err) {
          // ❗ Log listener error (Crashlytics, Sentry, etc.)
          print('Firestore listener error: $err');
        },
      );
    } catch (e) {
      // ❗ Log init error
      print('PaystackKeyManager init error: $e');
    }
  }

  /// Retrieve Paystack public key (prefers cache, then Firestore)
  Future<String?> getPublicKey() async {
    if (_cachedKey != null && _cachedKey!.isNotEmpty) return _cachedKey;

    try {
      final doc =
          await _firestore.collection('Config').doc('PaystackKey').get();
      final encKey = doc.data()?['encryptedKey'] as String?;
      if (encKey != null) {
        final decrypted = _decrypt(encKey);
        if (decrypted != null && decrypted.isNotEmpty) {
          _cachedKey = decrypted;
          await _storage.write(key: _cacheKey, value: decrypted);
          return decrypted;
        }
      }
    } catch (e) {
      // ❗ Log fetch error
      print('Error fetching Paystack key: $e');
    }

    // fallback to secure storage
    return _cachedKey ?? await _storage.read(key: _cacheKey);
  }

  /// Decrypt payload of format "ivHex:cipherHex"
  String? _decrypt(String payload) {
    try {
      final parts = payload.split(':');
      if (parts.length != 2) return null;

      final cipherHex = parts[1];
      final bytes = <int>[];
      for (var i = 0; i < cipherHex.length; i += 2) {
        bytes.add(int.parse(cipherHex.substring(i, i + 2), radix: 16));
      }
      final encrypted = enc.Encrypted(Uint8List.fromList(bytes));

      return _encrypter.decrypt(encrypted, iv: _iv);
    } catch (e) {
      // ❗ Log decrypt error
      print('Decrypt error: $e');
      return null;
    }
  }
}
