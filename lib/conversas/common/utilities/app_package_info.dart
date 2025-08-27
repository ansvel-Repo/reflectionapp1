import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

@immutable
class AppPackageInfo {
  const AppPackageInfo._();

  static late PackageInfo _packageInfo;

  static Future<void> init() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  static PackageInfo get instance => _packageInfo;
}
