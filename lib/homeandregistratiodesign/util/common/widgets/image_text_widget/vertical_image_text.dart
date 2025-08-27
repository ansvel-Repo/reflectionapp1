import 'package:ansvel/homeandregistratiodesign/util/colors.dart';
import 'package:ansvel/homeandregistratiodesign/util/constants/sizes.dart';
import 'package:ansvel/homeandregistratiodesign/util/helpers/helper_functions.dart';
// import 'package:ansvel/loginapp/ecommerceappcode/utils/constants/colors.dart';
// import 'package:ansvel/loginapp/ecommerceappcode/utils/constants/sizes.dart';
// import 'package:ansvel/loginapp/ecommerceappcode/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class TVerticalImageText extends StatelessWidget {
  const TVerticalImageText({
    super.key,
    required this.icon,
    required this.title,
    this.textColor = TColors.white,
    this.backgroundColor = TColors.white,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final Color textColor;
  final Color? backgroundColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: TSizes.spaceBtwItems),
        child: Column(
          children: [
            Container(
              width: 65,
              height: 65,
              padding: const EdgeInsets.all(TSizes.sm),
              decoration: BoxDecoration(
                color: backgroundColor ?? (dark ? TColors.dark : TColors.white),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                // child: Image(
                //   image: AssetImage(image),
                //   fit: BoxFit.cover,
                //   color: dark ? TColors.white : TColors.black,
                // ),
                child: Icon(
                  icon,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems / 4,
            ),
            SizedBox(
              width: 75,
              child: Center(
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .apply(color: textColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
