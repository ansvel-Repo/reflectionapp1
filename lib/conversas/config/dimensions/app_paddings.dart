import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@immutable
class AppPaddings {
  const AppPaddings._();
  static final allLargest = const EdgeInsets.all(50.0).w;
  static final allLarger = const EdgeInsets.all(30.0).w;
  static final allLarge = const EdgeInsets.all(20.0).w;
  static final allMedium = const EdgeInsets.all(16.0).w;
  static final allSmall = const EdgeInsets.all(10.0).w;
  static final allSmaller = const EdgeInsets.all(8.0).w;
  static final allSmallest = const EdgeInsets.all(6.0).w;

  //stroy
  static final storyItem = const EdgeInsets.all(4.0).w;
  static final indicatorPadding = EdgeInsets.only(top: 44.h, left: 8.w);
  static final storyCloseBtn = EdgeInsets.only(top: 46.h);
  static final leftMedium = const EdgeInsets.only(left: 16).w;
  static final storyUserName = EdgeInsets.only(top: 54.h, left: 8.w);

  static final v16 = const EdgeInsets.symmetric(vertical: 16).h;
  static final h16 = const EdgeInsets.symmetric(horizontal: 16).w;

  //
  static final bottomLarge = const EdgeInsets.only(bottom: 100).h;
}
