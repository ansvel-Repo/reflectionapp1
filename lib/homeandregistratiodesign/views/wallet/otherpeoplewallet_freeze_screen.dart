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
    if (freeze) {
      showDialog(
        context: context,
        builder: (context) => _buildFreezeWarningDialog(context),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => PinEntryDialog(
          onPinVerified: (pin) {
            Navigator.pop(context);
            _performWalletAction(pin, freeze: false);
          },
        ),
      );
    }
  }

  Widget _buildFreezeWarningDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Freeze Wallet Warning"),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              "You are about to freeze your wallet. This will suspend all transactions and you will be charged a fee of NGN 100,000.00 for this service.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            const Text(
              "Indemnity Clause:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "By proceeding, you agree to indemnify Ansvel from any legal action or liability arising from this action. You take full responsibility for freezing this wallet and understand that a valid court order must be provided within the specified time frame. Failure to provide a valid court order will result in a NGN 200,000.00 debit from your account. Submitting a fraudulent document will result in legal action against you.",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Text(
              "Court Order Submission Timeline:",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text("• 48 hours for a weekday freeze.\n"
                "• 120 hours for a Friday freeze.\n"
                "• 96 hours for a Saturday freeze.\n"
                "• 72 hours for a Sunday freeze.",
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Agree and Proceed', style: TextStyle(color: Colors.red)),
          onPressed: () {
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (context) => PinEntryDialog(
                onPinVerified: (pin) {
                  Navigator.pop(context);
                  _performWalletAction(pin, freeze: true);
                },
              ),
            );
          },
        ),
      ],
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
        await _apiService.freezeWalletOtherUser(
          customerId: widget.wallet.customerId!,
          provider: widget.wallet.provider,
          encryptedPin: encryptedPin,
        );
        _status = 'FROZEN';
      } else {
        await _apiService.unfreezeWalletOtherUser(
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