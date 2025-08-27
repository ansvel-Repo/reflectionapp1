// import 'package:ansvel/controllers/onboarding_controller.dart';
import 'package:ansvel/homeandregistratiodesign/controllers/onboarding_controller.dart';
import 'package:ansvel/homeandregistratiodesign/views/onboarding/personal_details_screen.dart';
import 'package:ansvel/homeandregistratiodesign/widgets/onboarding_step_screen.dart';
// import 'package:ansvel/views/onboarding/4_personal_details_screen.dart';
// import 'package:ansvel/widgets/onboarding_step_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class NinInputScreen extends StatelessWidget {
  const NinInputScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final ninController = TextEditingController();
    final onboardingController = Provider.of<OnboardingController>(context, listen: false);

    return OnboardingStepScreen(
      title: "Verify Your Identity",
      subtitle: "Please enter your 11-digit National Identification Number (NIN).",
      step: 1, totalSteps: 6,
      child: Column(
        children: [
          TextFormField(
            controller: ninController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Enter your NIN"),
            maxLength: 11,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                if (ninController.text.length == 11) {
                  // Save the NIN to the controller and proceed
                  onboardingController.updateField(nin: ninController.text);
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const PersonalDetailsScreen()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter a valid 11-digit NIN.")),
                  );
                }
              },
              child: const Text("Continue"),
            ),
          )
        ],
      ),
    );
  }
}