import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class PinEntryDialog extends StatelessWidget {
  final Function(String) onPinVerified;
  const PinEntryDialog({super.key, required this.onPinVerified});

  @override
  Widget build(BuildContext context) {
    final pinController = TextEditingController();

    return AlertDialog(
      title: const Text("Enter Transaction PIN"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Please enter your 4-digit PIN to authorize this transaction."),
          const SizedBox(height: 24),
          Pinput(
            length: 4,
            controller: pinController,
            obscureText: true,
            onCompleted: onPinVerified,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}