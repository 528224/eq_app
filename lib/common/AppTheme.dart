import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

  static ThemeData lightThemeData =
      themeData(lightColorScheme, _lightFocusColor);
  static ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor);

  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        color: colorScheme.primary,
        elevation: 0,
        brightness: colorScheme.brightness,
      ),
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
      canvasColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      highlightColor: Colors.transparent,
      focusColor: focusColor,
    );
  }

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: Color(0xFF6200EE),
    primaryVariant: Color(0xFF640AFF),
    secondary: Color(0xFF03DAC5),
    secondaryVariant: Color(0xFF0AE1C5),
    background: Color(0xFFE6EBEB),
    surface: Color(0xFFFAFBFB),
    onBackground: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Color(0xFF322942),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
  );

  static final ColorScheme darkColorScheme = ColorScheme(
    primary: Colors.lightBlue,
    primaryVariant: Colors.lightBlue.shade900,
    // secondary: Colors.yellow,
    // secondaryVariant: Colors.yellow.shade900,
    // background: Color(0xff141A31),
    secondary: Color(0xff14DAE2),
    secondaryVariant: Color(0xFF0AE1C5),
    background: Color(0xff251F34),
    surface: Color(0xff1E2746),
    onBackground: Color(0x0DFFFFFF),
    // White with 0.05 opacity
    error: Colors.red,
    onError: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    brightness: Brightness.dark,
  );

  static getPrimaryColor() {
    return Get.isDarkMode ? darkColorScheme.primary : lightColorScheme.primary;
  }

  static getSecondaryColor() {
    return Get.isDarkMode
        ? darkColorScheme.secondary
        : lightColorScheme.secondary;
  }

  static getBackgroundColor() {
    return Get.isDarkMode
        ? darkColorScheme.background
        : lightColorScheme.background;
  }

  static getFocusColor() {
    return Get.isDarkMode ? _darkFocusColor : _lightFocusColor;
  }
}

class AppTextStyles {
  var kTextStyleWithFont = GoogleFonts.montserrat();
  var kPinTextStyle = GoogleFonts.montserrat(color: Color(0xDDFFFFFF));

  var kTextStyleEighteenBoldWithThemeColor =
      GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold);

  var kTextStyleSixteenBoldWithThemeColor =
      GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold);

  var kTextStyleTwentyBoldWithWhiteColor = GoogleFonts.montserrat(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white);

  var kTextStyleFourteenWithThemeColor = GoogleFonts.montserrat(fontSize: 14);

  var kTextStyleTwelveWithGreyColor = GoogleFonts.montserrat(
      fontSize: 12, color: AppColors().kSecondaryTextColor);
}

class AppColors {
  var bottomFooterGradient = Get.isDarkMode
      ? [
          theme1Color,
          theme1Color.shade100,
        ]
      : [
          theme2Color,
          Colors.deepPurple.shade300,
        ];

  var kPrimaryTextColor =
      Get.isDarkMode ? Color(0xDDFFFFFF) : Color(0xDD000000);
  var kSecondaryTextColor =
      Get.isDarkMode ? Color(0x89FFFFFF) : Color(0x89000000);
  var kBlackColor = Colors.black;

  var kPrimaryColor = Get.isDarkMode ? theme1Color : theme2Color;
}

var theme1Color = Colors.lightBlue;
var theme2Color = Color(0xFF6200EE);
