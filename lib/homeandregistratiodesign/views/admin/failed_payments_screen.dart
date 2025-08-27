// import 'package:ansvel/services/wallet_api_service.dart';
import 'package:ansvel/homeandregistratiodesign/services/wallet_api_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class FailedPaymentsScreen extends StatefulWidget {
  const FailedPaymentsScreen({super.key});

  @override
  State<FailedPaymentsScreen> createState() => _FailedPaymentsScreenState();
}

class _FailedPaymentsScreenState extends State<FailedPaymentsScreen> {
  final WalletApiService _walletApiService = WalletApiService();
  String? _reversingTransactionId; // To show loading indicator on a specific tile

  void _showReversalConfirmation(String docId, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Reversal"),
        content: Text("Are you sure you want to reverse this transaction?\n\nRef: ${data['paymentReference']}\nAmount: ₦${data['amount']}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _reverseTransaction(docId, data);
            },
            child: const Text("Confirm Reversal"),
          ),
        ],
      ),
    );
  }

  void _reverseTransaction(String docId, Map<String, dynamic> data) async {
    setState(() {
      _reversingTransactionId = docId;
    });

    try {
      final double amount = (data['amount'] as num).toDouble();
      final String customerId = data['customerId'];
      final String originalReference = data['paymentReference'];

      await _walletApiService.reverseFailedBillPayment(
        amount: amount,
        customerId: customerId,
        originalReference: originalReference,
      );

      // After successful reversal, delete the log from the failed payments table
      await FirebaseFirestore.instance.collection('FailedBillsPayment').doc(docId).delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Reversal for ${data['paymentReference']} was successful."), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _reversingTransactionId = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Failed Bill Payments", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('FailedBillsPayment').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No failed payments found."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final timestamp = (data['timestamp'] as Timestamp?)?.toDate();
              final formattedDate = timestamp != null ? DateFormat.yMMMd().add_jm().format(timestamp) : 'N/A';
              final isReversing = _reversingTransactionId == doc.id;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text("Ref: ${data['paymentReference']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    "Customer ID: ${data['customerId']}\nAmount: ₦${data['amount']}\nDate: $formattedDate",
                  ),
                  isThreeLine: true,
                  trailing: isReversing
                      ? const CircularProgressIndicator()
                      : TextButton(
                          onPressed: () => _showReversalConfirmation(doc.id, data),
                          child: const Text("Reverse", style: TextStyle(color: Colors.red)),
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}