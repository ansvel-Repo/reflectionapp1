import 'dart:convert';
import 'package:ansvel/homeandregistratiodesign/models/wallet.dart';
// import 'package:ansvel/models/wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletCacheService {
  static const _cacheKey = 'user_wallets';

  // Save a list of wallets to local storage
  Future<void> saveWallets(List<Wallet> wallets) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> walletsJson = wallets.map((w) => jsonEncode(w.toJson())).toList();
    await prefs.setStringList(_cacheKey, walletsJson);
  }

  // Load the list of wallets from local storage
  Future<List<Wallet>> loadWallets() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? walletsJson = prefs.getStringList(_cacheKey);
    if (walletsJson == null) {
      return [];
    }
    return walletsJson.map((jsonString) => Wallet.fromJson(jsonDecode(jsonString))).toList();
  }

  // Clear the cache when the user logs out
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }
}