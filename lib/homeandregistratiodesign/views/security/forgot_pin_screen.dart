
import 'package:ansvel/homeandregistratiodesign/controllers/auth_controller.dart';
import 'package:ansvel/homeandregistratiodesign/views/security/recovery_method_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ForgotPinScreen extends StatelessWidget {
  const ForgotPinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Transaction PIN", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Reset Your PIN",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              "To protect your account, you'll need to verify your identity before you can set a new Transaction PIN.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  // The user must be logged in to reset their transaction PIN.
                  // We use their currently logged-in email for the recovery flow.
                  if (auth.currentUser?.email != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecoveryMethodScreen(
                          email: auth.currentUser!.email,
                          isForPinReset: true, // This flag directs the flow to the PIN reset screens
                        ),
                      ),
                    );
                  } else {
                     ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(content: Text("User not found. Please log in again."), backgroundColor: Colors.red),
                     );
                  }
                },
                child: const Text("Begin Verification"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}