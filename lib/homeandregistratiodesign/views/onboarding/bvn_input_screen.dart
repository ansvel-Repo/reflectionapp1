// import 'package:ansvel/controllers/onboarding_controller.dart';
// import 'package:ansvel/views/onboarding/6_address_collection_screen.dart';
// import 'package:ansvel/widgets/onboarding_step_screen.dart';
import 'package:ansvel/homeandregistratiodesign/controllers/onboarding_controller.dart';
import 'package:ansvel/homeandregistratiodesign/views/onboarding/address_collection_screen.dart';
import 'package:ansvel/homeandregistratiodesign/widgets/onboarding_step_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class BvnInputScreen extends StatelessWidget {
  const BvnInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bvnController = TextEditingController();
    final onboardingController = Provider.of<OnboardingController>(context, listen: false);

    return OnboardingStepScreen(
      title: "Secure Your Wallet",
      subtitle: "Enter your 11-digit Bank Verification Number (BVN) to link your identity.",
      step: 3, totalSteps: 6,
      child: Column(
        children: [
          TextFormField(
            controller: bvnController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Enter your BVN"),
            maxLength: 11,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                if (bvnController.text.length == 11) {
                  onboardingController.updateField(bvn: bvnController.text);
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const AddressCollectionScreen()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter a valid 11-digit BVN.")),
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