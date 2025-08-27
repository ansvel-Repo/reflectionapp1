import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayProfileImg extends StatelessWidget {
  const DisplayProfileImg({
    Key? key,
    required this.imageUrl,
    required this.username,
  }) : super(key: key);
  final String imageUrl;
  final String username;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return imageUrl.isEmpty
        ? ProfileImgContainer(
            bgColor: colors.primary,
            child: Center(
              child: Text(
                AppHelpers.getFirstUsernameChar(username),
                style: context.textStyle.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.surface,
                ),
              ),
            ),
          )
        : ProfileImgContainer(
            child: ClipRRect(
              borderRadius: AppBorders.allSmall,
              child: DisplayImageFromUrl(imgUrl: imageUrl, fit: BoxFit.cover),
            ),
          );
  }
}
