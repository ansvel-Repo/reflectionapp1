// import 'package:ansvel/widgets/pin_entry_dialog.dart';
import 'package:ansvel/homeandregistratiodesign/services/crypto_service.dart';
import 'package:ansvel/homeandregistratiodesign/services/wallet_api_service.dart';
import 'package:ansvel/homeandregistratiodesign/views/widgets/pin_entry_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// import 'package:ansvel/services/crypto_service.dart';
// import 'package:ansvel/services/wallet_api_service.dart';
// import 'package:ansvel/widgets/pin_entry_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class TransferToWalletScreen extends StatefulWidget {
  const TransferToWalletScreen({super.key});

  @override
  State<TransferToWalletScreen> createState() => _TransferToWalletScreenState();
}

class _TransferToWalletScreenState extends State<TransferToWalletScreen> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();
  final _narrationController = TextEditingController();
  bool _isLoading = false;

  void _onContinue() {
    if (_formKey.currentState!.validate()) {
      // Show the PIN entry dialog to authorize the transaction
      showDialog(
        context: context,
        builder: (context) => PinEntryDialog(
          onPinVerified: (pin) {
            Navigator.pop(context); // Close the dialog
            _processTransfer(pin);
          },
        ),
      );
    }
  }

  Future<void> _processTransfer(String pin) async {
    setState(() { _isLoading = true; });
    
    try {
      final cryptoService = CryptoService();
      final apiService = WalletApiService();

      // Encrypt the PIN using the server's public key before sending
      final encryptedPin = await cryptoService.encrypt(pin);
      if (encryptedPin == null) throw Exception("Encryption failed. Please try again.");

      // Call the API service to perform the transfer
      await apiService.transferToWallet(
        recipientUsername: _recipientController.text.trim(),
        amount: double.parse(_amountController.text),
        narration: _narrationController.text.trim(),
        encryptedPin: encryptedPin,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Transfer successful!"), backgroundColor: Colors.green),
        );
        Navigator.pop(context); // Go back to the dashboard after success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send to Ansvel User", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _recipientController,
                decoration: const InputDecoration(labelText: "Recipient's Username or Phone"),
                validator: (v) => v!.isEmpty ? 'Please enter a recipient' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: "Amount (₦)"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Please enter an amount' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _narrationController,
                decoration: const InputDecoration(labelText: "Narration (Optional)"),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _onContinue,
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 3) 
                    : const Text("Continue"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}