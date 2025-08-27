// import 'package:ansvel/views/home_page.dart';
// import 'package:ansvel/views/onboarding/12_security_question_setup_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/home_page.dart';
import 'package:ansvel/homeandregistratiodesign/views/onboarding/security_question_setup_screen.dart';
// import 'package:ansvel/homeandregistratiodesign/views/security/2_security_question_setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SecuritySetupIntroScreen extends StatelessWidget {
  const SecuritySetupIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(FontAwesomeIcons.shieldHalved, size: 80, color: Colors.deepPurpleAccent),
              const SizedBox(height: 32),
              Text(
                "Secure Your Account",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                "Set up your recovery options now to easily regain access to your account if you forget your password.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 48),
              FilledButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SecurityQuestionSetupScreen()));
                },
                icon: const Icon(FontAwesomeIcons.solidCircleQuestion),
                label: const Text("Set Up Security Questions"),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (route) => false,
                  );
                },
                child: const Text("Skip For Now"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}