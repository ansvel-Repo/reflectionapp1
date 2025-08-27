import 'package:flutter/foundation.dart' show immutable;

@immutable
class AppLinks {
  static const String _baseUrl = "https://isaiascuvula.notion.site";
  static const String privacy =
      '$_baseUrl/Privacy-Policy-Conversas-0ab31fd8062042e295325ba4ca057a4b?pvs=4';
  static const String help =
      '$_baseUrl/Help-0bb604ed09f94b31a5c58f4e5578c6a9?pvs=4';
  static const String termsConditions =
      '$_baseUrl/Terms-Conditions-bcb01625724347a69ac76b0549c86502?pvs=4';
  const AppLinks._();
}
