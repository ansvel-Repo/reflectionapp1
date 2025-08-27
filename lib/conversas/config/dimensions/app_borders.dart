import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@immutable
class AppBorders {
  const AppBorders._();
  static final allLargest = BorderRadius.circular(50.r);
  static final allLarger = BorderRadius.circular(30.r);
  static final allLarge = BorderRadius.circular(20.r);
  static final allMedium = BorderRadius.circular(16.r);
  static final allSmall = BorderRadius.circular(12.r);
  static final allSmallest = BorderRadius.circular(8.r);

  //
  static final bubbleRadius = Radius.circular(15.0.r);
  static const zero = Radius.circular(0);
}
