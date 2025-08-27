import 'package:ansvel/homeandregistratiodesign/models/security_question.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

// Add the new role to your enum
enum UserRole { Customer, Merchant, Driver, SubAdmin, Admin } 
// ... rest of the file remains the same
enum BusinessType {
  FoodVendor,
  Restaurant,
  Blog,
  Service,
  RideSharing, // Offer free seats in your car for a fee
  RideHailing, // Add this
}

class AppUser {
  final String uid;
  final String email;
  final String username;
  final UserRole role;
  final Set<BusinessType> businessTypes;
  final List<SecurityQuestionAnswer> securityQuestions;
  final String? encryptedPin;

  // --- NEW KYC FIELDS ADDED ---
  final String? firstName;
  final String? lastName;
  final String? dateOfBirth;
  final String? phoneNumber;
  final String? address;

  // Fields for password reset flow
  final String? pendingPassword;
  final DateTime? passwordResetTimestamp;

  // Wallet structure now supports multiple wallets
  final Map<String, dynamic> wallets;

  AppUser({
    required this.uid,
    required this.email,
    required this.username,
    required this.role,
    this.businessTypes = const {},
    this.securityQuestions = const [],
    this.encryptedPin,
    this.pendingPassword,
    this.passwordResetTimestamp,
    this.wallets = const {},
    // Added to constructor
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.phoneNumber,
    this.address,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.toString() == data['role'],
        orElse: () => UserRole.Customer,
      ),
      businessTypes: Set<BusinessType>.from(
        (data['businessTypes'] as List<dynamic>? ?? []).map(
          (type) => BusinessType.values.firstWhere((e) => e.toString() == type),
        ),
      ),
      securityQuestions: (data['securityQuestions'] as List<dynamic>? ?? [])
          .map((q) => SecurityQuestionAnswer.fromFirestore(q))
          .toList(),
      encryptedPin: data['encryptedPin'],
      pendingPassword: data['pendingPassword'],
      passwordResetTimestamp: (data['passwordResetTimestamp'] as Timestamp?)?.toDate(),
      wallets: data['wallets'] as Map<String, dynamic>? ?? {},
      // Reading new KYC fields from Firestore
      firstName: data['firstName'],
      lastName: data['lastName'],
      dateOfBirth: data['dateOfBirth'],
      phoneNumber: data['phoneNumber'],
      address: data['address'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'username': username,
      'role': role.toString(),
      'businessTypes': businessTypes.map((type) => type.toString()).toList(),
      'securityQuestions': securityQuestions.map((q) => q.toFirestore()).toList(),
      'encryptedPin': encryptedPin,
      'pendingPassword': pendingPassword,
      'passwordResetTimestamp': passwordResetTimestamp,
      'wallets': wallets,
      // Adding new KYC fields for writing to Firestore
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }
}

