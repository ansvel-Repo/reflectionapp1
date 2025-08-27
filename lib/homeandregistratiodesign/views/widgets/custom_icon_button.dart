// lib/widgets/custom_icon_button.dart
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color backgroundColor;
  final String title;
  final IconData icon;
  final Color textColor;
  final double width;

  const CustomIconButton({
    super.key,
    required this.onTap,
    required this.backgroundColor,
    required this.title,
    required this.icon,
    required this.textColor,
    this.width = 180,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: width,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: textColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}