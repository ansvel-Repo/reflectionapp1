import 'package:cached_network_image/cached_network_image.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class DisplayImageFromUrl extends StatelessWidget {
  const DisplayImageFromUrl({
    super.key,
    required this.imgUrl,
    this.fit,
    this.imageHeight,
    this.imageWidth,
    this.isCircleAvatar = false,
    this.maxRadius,
  });

  final String imgUrl;
  final BoxFit? fit;
  final double? imageHeight;
  final double? imageWidth;
  final double? maxRadius;
  final bool isCircleAvatar;

  @override
  Widget build(BuildContext context) {
    final parentWidgetSize = context.deviceSize;
    final colors = context.colorScheme;

    return imgUrl.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: imgUrl,
            placeholder: (context, url) => isCircleAvatar
                ? CircleAvatar(
                    backgroundColor: colors.inversePrimary,
                    maxRadius: maxRadius,
                  )
                : ProfileImgContainer(
                    child: Container(
                      width: imageWidth ?? parentWidgetSize.width,
                      height: imageHeight,
                      color: colors.inversePrimary,
                    ),
                  ),
            errorWidget: (context, url, error) => Center(
              child: isCircleAvatar
                  ? CircleAvatar(
                      maxRadius: maxRadius,
                      child: Icon(Iconsax.user, color: colors.background),
                    )
                  : Icon(Iconsax.gallery, color: colors.background),
            ),
            imageBuilder: (context, imageProvider) => isCircleAvatar
                ? CircleAvatar(
                    backgroundImage: imageProvider,
                    maxRadius: maxRadius,
                  )
                : Image(
                    image: imageProvider,
                    fit: fit ?? BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    width: imageWidth ?? parentWidgetSize.width,
                    height: imageHeight ?? AppSizes.small,
                  ),
          )
        : isCircleAvatar
        ? CircleAvatar(
            backgroundColor: colors.primary,
            maxRadius: maxRadius,
            child: Center(child: Icon(Iconsax.user, color: colors.background)),
          )
        : Icon(Iconsax.gallery, color: colors.background);
  }
}
