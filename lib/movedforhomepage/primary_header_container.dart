// import 'package:ansvel/loginapp/src/features/core/screens/dashboard/util/common/widgets/custome_shapes/containers/circular_container.dart';
// import 'package:ansvel/loginapp/src/features/core/screens/dashboard/util/common/widgets/custome_shapes/curved_edges/curved_edges_widget.dart';
// import 'package:ansvel/loginapp/src/features/core/screens/dashboard/util/constants/colors.dart';
// import 'package:ansvel/loginapp/ecommerceappcode/utils/common/widgets/custome_shapes/containers/circular_container.dart';
// import 'package:ansvel/loginapp/ecommerceappcode/utils/common/widgets/custome_shapes/curved_edges/curved_edges_widget.dart';
// import 'package:ansvel/loginapp/ecommerceappcode/utils/constants/colors.dart';
import 'package:ansvel/homeandregistratiodesign/util/constants/colors.dart';
import 'package:ansvel/homeandregistratiodesign/widgets/custome_shapes/containers/circular_container.dart';
import 'package:ansvel/homeandregistratiodesign/widgets/custome_shapes/curved_edges/curved_edges_widget.dart';
import 'package:flutter/material.dart';

class TPrimaryHeaderContainer extends StatelessWidget {
  const TPrimaryHeaderContainer({
    super.key,
    required this.child,
    this.height = 500,
  });

  final Widget child;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return TCurvedEdgesWidget(
      child: SizedBox(
        height: height,
        child: Container(
          color: TColors.primary,
          padding: const EdgeInsets.only(bottom: 0),
          child: Stack(
            children: [
              ///  -- Background Custome Shapes
              Positioned(
                top: -150,
                right: -250,
                child: TCircularContainer(
                  backgroundColor: TColors.textWhite.withOpacity(0.1),
                ),
              ),
              Positioned(
                top: 100,
                right: -300,
                child: TCircularContainer(
                  backgroundColor: TColors.textWhite.withOpacity(0.1),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
