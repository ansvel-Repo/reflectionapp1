// import 'package:ansvel/controllers/security_controller.dart';
// import 'package:ansvel/services/encryption_service.dart';
// import 'package:ansvel/views/onboarding/14_role_selection_screen.dart';
import 'package:ansvel/homeandregistratiodesign/controllers/security_controller.dart';
import 'package:ansvel/homeandregistratiodesign/services/encryption_service.dart';
import 'package:ansvel/homeandregistratiodesign/views/onboarding/role_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  String _firstPin = '';
  bool _isConfirming = false;

  void _handlePinSubmit(String pin) {
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
        
        final securityController = Provider.of<SecurityController>(context, listen: false);
        securityController.saveEncryptedPin(encryptedPin).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Security setup complete!"), backgroundColor: Colors.green));
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const RoleSelectionScreen()), (route) => false);
        }).catchError((e) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error saving PIN: $e"), backgroundColor: Colors.red));
        });

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
      appBar: AppBar(title: Text("Create Transaction PIN", style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isConfirming ? "Confirm Your 4-Digit PIN" : "Create a 4-Digit PIN",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                "This PIN will be used to authorize your transactions.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
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