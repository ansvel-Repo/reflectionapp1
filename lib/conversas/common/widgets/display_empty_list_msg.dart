import 'package:ansvel/conversas/common/common.dart';
import 'package:flutter/material.dart';

class DisplayEmptyListMsg extends StatelessWidget {
  const DisplayEmptyListMsg({
    super.key,
    required this.msg,
    required this.image,
    this.imgHeight,
    this.imgWidth,
  });
  final String msg;
  final ImageProvider image;
  final double? imgHeight;
  final double? imgWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Image(image: image, height: imgHeight, width: imgWidth),
        ),
        DisplayAnimatedText(text: msg),
      ],
    );
  }
}
