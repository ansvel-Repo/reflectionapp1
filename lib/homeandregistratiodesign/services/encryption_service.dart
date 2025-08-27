import 'package:encrypt/encrypt.dart';



class EncryptionService {
  // IMPORTANT: In a real production app, DO NOT hardcode this key.
  // Store it securely using flutter_secure_storage or retrieve it from a secure backend.
  static final _key = Key.fromUtf8('my32lengthsupersecretnooneknows!');
  static final _iv = IV.fromLength(16);
  static final _encrypter = Encrypter(AES(_key));

  static String encrypt(String text) {
    final encrypted = _encrypter.encrypt(text, iv: _iv);
    return encrypted.base64;
  }

  static String decrypt(String encryptedText) {
    final encrypted = Encrypted.fromBase64(encryptedText);
    final decrypted = _encrypter.decrypt(encrypted, iv: _iv);
    return decrypted;
  }
}