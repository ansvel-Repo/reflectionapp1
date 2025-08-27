import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ResultDialog extends StatelessWidget {
  final bool isSuccess;
  final String title;
  final String message;
  final Map<String, String>? details;
  final VoidCallback onDone;

  const ResultDialog({
    super.key,
    required this.isSuccess,
    required this.title,
    required this.message,
    this.details,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            isSuccess ? 'assets/lottie/success.json' : 'assets/lottie/error.json', // Add an error lottie file
            height: 100,
            repeat: false,
          ),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          if (details != null) ...[
            const Divider(height: 24),
            ...details!.entries.map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(entry.key, style: const TextStyle(color: Colors.grey)),
                  Expanded(
                    child: Text(
                      entry.value, 
                      textAlign: TextAlign.end,
                      style: const TextStyle(fontWeight: FontWeight.bold)
                    ),
                  ),
                ],
              ),
            )),
          ]
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: FilledButton(onPressed: onDone, child: const Text("Done")),
        ),
      ],
    );
  }
}