import 'dart:convert';

import 'package:flutter/services.dart';

abstract class config {
  static Map localization = {};

  static Future<void> LoadLanguage(bool isArabic) async {
    String translation;
    if (isArabic) {
      translation = await rootBundle.loadString('assets/localization/ar.json');
    } else {
      translation = await rootBundle.loadString('assets/localization/en.json');
    }
    localization = jsonDecode(translation);
  }
}
