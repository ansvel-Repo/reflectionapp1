import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:flutter/material.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final prefs = SharedPrefs.instance;
  return ThemeNotifier(prefs);
});
