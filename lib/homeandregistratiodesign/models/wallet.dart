import 'dart:convert';

class Wallet {
  final String id; // A unique identifier for the wallet document itself in Firestore
  final String provider; // e.g., "providus"
  final String country;
  final String accountNumber;
  final String accountName;
  final String bankName;
  
  // FIX: This field is required by the API for debit and transfer operations.
  final String customerId; // The unique ID for the customer from the provider (e.g., Providus)
  
  double? availableBalance; // Made non-final to be updatable
  double? bookedBalance;

  Wallet({
    required this.id,
    required this.provider,
    required this.country,
    required this.accountNumber,
    required this.accountName,
    required this.bankName,
    required this.customerId,
    this.availableBalance,
    this.bookedBalance,
  });

  // Factory constructor to create a Wallet from a Map (e.g., from Firestore)
  factory Wallet.fromMap(String id, Map<String, dynamic> map) {
    return Wallet(
      id: id,
      provider: map['provider'] ?? 'unknown',
      country: map['country'] ?? 'NG',
      accountNumber: map['accountNumber'] ?? '',
      accountName: map['accountName'] ?? '',
      bankName: map['bankName'] ?? '',
      customerId: map['customerId'] ?? '', // Added customerId
      availableBalance: (map['availableBalance'] as num?)?.toDouble(),
      bookedBalance: (map['bookedBalance'] as num?)?.toDouble(),
    );
  }

  // Convert a Wallet object into a Map for JSON serialization (local cache)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provider': provider,
      'country': country,
      'accountNumber': accountNumber,
      'accountName': accountName,
      'bankName': bankName,
      'customerId': customerId,
    };
  }

  // Create a Wallet object from a JSON Map (local cache)
  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'],
      provider: json['provider'],
      country: json['country'],
      accountNumber: json['accountNumber'],
      accountName: json['accountName'],
      bankName: json['bankName'],
      customerId: json['customerId'],
    );
  }

  // Helper method to create a copy of the wallet with updated values
  Wallet copyWith({
    double? availableBalance,
    double? bookedBalance,
  }) {
    return Wallet(
      id: this.id,
      provider: this.provider,
      country: this.country,
      accountNumber: this.accountNumber,
      accountName: this.accountName,
      bankName: this.bankName,
      customerId: this.customerId,
      availableBalance: availableBalance ?? this.availableBalance,
      bookedBalance: bookedBalance ?? this.bookedBalance,
    );
  }
}