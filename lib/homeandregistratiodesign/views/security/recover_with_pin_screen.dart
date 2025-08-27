
import 'package:ansvel/homeandregistratiodesign/controllers/security_controller.dart';
import 'package:ansvel/homeandregistratiodesign/views/security/new_password_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/security/new_transaction_pin_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pinput/pinput.dart';

class RecoverWithPinScreen extends StatefulWidget {
  final String email;
  final bool isForPinReset;
  const RecoverWithPinScreen({super.key, required this.email, this.isForPinReset = false});

  @override
  State<RecoverWithPinScreen> createState() => _RecoverWithPinScreenState();
}

class _RecoverWithPinScreenState extends State<RecoverWithPinScreen> {
  final securityController = SecurityController();
  final pinController = TextEditingController();
  bool _isLoading = false;

  void _verifyPin(String pin) async {
    setState(() { _isLoading = true; });

    final isCorrect = await securityController.verifyPin(widget.email, pin);
    
    if (!mounted) return;

    setState(() { _isLoading = false; });

    if (isCorrect) {
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          // Navigate to the correct screen based on the flag
          child: widget.isForPinReset
              ? const NewTransactionPinScreen()
              : NewPasswordScreen(email: widget.email),
        ),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Incorrect PIN. Please try again."), backgroundColor: Colors.red),
      );
      pinController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(fontSize: 22, color: Colors.black),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text("Enter Your 6-Digit PIN", style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Enter your 6-Digit recovery PIN",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Pinput(
                length: 6,
                controller: pinController,
                enabled: !_isLoading,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                onCompleted: _verifyPin,
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}