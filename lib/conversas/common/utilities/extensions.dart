import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textStyle => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  Size get deviceSize => MediaQuery.of(this).size;
}
