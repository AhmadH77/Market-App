//@dart=2.9
import 'package:flutter/material.dart';
import 'package:market_app/translate/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static const Color primaryColor = Color.fromRGBO(224, 177, 121, 1);

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  String LAGUAGE_CODE = 'languageCode';

  static const String ENGLISH = 'en';
  static const String ARABIC = 'ar';

  Future<Locale> setLocale(String languageCode) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(LAGUAGE_CODE, languageCode);
    return _locale(languageCode);
  }

  Future<Locale> getLocale() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String languageCode = _prefs.getString(LAGUAGE_CODE) ?? "en";
    return _locale(languageCode);
  }

  Locale _locale(String languageCode) {
    switch (languageCode) {
      case ENGLISH:
        return Locale(ENGLISH, 'US');
      case ARABIC:
        return Locale(ARABIC, "SA");
      default:
        return Locale(ENGLISH, 'SA');
    }
  }

  String getTranslated(BuildContext context, String key) {
    return AppLocalizations.of(context).Translate(key);
  }
}
