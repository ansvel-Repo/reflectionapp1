// import 'package:ansvel/controllers/security_controller.dart';
// import 'package:ansvel/views/onboarding/2_create_account_screen.dart'; // Re-using enum
// import 'package:ansvel/widgets/password_strength_indicator.dart';
import 'package:ansvel/homeandregistratiodesign/controllers/security_controller.dart';
import 'package:ansvel/homeandregistratiodesign/views/widgets/password_strength_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewPasswordScreen extends StatefulWidget {
  final String email;
  const NewPasswordScreen({super.key, required this.email});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _securityController = SecurityController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  PasswordStrength _passwordStrength = PasswordStrength.Empty;
  bool _passwordsMatch = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      _passwordsMatch = password.isNotEmpty && password == _confirmPasswordController.text;
      if (password.isEmpty) {
        _passwordStrength = PasswordStrength.Empty;
        return;
      }
      int score = 0;
      if (password.length >= 8) score++;
      if (RegExp(r'[A-Z]').hasMatch(password)) score++;
      if (RegExp(r'[a-z]').hasMatch(password)) score++;
      if (RegExp(r'[0-9]').hasMatch(password)) score++;
      if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score++;

      if (score < 2 || password.length < 8) {
        _passwordStrength = PasswordStrength.Weak;
      } else if (score == 2) {
        _passwordStrength = PasswordStrength.Normal;
      } else if (score == 3) {
        _passwordStrength = PasswordStrength.Strong;
      } else if (score >= 4) {
        _passwordStrength = PasswordStrength.VeryStrong;
      }
    });
  }

  bool get _isFormValid => _passwordsMatch && _passwordStrength != PasswordStrength.Weak;

  void _submitNewPassword() {
    if (_isFormValid) {
      _securityController.initiatePasswordReset(widget.email, _passwordController.text);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("Request Submitted"),
          content: const Text(
            "For your security, your password will be updated in 30 minutes. We've sent you an SMS. If you didn't request this change, please cancel it immediately upon login.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Set New Password", style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text("Create a new, strong password for your account.", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 32),
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: "New Password",
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                ),
              ),
            ),
            const SizedBox(height: 12),
            PasswordStrengthIndicator(strength: _passwordStrength),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: !_isConfirmPasswordVisible,
              decoration: InputDecoration(
                labelText: "Confirm New Password",
                errorText: (_confirmPasswordController.text.isNotEmpty && !_passwordsMatch) ? "Passwords do not match" : null,
                suffixIcon: IconButton(
                  icon: Icon(_isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isFormValid ? _submitNewPassword : null,
                child: const Text("Reset Password"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}