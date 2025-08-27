// import 'package:ansvel/views/onboarding/10_security_check_screen.dart';
// import 'package:ansvel/widgets/onboarding_step_screen.dart';
import 'package:ansvel/homeandregistratiodesign/views/onboarding/security_check_screen.dart';
import 'package:ansvel/homeandregistratiodesign/widgets/onboarding_step_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

class SelfieLivenessScreen extends StatelessWidget {
  const SelfieLivenessScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return OnboardingStepScreen(
      title: "Confirm Your Liveness",
      subtitle: "Take a quick selfie. This helps us ensure it's really you.",
      step: 5,
      totalSteps: 6,
      child: Column(
        children: [
          Expanded(
              child: Center(
                  child: Icon(
            FontAwesomeIcons.cameraRetro,
            size: 100,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ))),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const SecurityCheckScreen())),
              child: const Text("Open Camera"),
            ),
          )
        ],
      ),
    );
  }
}