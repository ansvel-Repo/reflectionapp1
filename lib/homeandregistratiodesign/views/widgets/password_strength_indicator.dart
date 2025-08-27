import 'package:flutter/material.dart';

// --- FIX: Define the missing enum ---
// This enum provides the different states for password strength.
enum PasswordStrength { Empty, Weak, Normal, Strong, VeryStrong }

class PasswordStrengthIndicator extends StatelessWidget {
  final PasswordStrength strength;
  const PasswordStrengthIndicator({super.key, required this.strength});

  @override
  Widget build(BuildContext context) {
    String text = "Weak";
    Color color = Colors.red;
    double value = 0.2;

    switch (strength) {
      case PasswordStrength.Empty:
        text = "";
        value = 0.0;
        break;
      case PasswordStrength.Weak:
        text = "Weak";
        color = Colors.red;
        value = 0.25;
        break;
      case PasswordStrength.Normal:
        text = "Normal";
        color = Colors.orange;
        value = 0.5;
        break;
      case PasswordStrength.Strong:
        text = "Strong";
        color = Colors.blue;
        value = 0.75;
        break;
      case PasswordStrength.VeryStrong:
        text = "Very Strong";
        color = Colors.green;
        value = 1.0;
        break;
    }
    
    // Return an empty box if the password field is empty
    if (strength == PasswordStrength.Empty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey[300],
          color: color,
          minHeight: 6,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 4),
        Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }
}