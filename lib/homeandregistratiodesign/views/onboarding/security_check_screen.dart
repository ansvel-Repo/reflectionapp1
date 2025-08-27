// import 'package:ansvel/views/onboarding/11_security_setup_intro_screen.dart';
// import 'package:ansvel/widgets/onboarding_step_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/onboarding/security_setup_intro_screen.dart';
// import 'package:ansvel/homeandregistratiodesign/views/security/1_security_setup_intro_screen.dart';
import 'package:ansvel/homeandregistratiodesign/widgets/onboarding_step_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class SecurityCheckScreen extends StatefulWidget {
  const SecurityCheckScreen({super.key});
  @override
  State<SecurityCheckScreen> createState() => _SecurityCheckScreenState();
}

class _SecurityCheckScreenState extends State<SecurityCheckScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 7), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: const SecuritySetupIntroScreen()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingStepScreen(
      title: "Finalizing Your Account",
      subtitle: "We're running final security checks. This will only take a moment.",
      step: 6,
      totalSteps: 6,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SecurityCheckItem(
              text: "Screening against Blacklists...",
              delay: Duration(seconds: 1)),
          SizedBox(height: 30),
          SecurityCheckItem(
              text: "Checking PEP lists...", delay: Duration(seconds: 3)),
          SizedBox(height: 30),
          SecurityCheckItem(
              text: "Scanning for Adverse Media...",
              delay: Duration(seconds: 5)),
        ],
      ),
    );
  }
}

class SecurityCheckItem extends StatefulWidget {
  final String text;
  final Duration delay;
  const SecurityCheckItem({super.key, required this.text, required this.delay});
  @override
  State<SecurityCheckItem> createState() => _SecurityCheckItemState();
}

class _SecurityCheckItemState extends State<SecurityCheckItem> {
  bool _isChecking = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () => {if (mounted) setState(() => _isChecking = false)});
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: _isChecking
              ? SizedBox(
                  key: const ValueKey('loader'),
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Theme.of(context).colorScheme.primary))
              : const Icon(
                  key: ValueKey('check'),
                  FontAwesomeIcons.solidCircleCheck,
                  color: Colors.green,
                  size: 24)),
      const SizedBox(width: 20),
      Expanded(
          child: Text(widget.text,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87)))
    ]);
  }
}