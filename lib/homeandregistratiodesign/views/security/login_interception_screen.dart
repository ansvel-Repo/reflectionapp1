// import 'package:ansvel/controllers/security_controller.dart';
import 'package:ansvel/homeandregistratiodesign/controllers/security_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginInterceptionScreen extends StatelessWidget {
  final String email;
  const LoginInterceptionScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final securityController = SecurityController();

    void _cancelRequest() {
      securityController.cancelPasswordReset(email);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset cancelled. You can now log in with your old password."), backgroundColor: Colors.green),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.security_update_warning_rounded, size: 80, color: Colors.orange),
              const SizedBox(height: 32),
              Text(
                "Password Reset in Progress",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                "A request to reset your password was made. For your security, this change will take effect in 30 minutes.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 48),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: _cancelRequest,
                icon: const Icon(Icons.cancel),
                label: const Text("I Didn't Request This - Cancel"),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text("Dismiss"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}