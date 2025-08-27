import 'dart:math';
// import 'package:ansvel/controllers/auth_controller.dart';
// import 'package:ansvel/models/app_user.dart';
// import 'package:ansvel/views/home_page.dart';
// import 'package:ansvel/views/onboarding/complete_kyc_screen.dart';
import 'package:ansvel/homeandregistratiodesign/controllers/auth_controller.dart';
import 'package:ansvel/homeandregistratiodesign/models/app_user.dart';
import 'package:ansvel/homeandregistratiodesign/views/home_page.dart';
import 'package:ansvel/homeandregistratiodesign/views/onboarding/complete_kyc_screen.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Tier2ActivationScreen extends StatefulWidget {
  const Tier2ActivationScreen({super.key});
  @override
  State<Tier2ActivationScreen> createState() => _Tier2ActivationScreenState();
}

class _Tier2ActivationScreenState extends State<Tier2ActivationScreen> {
  late ConfettiController _confettiController;
  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
    WidgetsBinding.instance.addPostFrameCallback((_) => _confettiController.play());
  }
  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthController>(context).currentUser;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(FontAwesomeIcons.award, color: Theme.of(context).colorScheme.primary, size: 100),
                const SizedBox(height: 30),
                Text("Congratulations!", textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text("Your Tier 2 Account is Active!", textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 18, color: Colors.black54)),
                const SizedBox(height: 50),
                FilledButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => false,
                    );
                  },
                  child: Text("Start Transacting Now", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                ),
                if (user != null && user.role != UserRole.Admin) ...[
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    icon: const Icon(FontAwesomeIcons.circleArrowUp),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CompleteKYCScreen()));
                    },
                    label: Text("Upgrade to Tier 3", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  ),
                ]
              ],
            ),
          ),
        ),
        ConfettiWidget(confettiController: _confettiController, blastDirection: -pi / 2, emissionFrequency: 0.05, numberOfParticles: 20, gravity: 0.1, shouldLoop: false, colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple])
      ],
    );
  }
}