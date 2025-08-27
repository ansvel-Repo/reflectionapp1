// import 'package:ansvel/loginapp/ecommerceappcode/utils/constants/sizes.dart';
// import 'package:ansvel/loginapp/ecommerceappcode/utils/device/device_utility.dart';
// import 'package:ansvel/loginapp/ecommerceappcode/utils/constants/colors.dart';
import 'package:ansvel/homeandregistratiodesign/util/constants/colors.dart';
import 'package:ansvel/homeandregistratiodesign/util/device/device_utility.dart';
import 'package:ansvel/homeandregistratiodesign/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TAppBarCommerce extends StatelessWidget implements PreferredSizeWidget {
  const TAppBarCommerce({
    super.key,
    this.title,
    this.showBackArrow = false,
    this.leadingIcon,
    this.actions,
    this.leadingOnPressed,
  });

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: TSizes.md),
      child: AppBar(
        backgroundColor: TColors.primary.withOpacity(0.1),
        automaticallyImplyLeading: false,
        leading: showBackArrow
            ? IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Iconsax.arrow_left),
              )
            : leadingIcon != null
                ? IconButton(
                    onPressed: leadingOnPressed, icon: Icon(leadingIcon))
                : null,
        title: title,
        actions: actions,
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}
