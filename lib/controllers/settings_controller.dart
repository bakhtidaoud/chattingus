import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  var themeMode = ThemeMode.system.obs;
  var locale = const Locale('en').obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load Theme
    final themeIndex = prefs.getInt('themeMode');
    if (themeIndex != null) {
      themeMode.value = ThemeMode.values[themeIndex];
      Get.changeThemeMode(themeMode.value);
    }

    // Load Locale
    final languageCode = prefs.getString('languageCode');
    if (languageCode != null) {
      locale.value = Locale(languageCode);
      Get.updateLocale(locale.value);
    }
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
  }

  Future<void> updateLocale(Locale newLocale) async {
    if (!['en', 'ar', 'fr'].contains(newLocale.languageCode)) return;
    
    locale.value = newLocale;
    Get.updateLocale(newLocale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', newLocale.languageCode);
  }
}
