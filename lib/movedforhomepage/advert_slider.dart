import 'package:ansvel/homeandregistratiodesign/util/constants/colors.dart';
import 'package:ansvel/homeandregistratiodesign/util/constants/image_strings.dart';
import 'package:ansvel/homeandregistratiodesign/widgets/custome_shapes/containers/circular_container.dart';
import 'package:ansvel/movedforhomepage/advert_widget.dart';
import 'package:ansvel/movedforhomepage/home_controller.dart';
import 'package:ansvel/movedforhomepage/sizes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:ansvel/loginapp/src/features/core/screens/dashboard/controller/home_controller.dart';
// import 'package:ansvel/loginapp/src/features/core/screens/dashboard/util/common/widgets/advert_widget/advert_widget.dart';
// import 'package:ansvel/loginapp/src/features/core/screens/dashboard/util/common/widgets/custome_shapes/containers/circular_container.dart';
// import 'package:ansvel/loginapp/src/features/core/screens/dashboard/util/constants/sizes.dart';
// import 'package:ansvel/loginapp/constants/colors.dart';
// import 'package:ansvel/loginapp/src/features/core/screens/dashboard/util/constants/image_strings.dart';

class TAdvertSlider extends StatefulWidget {
  const TAdvertSlider({super.key, required List<String> banners});

  @override
  _TAdvertSliderState createState() => _TAdvertSliderState();
}

class _TAdvertSliderState extends State<TAdvertSlider> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<String> banners = <String>[].obs;
  RxList<String> webaddresses = <String>[].obs;

  @override
  void initState() {
    super.initState();
    _fetchApprovedAdverts();
  }

  Future<void> _fetchApprovedAdverts() async {
    try {
      QuerySnapshot query = await _firestore
          .collection('advertItems')
          .where('adminApproved', isEqualTo: true)
          .where('remainingvaliditydate', isGreaterThan: 0)
          .get();

      if (query.docs.isNotEmpty) {
        banners.value =
            query.docs.map((doc) => doc['banners'] as String).toList();
        webaddresses.value =
            query.docs.map((doc) => doc['webaddress'] as String).toList();
      } else {
        // Offline Fallback
        banners.value = [
          TImages.promoBanner1,
          TImages.promoBanner2,
          TImages.promoBanner3,
          // TImages.promoBanner4,
          // TImages.promoBanner5,
          // TImages.promoBanner6,
          // TImages.promoBanner7,
          // TImages.promoBanner8,
          // TImages.promoBanner9,
          // TImages.promoBanner10,
          // TImages.promoBanner11,
        ];
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch adverts: $e");
      banners.value = [
        TImages.promoBanner1,
        TImages.promoBanner2,
        TImages.promoBanner3,
        // TImages.promoBanner4,
        // TImages.promoBanner5,
        // TImages.promoBanner6,
        // TImages.promoBanner7,
        // TImages.promoBanner8,
        // TImages.promoBanner9,
        // TImages.promoBanner10,
        // TImages.promoBanner11,
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardHomeController());
    return Column(
      children: [
        Obx(() => CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                viewportFraction: 1,
                onPageChanged: (index, _) =>
                    controller.updatePageIndicator(index),
              ),
              items: banners
                  .map((url) => TAdvertisementSpace(imageURL: url))
                  .toList(),
            )),
        const SizedBox(height: TSizes.spaceBtwItems),
        Center(
          child: Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < banners.length; i++)
                  TCircularContainer(
                    width: 20,
                    height: 4,
                    margin: const EdgeInsets.only(right: 10),
                    backgroundColor: controller.carousalCurrentIndex.value == i
                        ? TColors.primary
                        : TColors.grey,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
