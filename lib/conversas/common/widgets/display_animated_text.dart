import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayAnimatedText extends StatelessWidget {
  const DisplayAnimatedText({Key? key, required this.text, this.textStyle})
    : super(key: key);
  final String text;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedTextKit(
        animatedTexts: [
          TyperAnimatedText(
            text,
            textStyle: textStyle ?? context.textStyle.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
