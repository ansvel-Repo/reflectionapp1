// lib/homeandregistratiodesign/views/wallet/checkout_screen.dart

import 'package:ansvel/homeandregistratiodesign/controllers/auth_controller.dart';
import 'package:ansvel/homeandregistratiodesign/controllers/wallet_controller.dart';
import 'package:ansvel/homeandregistratiodesign/services/crypto_service.dart';
import 'package:ansvel/homeandregistratiodesign/services/wallet_api_service.dart';
import 'package:ansvel/homeandregistratiodesign/views/widgets/pin_entry_dialog.dart';
import 'package:ansvel/homeandregistratiodesign/views/widgets/result_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  // These would be passed from your e-commerce platform
  final String merchantCustomerId;
  final double amount;

  const CheckoutScreen({
    super.key,
    required this.merchantCustomerId,
    required this.amount,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _apiService = WalletApiService();
  final _cryptoService = CryptoService();
  bool _isLoading = false;

  void _onConfirmPayment() {
    // Show a PIN entry dialog to securely get the transaction PIN
    showDialog(
      context: context,
      builder: (context) => PinEntryDialog(
        onPinVerified: (pin) {
          Navigator.pop(context); // Close the PIN dialog
          _processPayment(pin);
        },
      ),
    );
  }

  Future<void> _processPayment(String pin) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authController =
          Provider.of<AuthController>(context, listen: false);
      final user = authController.currentUser;

      if (user == null || user.wallets.isEmpty) {
        throw Exception('User has no wallets configured.');
      }

      // Get the default wallet from the user's profile
      final fromWallet = user.wallets.values.first;

      // Encrypt the PIN using the server's public key
      final encryptedPin = await _cryptoService.encrypt(pin);
      if (encryptedPin == null) {
        throw Exception('Encryption failed. Please try again.');
      }

      final result = await _apiService.processCheckout(
        fromWalletId: fromWallet.customerId!,
        toCustomerId: widget.merchantCustomerId,
        amount: widget.amount,
        encryptedPin: encryptedPin,
        provider: fromWallet.provider,
      );

      // Handle success: show a success dialog
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => ResultDialog(
            isSuccess: true,
            title: 'Payment Successful',
            message:
                'Your payment of ₦${widget.amount} was successful.',
            details: {
              'Reference': result['data']['reference'],
              'Transaction ID': result['data']['transactionId'],
            },
            onDone: () => Navigator.of(context).pop(),
          ),
        );
      }
    } catch (e) {
      // Handle errors: show an error dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => ResultDialog(
            isSuccess: false,
            title: 'Payment Failed',
            message: e.toString().replaceFirst('Exception: ', ''),
            onDone: () => Navigator.of(context).pop(),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Confirm Payment',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'You are about to pay ₦${widget.amount.toStringAsFixed(2)} to ${widget.merchantCustomerId}.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Please confirm your payment details before proceeding.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isLoading ? null : _onConfirmPayment,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Confirm and Pay'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}