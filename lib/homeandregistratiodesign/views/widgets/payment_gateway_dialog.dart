// lib/homeandregistratiodesign/views/widgets/payment_gateway_dialog.dart

import 'package:ansvel/homeandregistratiodesign/controllers/wallet_controller.dart';
import 'package:ansvel/homeandregistratiodesign/models/wallet.dart';
import 'package:ansvel/homeandregistratiodesign/services/crypto_service.dart';
import 'package:ansvel/homeandregistratiodesign/services/wallet_api_service.dart';
import 'package:ansvel/homeandregistratiodesign/views/widgets/pin_entry_dialog.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class PaymentGatewayDialog extends StatefulWidget {
  final double amount;
  final String merchantCustomerId; // The ID of the merchant being paid
  const PaymentGatewayDialog({
    super.key,
    required this.amount,
    required this.merchantCustomerId,
  });

  @override
  State<PaymentGatewayDialog> createState() => _PaymentGatewayDialogState();
}

class _PaymentGatewayDialogState extends State<PaymentGatewayDialog> {
  Wallet? _selectedWallet;
  bool _isLoading = false;
  final _pinController = TextEditingController();

  void _onConfirmPin(String pin) {
    Navigator.pop(context); // Close the PIN entry dialog
    _processPayment(pin);
  }

  void _processPayment(String pin) async {
    if (_selectedWallet == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final cryptoService = CryptoService();
      final apiService = WalletApiService();

      final encryptedPin = await cryptoService.encrypt(pin);
      if (encryptedPin == null) throw Exception("Encryption failed.");

      final result = await apiService.processCheckout(
        fromWalletId: _selectedWallet!.id,
        toCustomerId: widget.merchantCustomerId,
        amount: widget.amount,
        encryptedPin: encryptedPin,
        provider: _selectedWallet!.provider, // FIX: Added the missing provider argument
      );

      if (mounted && result['status'] == 'success') {
        Navigator.pop(context, true); // Pop with success
      } else {
        throw Exception(result['message'] ?? 'Payment was not completed.');
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context, false); // Pop with failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted)
        setState(() {
          _isLoading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final wallets = Provider.of<WalletController>(
      context,
    ).wallets.values.toList();
    
    // Set the default selected wallet if there is only one
    if (wallets.length == 1 && _selectedWallet == null) {
      _selectedWallet = wallets.first;
    }

    return AlertDialog(
      title: const Text("Complete Your Payment"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Amount: ₦${widget.amount.toStringAsFixed(2)}",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<Wallet>(
              value: _selectedWallet,
              hint: const Text("Pay with..."),
              items: wallets.map((wallet) {
                return DropdownMenuItem<Wallet>(
                  value: wallet,
                  child: Text(
                    "${wallet.bankName} - (...${wallet.accountNumber.substring(6)})",
                  ),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedWallet = value),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            if (_selectedWallet != null) ...[
              const SizedBox(height: 24),
              const Text("Enter your 4-digit PIN to authorize"),
              const SizedBox(height: 8),
              Pinput(
                length: 4,
                controller: _pinController,
                obscureText: true,
                onCompleted: _onConfirmPin,
              ),
            ],
          ],
        ),
      ),
      actions: [
        if (_isLoading) const Center(child: CircularProgressIndicator()),
        if (!_isLoading)
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
      ],
    );
  }
}