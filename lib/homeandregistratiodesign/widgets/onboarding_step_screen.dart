import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingStepScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final int step;
  final int totalSteps;
  final Widget child;

  const OnboardingStepScreen({super.key, required this.title, required this.subtitle, required this.step, required this.totalSteps, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Step $step of $totalSteps', style: GoogleFonts.poppins(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(title, style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFF0A1128))),
            const SizedBox(height: 12),
            Text(subtitle, style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54, height: 1.5)),
            const SizedBox(height: 40),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}