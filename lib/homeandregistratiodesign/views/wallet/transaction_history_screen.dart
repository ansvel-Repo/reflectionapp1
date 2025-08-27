import 'package:ansvel/homeandregistratiodesign/services/wallet_api_service.dart';
// import 'package:ansvel/services/wallet_api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  late Future<List<dynamic>> _transactionsFuture;
  final WalletApiService _apiService = WalletApiService();

  @override
  void initState() {
    super.initState();
    _transactionsFuture = _apiService.getTransactionHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction History", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          // --- Handle Loading State ---
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // --- Handle Error State ---
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Could not load transactions.\n${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            );
          }

          // --- Handle Empty State ---
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No transactions found."));
          }

          // --- Handle Success State ---
          final transactions = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tx = transactions[index] as Map<String, dynamic>;
              final isCredit = tx['type'] == 'CREDIT';
              
              return Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: (isCredit ? Colors.green : Colors.red).withOpacity(0.1),
                    child: Icon(
                      isCredit ? FontAwesomeIcons.arrowDown : FontAwesomeIcons.arrowUp,
                      color: isCredit ? Colors.green : Colors.red,
                      size: 16,
                    ),
                  ),
                  title: Text(tx['description'] ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(tx['category']?.replaceAll('_', ' ') ?? 'Transaction'),
                  trailing: Text(
                    "${isCredit ? '+' : '-'} ₦ ${tx['amount']?.toStringAsFixed(2) ?? '0.00'}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCredit ? Colors.green : Colors.red,
                      fontSize: 16,
                    ),
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