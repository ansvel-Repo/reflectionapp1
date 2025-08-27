import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack_plus/flutter_paystack_plus.dart';
import 'package:get/get.dart';

class PaymentService {
  static String? _publicKey;
  static String? _secretKey;

  /// **🔄 Fetch Paystack API Keys from Firestore**
  static Future<void> fetchPaystackKeys() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('API_Keys')
          .doc('paystack')
          .get();
      if (snapshot.exists) {
        _publicKey = snapshot.get('publicKey');
        _secretKey = snapshot.get('secretKey');
      } else {
        Get.snackbar("Error", "Paystack keys not found in Firestore.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch Paystack keys: $e");
    }
  }

  /// **💳 Process Payments Using Paystack**
  static Future<bool> processPayment({
    required BuildContext context,
    required String email,
    required int amount, // Amount in Naira (converted to Kobo internally)
    String? plan, // Used for subscriptions
    bool isSubscription = false, // Set to true for subscriptions
    String? subAccount, // Single Split Payment
    String? splitCode, // Multiple Split Payment
    int transactionCharge = 0, // Optional charge override
  }) async {
    if (_publicKey == null || _secretKey == null) {
      await fetchPaystackKeys();
    }

    if (_publicKey == null || _secretKey == null) {
      Get.snackbar(
          "Payment Error", "Paystack keys are missing. Contact support.");
      return false;
    }

    try {
      bool paymentSuccess = false;

      Map<String, dynamic> metadata = {};

      // **Handle Single Split Payment**
      if (subAccount != null) {
        metadata['custom_fields'] = [
          {
            "display_name": "SubAccount",
            "variable_name": "subAccount",
            "value": subAccount
          },
        ];
      }

      // **Handle Multiple Split Payment**
      if (splitCode != null) {
        metadata['split'] = {"split_code": splitCode};
      }

      // **Handle Transaction Charge Override**
      if (transactionCharge > 0) {
        metadata['custom_fields'] ??= [];
        metadata['custom_fields'].add({
          "display_name": "Transaction Charge",
          "variable_name": "transactionCharge",
          "value": transactionCharge
        });
      }

      await FlutterPaystackPlus.openPaystackPopup(
        publicKey: _publicKey!,
        customerEmail: email,
        context: context,
        secretKey: _secretKey!,
        amount: (amount * 100).toString(), // Convert Naira to Kobo
        reference: DateTime.now().millisecondsSinceEpoch.toString(),
        plan: isSubscription ? plan : null,
        metadata: metadata, // ✅ Pass metadata for split payments
        onSuccess: () async {
          paymentSuccess = true;
          Get.snackbar("Payment Success", "Your payment was successful!");
        },
        onClosed: () {
          Get.snackbar("Payment Cancelled", "Payment process was closed.");
        },
      );

      return paymentSuccess;
    } catch (e) {
      Get.snackbar("Payment Error", "Error processing payment: $e");
      return false;
    }
  }
}




// //How to call these paystack payment methods
// //Single Split Payment Example
// void _payWithSingleSplit() async {
//   bool paymentSuccess = await PaymentService.processPayment(
//     context: context,
//     email: "user@example.com",
//     amount: 5000, // Amount in Naira
//     subAccount: "ACCT_osl1da48je0lez6", // Paystack SubAccount ID
//     transactionCharge: 2500, // Override transaction charge (optional)
//   );

//   if (paymentSuccess) {
//     Get.snackbar("Success", "Payment completed!");
//   }
// }


// //Multi Split Payment Example
// void _payWithMultiSplit() async {
//   bool paymentSuccess = await PaymentService.processPayment(
//     context: context,
//     email: "user@example.com",
//     amount: 5000, // Amount in Naira
//     splitCode: "SPL_98WF13Eb3w", // Paystack Split Code
//   );

//   if (paymentSuccess) {
//     Get.snackbar("Success", "Payment completed!");
//   }
// }

// //Subscription Payment Example
// void _payForSubscription() async {
//   bool paymentSuccess = await PaymentService.processPayment(
//     context: context,
//     email: "user@example.com",
//     amount: 5000, // Amount in Naira
//     plan: "PLN_123XYZ", // The plan_code from Paystack Dashboard
//     isSubscription: true, // Enable recurring subscription
//   );

//   if (paymentSuccess) {
//     Get.snackbar("Subscription Activated", "You have successfully subscribed!");
//   }
// }

