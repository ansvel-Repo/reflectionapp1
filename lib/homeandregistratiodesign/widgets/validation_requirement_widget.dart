import 'package:flutter/material.dart';

class ValidationRequirementWidget extends StatelessWidget {
  final String text;
  final bool isValid;
  const ValidationRequirementWidget({super.key, required this.text, required this.isValid});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(isValid ? Icons.check_circle : Icons.cancel, color: isValid ? Colors.green : Colors.red, size: 20),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: isValid ? Colors.grey[700] : Colors.red)),
        ],
      ),
    );
  }
}