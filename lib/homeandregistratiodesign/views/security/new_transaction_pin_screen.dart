// import 'package:ansvel/services/encryption_service.dart';
// import 'package:ansvel/services/pin_api_service.dart';
import 'package:ansvel/homeandregistratiodesign/services/encryption_service.dart';
import 'package:ansvel/homeandregistratiodesign/services/pin_api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class NewTransactionPinScreen extends StatefulWidget {
  const NewTransactionPinScreen({super.key});

  @override
  State<NewTransactionPinScreen> createState() => _NewTransactionPinScreenState();
}

class _NewTransactionPinScreenState extends State<NewTransactionPinScreen> {
  final PinApiService _pinApiService = PinApiService();
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  String _firstPin = '';
  bool _isConfirming = false;

  void _handlePinSubmit(String pin) async {
    if (!_isConfirming) {
      setState(() {
        _firstPin = pin;
        _isConfirming = true;
        _pinController.clear();
        _pinFocusNode.requestFocus();
      });
    } else {
      if (pin == _firstPin) {
        final encryptedPin = EncryptionService.encrypt(pin);
        try {
          await _pinApiService.initiatePinReset(encryptedPin);
          if (mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: const Text("Request Submitted"),
                content: const Text("For your security, your Transaction PIN will be updated in 30 minutes."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    child: const Text("OK"),
                  )
                ],
              ),
            );
          }
        } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("PINs do not match. Please try again."), backgroundColor: Colors.red));
        setState(() {
          _isConfirming = false;
          _pinController.clear();
          _pinFocusNode.requestFocus();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56, height: 60,
      textStyle: const TextStyle(fontSize: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text("Set New Transaction PIN", style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isConfirming ? "Confirm New PIN" : "Create a New 4-Digit PIN",
                style: Theme.of(context).textTheme.headlineSmall
              ),
              const SizedBox(height: 32),
              Pinput(
                length: 4,
                controller: _pinController,
                focusNode: _pinFocusNode,
                obscureText: true,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                onCompleted: _handlePinSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}