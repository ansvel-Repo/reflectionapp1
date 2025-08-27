// import 'package:ansvel/views/security/recover_with_pin_screen.dart';
// import 'package:ansvel/views/security/recover_with_questions_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/security/recover_with_pin_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/security/recover_with_questions_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

class RecoveryMethodScreen extends StatelessWidget {
  final String email;
  final bool isForPinReset; // Flag to determine the next screen
  const RecoveryMethodScreen({super.key, required this.email, this.isForPinReset = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Recovery Method", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "How would you like to verify your identity?",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            _RecoveryCard(
              icon: FontAwesomeIcons.solidCircleQuestion,
              title: "Answer Security Questions",
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(type: PageTransitionType.rightToLeft, child: RecoverWithQuestionsScreen(email: email, isForPinReset: isForPinReset)),
                );
              },
            ),
            const SizedBox(height: 20),
            _RecoveryCard(
              icon: FontAwesomeIcons.hashtag,
              title: "Use 6-Digit PIN",
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(type: PageTransitionType.rightToLeft, child: RecoverWithPinScreen(email: email, isForPinReset: isForPinReset)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RecoveryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _RecoveryCard({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 20),
              Expanded(
                child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}