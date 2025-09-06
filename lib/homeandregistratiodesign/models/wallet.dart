// lib/homeandregistratiodesign/models/wallet.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';

class Wallet {
  final String id;
  final String provider; // e.g., 'providus'
  final String country;
  final String? accountName;
  final String accountNumber;
  final String bankName;
  final String bankCode;
  final String customerId; // The unique ID for the customer from the provider
  final String? accountReference;
  final double? availableBalance;
  final double? bookedBalance;
  final String? status;

  Wallet({
    required this.id,
    required this.provider,
    required this.country,
    required this.accountNumber,
    required this.accountName,
    required this.bankName,
    required this.bankCode,
    required this.customerId,
    this.accountReference,
    this.availableBalance,
    this.bookedBalance,
    this.status,
  });

// Factory constructor to create a Wallet from a Map (e.g., from Firestore)
  factory Wallet.fromMap(String id, Map<String, dynamic> data) {
    return Wallet(
      id: id,
      provider: data['provider'] as String? ?? 'unknown',
      country: data['country'] as String? ?? 'NG',
      accountNumber: data['accountNumber'] as String,
      accountName: data['accountName'] as String,
      bankName: data['bankName'] as String,
      bankCode: data['bankCode'] as String,
      customerId: data['customerId'] as String,
      accountReference: data['accountReference'] as String?,
      availableBalance: (data['availableBalance'] as num?)?.toDouble(),
      bookedBalance: (data['bookedBalance'] as num?)?.toDouble(),
      status: data['status'] as String?,
    );
  }

  // Converts a Wallet object into a JSON Map for serialization (e.g., local cache)
  Map<String, dynamic> toMap() {
    return {
      'provider': provider,
      'accountName': accountName,
      'accountNumber': accountNumber,
      'bankName': bankName,
      'bankCode': bankCode,
      'customerId': customerId,
      'accountReference': accountReference,
      'availableBalance': availableBalance,
      'bookedBalance': bookedBalance,
      'status': status,
      'country': country, // Writing the country to the map
    };
  }

  // Converts a Wallet object into a JSON Map for serialization (e.g., local cache)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provider': provider,
      'country': country,
      'accountNumber': accountNumber,
      'accountName': accountName,
      'bankName': bankName,
      'bankCode': bankCode,
      'customerId': customerId,
      'accountReference': accountReference,
      'availableBalance': availableBalance,
      'bookedBalance': bookedBalance,
      'status': status,
    };
  }

  // Creates a Wallet object from a JSON Map (e.g., local cache)
  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'],
      provider: json['provider'],
      country: json['country'],
      accountNumber: json['accountNumber'],
      accountName: json['accountName'],
      bankName: json['bankName'],
      bankCode: json['bankCode'],
      customerId: json['customerId'],
      accountReference: json['accountReference'],
      availableBalance: json['availableBalance'] != null
          ? (json['availableBalance'] as num).toDouble()
          : null,
      bookedBalance: json['bookedBalance'] != null
          ? (json['bookedBalance'] as num).toDouble()
          : null,
      status: json['status'],
    );
  }

  // Helper method to create a copy of the wallet with updated values
  Wallet copyWith({
    double? availableBalance,
    double? bookedBalance,
    String? status,
  }) {
    return Wallet(
      id: this.id,
      provider: this.provider,
      country: this.country,
      accountNumber: this.accountNumber,
      accountName: this.accountName,
      bankName: this.bankName,
      bankCode: this.bankCode,
      customerId: this.customerId,
      accountReference: this.accountReference,
      availableBalance: availableBalance ?? this.availableBalance,
      bookedBalance: bookedBalance ?? this.bookedBalance,
      status: status ?? this.status,
    );
  }
}