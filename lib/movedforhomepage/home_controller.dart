import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardHomeController extends GetxController {
  static DashboardHomeController get instance => Get.find();
  final carousalCurrentIndex = 0.obs;

  void updatePageIndicator(index) {
    carousalCurrentIndex.value = index;
  }
}
