import 'package:ansvel/homeandregistratiodesign/models/wallet.dart';
import 'package:ansvel/homeandregistratiodesign/services/wallet_api_service.dart';
import 'package:ansvel/homeandregistratiodesign/services/wallet_cache_service.dart';
// import 'package:ansvel/models/wallet.dart';
// import 'package:ansvel/services/wallet_api_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class WalletController extends ChangeNotifier {
  final WalletApiService _apiService = WalletApiService();
  final WalletCacheService _cacheService = WalletCacheService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- State for Managing User's Wallets ---
  Map<String, Wallet> _wallets = {};
  Map<String, Wallet> get wallets => _wallets;

  Map<String, bool> _loadingStates = {};
  Map<String, bool> get loadingStates => _loadingStates;
  String? _balanceError;
  String? get balanceError => _balanceError;

  // --- State for Bank Transfer Flow ---
  List<dynamic> _banks = [];
  List<dynamic> get banks => _banks;
  bool _isFetchingBanks = false;
  bool get isFetchingBanks => _isFetchingBanks;

  String? _verifiedAccountName;
  String? get verifiedAccountName => _verifiedAccountName;
  bool _isVerifyingAccount = false;
  bool get isVerifyingAccount => _isVerifyingAccount;
  String? _verificationError;
  String? get verificationError => _verificationError;

  bool _isProcessingTransfer = false;
  bool get isProcessingTransfer => _isProcessingTransfer;

  WalletController() {
    _loadFromCache();
  }

  // --- Methods for Managing Wallets ---

  Future<void> _loadFromCache() async {
    final cachedWallets = await _cacheService.loadWallets();
    for (var wallet in cachedWallets) {
      _wallets[wallet.id] = wallet;
    }
    notifyListeners();
  }

  void setWallets(Map<String, dynamic> walletData) {
    _wallets = walletData.map((key, value) {
      return MapEntry(key, Wallet.fromMap(key, value as Map<String, dynamic>));
    });
    _cacheService.saveWallets(_wallets.values.toList());
    notifyListeners();
  }

  Future<void> fetchBalance(String walletId) async {
    _loadingStates[walletId] = true;
    _balanceError = null;
    notifyListeners();

    try {
      final wallet = _wallets[walletId];
      if (wallet == null) throw Exception("Wallet not found in controller.");

      final balanceData = await _apiService.getWalletBalance(
        accountNumber: wallet.accountNumber,
        provider: wallet.provider,
      );

      final updatedWallet = wallet.copyWith(
        availableBalance: (balanceData['wallet']['availableBalance'] as num?)
            ?.toDouble(),
        bookedBalance: (balanceData['wallet']['bookedBalance'] as num?)
            ?.toDouble(),
      );

      _wallets[walletId] = updatedWallet;
    } catch (e) {
      print("Error fetching balance for $walletId: $e");
      _balanceError = "Could not fetch balance. Please try again later.";
    } finally {
      _loadingStates[walletId] = false;
      notifyListeners();
    }
  }

  // --- Methods for Bank Transfer Flow ---

  Future<void> fetchBankList(String countryCode) async {
    _isFetchingBanks = true;
    _banks = [];
    notifyListeners();
    try {
      _banks = await _apiService.getBankList(countryCode);
    } catch (e) {
      print(e);
    } finally {
      _isFetchingBanks = false;
      notifyListeners();
    }
  }

  Future<void> verifyAccountNumber(
    String accountNumber,
    String bankCode,
  ) async {
    _isVerifyingAccount = true;
    _verifiedAccountName = null;
    _verificationError = null;
    notifyListeners();
    try {
      final result = await _apiService.verifyBankAccount(
        accountNumber: accountNumber,
        sortCode: bankCode,
      );
      _verifiedAccountName = result['account']['accountName'];
    } catch (e) {
      _verificationError = e.toString().replaceFirst("Exception: ", "");
    } finally {
      _isVerifyingAccount = false;
      notifyListeners();
    }
  }

  void clearVerification() {
    _verifiedAccountName = null;
    _verificationError = null;
    notifyListeners();
  }

  Future<Map<String, dynamic>> executeTransfer({
    required Wallet fromWallet,
    required String bankCode,
    required String accountNumber,
    required String accountName,
    required double amount,
    required String narration,
    required String encryptedPin,
  }) async {
    _isProcessingTransfer = true;
    notifyListeners();
    try {
      final result = await _apiService.transferToBank(
        accountNumber: accountNumber,
        accountName: accountName,
        sortCode: bankCode,
        amount: amount,
        narration: narration,
        encryptedPin: encryptedPin,
      );
      _triggerServiceChargeDebit(fromWallet.customerId);
      return result;
    } finally {
      _isProcessingTransfer = false;
      notifyListeners();
    }
  }

  Future<void> _triggerServiceChargeDebit(String customerId) async {
    final reference = 'fee-${DateTime.now().millisecondsSinceEpoch}';
    try {
      await _apiService.debitWallet(
        amount: 5.0,
        reference: reference,
        customerId: customerId,
      );
      print("Successfully charged 5 Naira service fee.");
    } catch (e) {
      print(
        "Failed to charge 5 Naira service fee. Logging for retry. Error: $e",
      );
      await _firestore.collection('PendingFees').doc(reference).set({
        'customerId': customerId,
        'amount': 5.0,
        'reference': reference,
        'status': 'PENDING',
        'lastAttempt': FieldValue.serverTimestamp(),
        'error': e.toString(),
      });
    }
  }
}
