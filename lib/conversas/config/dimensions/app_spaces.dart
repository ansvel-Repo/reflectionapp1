import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@immutable
class AppSpaces {
  const AppSpaces._();

  //VerticalSpace
  static final vLargest = SizedBox(height: 100.h);
  static final vLarger = SizedBox(height: 60.h);
  static final vLarge = SizedBox(height: 30.h);
  static final vMedium = SizedBox(height: 20.h);
  static final vSmall = SizedBox(height: 16.h);
  static final vSmaller = SizedBox(height: 10.h);
  static final vSmallest = SizedBox(height: 8.h);

  //Horizontal space
  static final hLargest = SizedBox(width: 30.0.w);
  static final hLarger = SizedBox(width: 24.0.w);
  static final hLarge = SizedBox(width: 20.0.w);
  static final hMedium = SizedBox(width: 16.0.w);
  static final hSmall = SizedBox(width: 12.0.w);
  static final hSmaller = SizedBox(width: 8.0.w);
  static final hSmallest = SizedBox(width: 6.0.w);
}
