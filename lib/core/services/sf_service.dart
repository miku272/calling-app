import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SfService {
  final SharedPreferences _prefs;

  static const String _localizationKey = 'localization';
  static const String _themeKey = 'theme_mode';

  SfService({required SharedPreferences sharedPreferences})
    : _prefs = sharedPreferences;

  Future<void> saveThemeMode(ThemeMode themeMode) async {
    await _prefs.setString(_themeKey, themeMode.name);
  }

  ThemeMode getThemeMode() {
    final themeString = _prefs.getString(_themeKey);

    switch (themeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  Future<bool> clearThemeMode() async {
    return await _prefs.remove(_themeKey);
  }

  Future<void> saveLocalization(Locale locale) async {
    await _prefs.setString(_localizationKey, locale.languageCode);
  }

  Locale getLocalization() {
    final localeLanguageCode = _prefs.getString(_localizationKey);

    return Locale(localeLanguageCode ?? 'en');
  }

  Future<bool> clearLocalization() async {
    return await _prefs.remove(_localizationKey);
  }
}
