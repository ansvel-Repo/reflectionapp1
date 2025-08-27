// import 'package:ansvel/controllers/transfer_controller.dart';
// import 'package:ansvel/models/wallet.dart';
// import 'package:ansvel/services/crypto_service.dart';
// import 'package:ansvel/views/wallet/transaction_result_screen.dart';
// import 'package:ansvel/widgets/pin_entry_dialog.dart';
import 'package:ansvel/homeandregistratiodesign/controllers/transfer_controller.dart';
import 'package:ansvel/homeandregistratiodesign/models/wallet.dart';
import 'package:ansvel/homeandregistratiodesign/services/crypto_service.dart';
import 'package:ansvel/homeandregistratiodesign/views/wallet/other_bank_transfer/transaction_result_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/widgets/pin_entry_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class TransferSummaryScreen extends StatelessWidget {
  final Wallet fromWallet;
  final String bankName;
  final String bankCode;
  final String accountName;
  final String accountNumber;
  final double amount;
  final String narration;

  const TransferSummaryScreen({
    super.key,
    required this.fromWallet,
    required this.bankName,
    required this.bankCode,
    required this.accountName,
    required this.accountNumber,
    required this.amount,
    required this.narration,
  });

  @override
  Widget build(BuildContext context) {
    // Use a Consumer for the controller to react to state changes (like loading)
    return Consumer<TransferController>(
      builder: (context, controller, child) {
        void _onConfirm() {
          showDialog(
            context: context,
            builder: (_) => PinEntryDialog(
              onPinVerified: (pin) async {
                Navigator.pop(context); // Close PIN dialog
                try {
                  final cryptoService = CryptoService();
                  final encryptedPin = await cryptoService.encrypt(pin);
                  if (encryptedPin == null)
                    throw Exception("Encryption failed.");

                  final result = await controller.executeTransfer(
                    fromWallet: fromWallet,
                    bankCode: bankCode,
                    accountNumber: accountNumber,
                    accountName: accountName,
                    amount: amount,
                    narration: narration,
                    encryptedPin: encryptedPin,
                  );

                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TransactionResultScreen(
                          isSuccess: true,
                          details: result['transfer'],
                        ),
                      ),
                      (route) => route.isFirst,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TransactionResultScreen(
                          isSuccess: false,
                          message: e.toString(),
                        ),
                      ),
                      (route) => route.isFirst,
                    );
                  }
                }
              },
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Confirm Transfer",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Text(
                  "Please review the details of your transaction before completing.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _SummaryRow(
                          title: "Amount",
                          value: "₦${amount.toStringAsFixed(2)}",
                        ),
                        _SummaryRow(title: "Recipient", value: accountName),
                        _SummaryRow(
                          title: "Account Number",
                          value: accountNumber,
                        ),
                        _SummaryRow(title: "Bank", value: bankName),
                        if (narration.isNotEmpty)
                          _SummaryRow(title: "Narration", value: narration),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: controller.isProcessingTransfer
                        ? null
                        : _onConfirm,
                    child: controller.isProcessingTransfer
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Complete Transaction"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String title;
  final String value;
  const _SummaryRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
