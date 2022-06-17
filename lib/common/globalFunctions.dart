import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../main.dart';
import 'Constants.dart';

bool isAppleTester() {
  var userRole = currentUserDetails?.userRole ?? "";
  return userRole == UserRoles.appleTester.toString();
}

bool isNotAppleTester() {
  return !isAppleTester();
}

void switchTheme() {
  final isChangingToDarkMode = !Get.isDarkMode;
  final themeMode = Get.isDarkMode ? ThemeMode.light : ThemeMode.dark;
  Get.changeThemeMode(themeMode);
  GetStorage().write(isDarkModeKey, isChangingToDarkMode);
}
