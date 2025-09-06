import 'package:ansvel/homeandregistratiodesign/models/app_user.dart';
import 'package:ansvel/homeandregistratiodesign/models/wallet.dart';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  AuthController() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _currentUser = null;
    } else {
      await fetchFirestoreUser(firebaseUser.uid);
    }
    notifyListeners();
  }

  Future<void> updateUserWalletStatusLocally({
    required String walletId,
    required String status,
  }) async {
    if (_currentUser == null) return;

    final updatedWallets = Map<String, dynamic>.from(_currentUser!.wallets);
    if (updatedWallets.containsKey(walletId)) {
      final oldWallet = Wallet.fromJson(updatedWallets[walletId]);
      final newWallet = oldWallet.copyWith(status: status);
      updatedWallets[walletId] = newWallet.toJson();
      _currentUser = _currentUser!.copyWith(wallets: updatedWallets);
      notifyListeners();
    }
  }

  Future<void> fetchFirestoreUser(String uid) async {
    try {
      final doc = await _firestore.collection('Users').doc(uid).get();
      if (doc.exists) {
        _currentUser = AppUser.fromFirestore(doc);
      }
    } catch (e) {
      print("Error fetching Firestore user: $e");
      _currentUser = null;
    }
  }

  Future<String?> createAccount({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        final newUser = AppUser(
          uid: firebaseUser.uid,
          email: email,
          username: username,
          role: UserRole.Customer,
        );
        await _firestore
            .collection('Users')
            .doc(firebaseUser.uid)
            .set(newUser.toFirestore());
        _currentUser = newUser;
        notifyListeners();
        return null;
      }
      return "An unknown error occurred.";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // --- FIX: Updated to use named parameters for consistency and safety ---
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> setRole(UserRole role) async {
    if (_currentUser == null) return "User not logged in.";
    try {
      await _firestore.collection('Users').doc(_currentUser!.uid).update({
        'role': role.toString(),
      });
      await fetchFirestoreUser(_currentUser!.uid);
      notifyListeners();
      return null;
    } catch (e) {
      return "Error updating role: $e";
    }
  }

  Future<String?> setBusinessTypes(Set<BusinessType> types) async {
    if (_currentUser == null) return "User not logged in.";
    if (_currentUser!.role != UserRole.Merchant) {
      return "User is not a merchant.";
    }

    try {
      final typesAsStrings = types.map((type) => type.toString()).toList();
      await _firestore.collection('Users').doc(_currentUser!.uid).update({
        'businessTypes': typesAsStrings,
      });
      await fetchFirestoreUser(_currentUser!.uid);
      notifyListeners();
      return null;
    } catch (e) {
      return "Error updating business types: $e";
    }
  }

  Future<String?> updateUserKYCData(Map<String, dynamic> kycData) async {
    if (_currentUser == null) return "User not logged in.";
    try {
      await _firestore
          .collection('Users')
          .doc(_currentUser!.uid)
          .update(kycData);
      await fetchFirestoreUser(_currentUser!.uid);
      notifyListeners();
      return null;
    } catch (e) {
      return "Could not update user profile.";
    }
  }
}
