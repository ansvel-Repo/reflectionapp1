// import 'package:ansvel/loginapp/src/features/core/screens/dashboard/util/constants/sizes.dart';
// import 'package:ansvel/loginapp/ecommerceappcode/utils/constants/colors.dart';
// import 'package:ansvel/loginapp/ecommerceappcode/utils/constants/sizes.dart';
import 'package:ansvel/movedforhomepage/sizes.dart';
import 'package:flutter/material.dart';

class TAdvertisementSpace extends StatelessWidget {
  const TAdvertisementSpace({
    super.key,
    this.width,
    this.height,
    required this.imageURL,
    this.applyImageRadius = true,
    this.border,
    this.backgroundColor,
    this.fit = BoxFit.contain,
    this.padding,
    this.isNetworkImage = false,
    this.onPressed,
    this.borderRadius = TSizes.md,
  });

  final double? width, height;
  final String imageURL;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color? backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
          borderRadius: applyImageRadius
              ? BorderRadius.circular(TSizes.md)
              : BorderRadius.zero,
          child: Image(
              fit: fit,
              image: isNetworkImage
                  ? NetworkImage(imageURL)
                  : AssetImage(imageURL) as ImageProvider),
        ),
      ),
    );
  }
}
