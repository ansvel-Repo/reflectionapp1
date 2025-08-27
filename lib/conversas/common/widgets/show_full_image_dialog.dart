import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';

class ShowFullImageDialog extends StatelessWidget {
  final String imageUrl;

  const ShowFullImageDialog({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final deviceSize = context.deviceSize;
    final imgHeight = deviceSize.height * 0.6;

    return Center(
      child: Container(
        margin: AppPaddings.allLarge,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: AppBorders.allSmall,
              child: SizedBox(
                height: imgHeight,
                child: DisplayImageFromUrl(
                  imgUrl: imageUrl,
                  fit: BoxFit.cover,
                  imageWidth: deviceSize.width,
                  imageHeight: deviceSize.height,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
