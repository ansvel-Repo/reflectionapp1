import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pointycastle/asymmetric/oaep.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:pointycastle/pointycastle.dart';
// import 'package:pointycastle/key_factories/pkcs1_key_spec_parser.dart';
import 'dart:typed_data';


/// A robust helper function to parse an RSA public key from a string.
/// It can handle both standard PEM format (with headers/footers) and raw Base64.
RSAPublicKey parsePublicKey(String keyString) {
  String pemContent;

  // Check if the key is in PEM format and strip headers/footers if it is.
  if (keyString.contains('-----BEGIN PUBLIC KEY-----')) {
    pemContent = keyString
        .replaceAll("-----BEGIN PUBLIC KEY-----", "")
        .replaceAll("-----END PUBLIC KEY-----", "")
        .replaceAll("\n", "")
        .trim();
  } else {
    // Assume it's already a raw Base64 string.
    pemContent = keyString.trim();
  }

  // Decode the Base64 content into bytes.
  final asn1Bytes = base64.decode(pemContent);
  final asn1Parser = ASN1Parser(asn1Bytes);
  
  // The top-level object in a public key PEM is a sequence.
  final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
  
  // Add null checks before accessing list elements for null safety.
  if (topLevelSeq.elements == null || topLevelSeq.elements!.length < 2) {
    throw FormatException('Invalid ASN.1 structure for public key.');
  }

  // The actual key is stored in a BIT STRING.
  final publicKeyBitString = topLevelSeq.elements![1] as ASN1BitString;

  // Parse the BIT STRING's content to get the key's components.
  final publicKeyAsn = ASN1Parser(publicKeyBitString.stringValues as Uint8List);
  final publicKeySeq = publicKeyAsn.nextObject() as ASN1Sequence;

  if (publicKeySeq.elements == null || publicKeySeq.elements!.length < 2) {
    throw FormatException('Invalid ASN.1 structure for public key details.');
  }

  // Use the correct '.integer' property.
  final modulus = (publicKeySeq.elements![0] as ASN1Integer).integer!;
  final exponent = (publicKeySeq.elements![1] as ASN1Integer).integer!;

  return RSAPublicKey(modulus, exponent);
}


class CryptoService {
  final String _orchestratorUrl = 'YOUR_ORCHESTRATOR_URL'; // Replace with your URL
  RSAPublicKey? _publicKey;

  // Fetches the public key from the server and parses it.
  Future<void> _fetchPublicKey() async {
    try {
      final response = await http.get(Uri.parse('$_orchestratorUrl/security/public-key'));
      if (response.statusCode == 200) {
        final keyString = jsonDecode(response.body)['publicKey'];
        // Use the robust parser to handle the key string.
        _publicKey = parsePublicKey(keyString);
      } else {
        throw Exception('Failed to fetch public key from server.');
      }
    } catch (e) {
      print('Error fetching public key: $e');
      throw Exception('Could not connect to security service.');
    }
  }

  // Encrypts plain text using the fetched public key.
  Future<String> encrypt(String plainText) async {
    // Fetch the key if it's not already available.
    if (_publicKey == null) {
      await _fetchPublicKey();
    }
    
    // If fetching failed after trying, throw an exception.
    if (_publicKey == null) {
      throw Exception("Could not retrieve encryption key. Please try again.");
    }
    
    final encrypter = OAEPEncoding(RSAEngine());
    encrypter.init(true, PublicKeyParameter<RSAPublicKey>(_publicKey!));
    
    final Uint8List encryptedBytes =
        encrypter.process(Uint8List.fromList(utf8.encode(plainText)));
        
    return base64.encode(encryptedBytes);
  }
}