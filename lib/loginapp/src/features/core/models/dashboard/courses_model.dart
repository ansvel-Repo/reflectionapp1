import 'package:ansvel/homeandregistratiodesign/views/homepagewidgets/expansionprogramform.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:ansvel/loginapp/src/constants/image_strings.dart';
// import 'package:ansvel/loginapp/src/features/core/screens/dashboard/expansionprogram/expansionprogramform.dart';

class DashboardTopCoursesModel {
  final String title;
  final String heading;
  final String subHeading;
  final String image;
  final VoidCallback? onPress;

  DashboardTopCoursesModel(
      this.title, this.heading, this.subHeading, this.image, this.onPress);

  static List<DashboardTopCoursesModel> list = [
    DashboardTopCoursesModel(
        "Developer Network",
        "Are you a Software Engineer?",
        "Join our developer network. \nClick Here.",
        tTopCourseImage1, () {
      Get.to(() => ExpansionProgramForm());
    }),
    DashboardTopCoursesModel(
        "Business Developer",
        "Do you have Business Ideas?",
        "Let's develop the new solution while you sell it. \nClick Here.",
        tTopCourseImage1, () {
      Get.to(() => ExpansionProgramForm());
    }),
    DashboardTopCoursesModel(
        "Partnership Driver",
        "Join Our Expansion Drive",
        "Can You Champion Our Expansion Through Partnerships Locally and International? Speak to us.",
        tTopCourseImage1, () {
      Get.to(() => ExpansionProgramForm());
    }),
  ];
}
