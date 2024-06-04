import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../theme/themeData.dart';

class ThemeController extends GetxController {
  final box = GetStorage();
  static const _themeKey = 'currentTheme';

  Rx<ThemeData> currentTheme = Rx<ThemeData>(Lightmode);

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }

  void toggleTheme() {
    if (currentTheme.value == Lightmode) {
      currentTheme.value = Darkmode;
    } else {
      currentTheme.value = Lightmode;
    }
    _saveThemeToStorage();
  }

  void _loadThemeFromStorage() {
    final themeIndex = box.read(_themeKey);
    if (themeIndex != null) {
      currentTheme.value = themeIndex == 0 ? Lightmode : Darkmode;
    }
  }

  void _saveThemeToStorage() {
    final themeIndex = currentTheme.value == Lightmode ? 0 : 1;
    box.write(_themeKey, themeIndex);
  }
}
