import 'package:ansvel/homeandregistratiodesign/models/wallet.dart';
import 'package:ansvel/homeandregistratiodesign/services/wallet_api_service.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransferController extends ChangeNotifier {
  final WalletApiService _apiService = WalletApiService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // State for Bank List
  List<dynamic> _banks = [];
  List<dynamic> get banks => _banks;
  bool _isFetchingBanks = false;
  bool get isFetchingBanks => _isFetchingBanks;

  // State for Account Verification
  String? _verifiedAccountName;
  String? get verifiedAccountName => _verifiedAccountName;
  bool _isVerifyingAccount = false;
  bool get isVerifyingAccount => _isVerifyingAccount;
  String? _verificationError;
  String? get verificationError => _verificationError;

  // State for the transaction itself
  bool _isProcessingTransfer = false;
  bool get isProcessingTransfer => _isProcessingTransfer;

  // --- Methods ---

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

  Future<void> verifyAccountNumber(String accountNumber, String bankCode) async {
    _isVerifyingAccount = true;
    _verifiedAccountName = null;
    _verificationError = null;
    notifyListeners();
    try {
      final result = await _apiService.verifyBankAccount(
        accountNumber: accountNumber,
        sortCode: bankCode,
        provider: 'providus', // Added missing 'provider' argument
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
        provider: 'providus', // Added missing 'provider' argument
      );

      // After successful transfer, trigger the 5 Naira debit without waiting for it
      _triggerServiceChargeDebit(fromWallet.customerId);

      return result;
    } finally {
      _isProcessingTransfer = false;
      notifyListeners();
    }
  }

  // --- THIS METHOD IMPLEMENTS THE COMMENTED LOGIC ---
  Future<void> _triggerServiceChargeDebit(String customerId) async {
    final reference = 'fee-${DateTime.now().millisecondsSinceEpoch}';
    try {
      // This runs in the background. The user does not wait for it.
      await _apiService.debitWallet(
        amount: 5.0,
        reference: reference,
        customerId: customerId,
        provider: 'providus', // Added missing 'provider' argument
      );
      print("Successfully charged 5 Naira service fee.");
    } catch (e) {
      print("Failed to charge 5 Naira service fee. Logging for retry. Error: $e");
      
      // Log the failed fee to a "PendingFees" collection in Firestore.
      // A cloud function would be set up to listen to this collection and retry.
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