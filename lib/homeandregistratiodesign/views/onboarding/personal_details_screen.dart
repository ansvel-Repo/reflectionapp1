// import 'package:ansvel/controllers/onboarding_controller.dart';
// import 'package:ansvel/views/onboarding/5_bvn_input_screen.dart';
// import 'package:ansvel/widgets/onboarding_step_screen.dart';
import 'package:ansvel/homeandregistratiodesign/controllers/onboarding_controller.dart';
import 'package:ansvel/homeandregistratiodesign/views/onboarding/bvn_input_screen.dart';
import 'package:ansvel/homeandregistratiodesign/widgets/onboarding_step_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _gender;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingController = Provider.of<OnboardingController>(context, listen: false);

    void _onContinue() {
      if (_formKey.currentState!.validate()) {
        // Save all personal details to the controller
        onboardingController.updateField(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          dateOfBirth: _dobController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          gender: _gender,
        );
        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const BvnInputScreen()));
      }
    }

    return OnboardingStepScreen(
      title: "Personal Details",
      subtitle: "Please provide your information as it appears on your official documents.",
      step: 2,
      totalSteps: 6,
      child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            TextFormField(controller: _firstNameController, decoration: const InputDecoration(labelText: "First Name"), validator: (v) => v!.isEmpty ? 'Required' : null),
            const SizedBox(height: 16),
            TextFormField(controller: _lastNameController, decoration: const InputDecoration(labelText: "Last Name"), validator: (v) => v!.isEmpty ? 'Required' : null),
            const SizedBox(height: 16),
            TextFormField(controller: _dobController, decoration: const InputDecoration(labelText: "Date of Birth (YYYY-MM-DD)"), validator: (v) => v!.isEmpty ? 'Required' : null),
            const SizedBox(height: 16),
            TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: "Phone Number"), keyboardType: TextInputType.phone, validator: (v) => v!.isEmpty ? 'Required' : null),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _gender,
              hint: const Text("Select Gender"),
              items: ["Male", "Female"].map((label) => DropdownMenuItem(value: label, child: Text(label))).toList(),
              onChanged: (value) => setState(() => _gender = value),
              validator: (v) => v == null ? 'Please select a gender' : null,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _onContinue,
                child: const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}