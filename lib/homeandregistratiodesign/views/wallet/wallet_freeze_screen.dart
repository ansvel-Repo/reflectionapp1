// lib/homeandregistratiodesign/views/wallet/wallet_freeze_screen.dart

import 'package:ansvel/homeandregistratiodesign/models/wallet.dart';
import 'package:ansvel/homeandregistratiodesign/services/crypto_service.dart';
import 'package:ansvel/homeandregistratiodesign/services/wallet_api_service.dart';
import 'package:ansvel/homeandregistratiodesign/views/widgets/pin_entry_dialog.dart';
import 'package:ansvel/homeandregistratiodesign/views/widgets/result_dialog.dart';
import 'package:ansvel/homeandregistratiodesign/widgets/buttonloadingwidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:ansvel/homeandregistratiodesign/views/widgets/buttonloadingwidget.dart';

class WalletFreezeScreen extends StatefulWidget {
  final Wallet wallet;
  const WalletFreezeScreen({super.key, required this.wallet});

  @override
  State<WalletFreezeScreen> createState() => _WalletFreezeScreenState();
}

class _WalletFreezeScreenState extends State<WalletFreezeScreen> {
  final _apiService = WalletApiService();
  final _cryptoService = CryptoService();
  bool _isProcessing = false;
  String? _status; // To track freeze/unfreeze status

  @override
  void initState() {
    super.initState();
    _status = widget.wallet.status;
  }

  Future<void> _processAction({required bool freeze}) async {
    showDialog(
      context: context,
      builder: (context) => PinEntryDialog(
        onPinVerified: (pin) {
          Navigator.pop(context); // Close the PIN dialog
          _performWalletAction(pin, freeze: freeze);
        },
      ),
    );
  }

  Future<void> _performWalletAction(String pin, {required bool freeze}) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final encryptedPin = await _cryptoService.encrypt(pin);
      if (encryptedPin == null) {
        throw Exception("Encryption failed. Please try again.");
      }

      if (freeze) {
        await _apiService.freezeWallet(
          customerId: widget.wallet.customerId!,
          provider: widget.wallet.provider,
          encryptedPin: encryptedPin,
        );
        _status = 'FROZEN';
      } else {
        await _apiService.unfreezeWallet(
          customerId: widget.wallet.customerId!,
          provider: widget.wallet.provider,
          encryptedPin: encryptedPin,
        );
        _status = 'ACTIVE';
      }

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => ResultDialog(
            isSuccess: true,
            title: freeze ? "Wallet Frozen" : "Wallet Unfrozen",
            message:
                "Your wallet has been successfully ${_status!.toLowerCase()}.",
            onDone: () => Navigator.of(context).pop(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => ResultDialog(
            isSuccess: false,
            title: "Action Failed",
            message: e.toString().replaceFirst("Exception: ", ""),
            onDone: () => Navigator.of(context).pop(),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFrozen = _status == 'FROZEN';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Wallet Status: ${isFrozen ? 'Frozen' : 'Active'}",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Wallet Details",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                title: Text(widget.wallet.accountName!),
                subtitle: Text(widget.wallet.accountNumber),
                trailing: Text(
                  _status!,
                  style: TextStyle(
                    color: isFrozen ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Manage Wallet Status",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              isFrozen
                  ? "Your wallet is currently frozen. No transactions can be made until it is unfrozen."
                  : "Your wallet is active. You can freeze it to temporarily suspend all transactions.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: isFrozen
                  ? FilledButton(
                      onPressed: _isProcessing
                          ? null
                          : () => _processAction(freeze: false),
                      child: _isProcessing
                          ? const ButtonLoadingWidget()
                          : const Text("Unfreeze Wallet"),
                    )
                  : OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        foregroundColor: Colors.red,
                      ),
                      onPressed: _isProcessing
                          ? null
                          : () => _processAction(freeze: true),
                      child: _isProcessing
                          ? const ButtonLoadingWidget()
                          : const Text("Freeze Wallet"),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}