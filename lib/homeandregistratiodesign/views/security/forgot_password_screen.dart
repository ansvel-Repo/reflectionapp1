import 'package:ansvel/homeandregistratiodesign/views/security/recovery_method_screen.dart';
import 'package:ansvel/homeandregistratiodesign/widgets/validation_requirement_widget.dart';
// import 'package:ansvel/views/security/recovery_method_screen.dart';
// import 'package:ansvel/widgets/validation_requirement_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _usernameController = TextEditingController();
  bool _isUsernameLengthValid = false;
  bool _usernameHasNoSpaces = false;
  bool _isUsernameCharsValid = false;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_validateUsername);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _validateUsername() {
    final username = _usernameController.text;
    final emailString = "$username@ansveluseremail.com";
    final validCharsRegex = RegExp(r"^[a-zA-Z0-9._-]+$");
    final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    setState(() {
      _isUsernameLengthValid = username.length >= 6;
      _usernameHasNoSpaces = !username.contains(' ');
      _isUsernameCharsValid = validCharsRegex.hasMatch(username) && emailRegex.hasMatch(emailString);
    });
  }

  bool get isFormValid => _isUsernameLengthValid && _usernameHasNoSpaces && _isUsernameCharsValid;

  void _proceedToRecovery() {
    if (isFormValid) {
      final email = "${_usernameController.text.trim()}@ansveluseremail.com";
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: RecoveryMethodScreen(email: email),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter your username",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "We'll help you find your account.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _usernameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: "Username or Phone Number",
              ),
            ),
            const SizedBox(height: 16),
            ValidationRequirementWidget(text: "At least 6 characters long", isValid: _isUsernameLengthValid),
            ValidationRequirementWidget(text: "No spaces allowed", isValid: _usernameHasNoSpaces),
            ValidationRequirementWidget(text: "Only letters, numbers, '.', '_', '-' are allowed", isValid: _isUsernameCharsValid),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: isFormValid ? _proceedToRecovery : null,
                child: const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}