// import 'package:ansvel/views/onboarding/9_selfie_liveness_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/onboarding/selfie_liveness_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SelfieLivenessScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/lottie/processing.json', width: 200, height: 200),
            const SizedBox(height: 20),
            Text(
              "Finalizing Account Setup...",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}