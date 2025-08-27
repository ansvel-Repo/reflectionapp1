// import 'package:ansvel/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class TransactionResultScreen extends StatelessWidget {
  final bool isSuccess;
  final String? message;
  final Map<String, dynamic>? details;

  const TransactionResultScreen({
    super.key,
    required this.isSuccess,
    this.message,
    this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Lottie.asset(
                isSuccess ? 'assets/lottie/success.json' : 'assets/lottie/error.json',
                height: 150,
                repeat: false,
              ),
              const SizedBox(height: 32),
              Text(
                isSuccess ? "Transaction Successful!" : "Transaction Failed",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                isSuccess ? (details?['description'] ?? "Your transfer has been completed.") : (message ?? "An unknown error occurred."),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
              ),
              if (isSuccess && details != null) ...[
                const Divider(height: 48),
                _ResultDetailRow(title: "Reference", value: details!['reference'] ?? 'N/A'),
                _ResultDetailRow(title: "Session ID", value: details!['sessionId'] ?? 'N/A'),
                _ResultDetailRow(title: "Total Debited", value: "₦${details!['total']?.toStringAsFixed(2) ?? '0.00'}"),
              ],
              const Spacer(),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text("Back to Home"),
              ),
              const SizedBox(height: 16),
              // In a real app, these would trigger PDF/Image generation and sharing
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share),
                label: const Text("Share Receipt"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultDetailRow extends StatelessWidget {
  final String title;
  final String value;
  const _ResultDetailRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.grey.shade700)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}