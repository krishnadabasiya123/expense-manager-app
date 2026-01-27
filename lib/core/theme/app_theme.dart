import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppThemeType { dark, light }

final Map<AppThemeType, ThemeData> appThemeData = {
  AppThemeType.light: ThemeData(
    primaryTextTheme: GoogleFonts.nunitoTextTheme(),
    textTheme: GoogleFonts.nunitoTextTheme(),
    fontFamily: GoogleFonts.nunito().fontFamily,
    textButtonTheme: _textButtonTheme,
    useMaterial3: true,
    scaffoldBackgroundColor: Color.lerp(Colors.white, const Color(0xFF1E3A8A), 0.1),
    shadowColor: Colors.white,

    brightness: Brightness.light,
    primaryColor: AppThemeColors.lightPrimaryColor,
    secondaryHeaderColor: AppThemeColors.lightTextColor,

    textSelectionTheme: const TextSelectionThemeData(cursorColor: AppThemeColors.lightPrimaryColor, selectionHandleColor: AppThemeColors.lightPrimaryColor),
    colorScheme: const ColorScheme(
      onTertiary: AppThemeColors.darkTextColor,
      brightness: Brightness.light,
      primary: AppThemeColors.lightPrimaryColor,
      onPrimary: AppThemeColors.whiteColor,
      secondary: AppThemeColors.lightSecondaryColor,
      onSecondary: AppThemeColors.lightTextColor,
      error: AppThemeColors.errorColor,
      onError: AppThemeColors.whiteColor,
      surface: AppThemeColors.lightSurfaceColor,
      onSurface: AppThemeColors.lightTextColor,
      surfaceDim: AppThemeColors.lightGreyColor,
    ),
    dividerTheme: const DividerThemeData(color: AppThemeColors.lightGreyColor, thickness: 0.5),
    appBarTheme: const AppBarTheme(backgroundColor: Color.fromARGB(255, 196, 214, 210)),
  ),

  //
  AppThemeType.dark: ThemeData(
    textTheme: GoogleFonts.nunitoTextTheme(),
    textButtonTheme: _textButtonTheme,
    useMaterial3: true,
    fontFamily: GoogleFonts.nunito().fontFamily,
    brightness: Brightness.dark,
    primaryColor: AppThemeColors.darkPrimaryColor,
    secondaryHeaderColor: AppThemeColors.darkTextColor,
    scaffoldBackgroundColor: AppThemeColors.darkSurfaceColor,

    textSelectionTheme: const TextSelectionThemeData(cursorColor: AppThemeColors.darkPrimaryColor, selectionHandleColor: AppThemeColors.darkPrimaryColor),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppThemeColors.darkPrimaryColor,
      onPrimary: AppThemeColors.whiteColor,
      secondary: AppThemeColors.darkSecondaryColor,
      onSecondary: AppThemeColors.darkTextColor,
      error: AppThemeColors.errorColor,
      onError: AppThemeColors.whiteColor,
      surface: AppThemeColors.darkSurfaceColor,
      onSurface: AppThemeColors.darkTextColor,
      surfaceDim: AppThemeColors.darkGreyColor,
    ),
    dividerTheme: const DividerThemeData(color: AppThemeColors.darkGreyColor, thickness: 0.5),
  ),
};

class AppThemeColors {
  ///Application main color
  static const Color lightPrimaryColor = Color(0xFF1E3A8A);

  static const Color splashColor = Color.fromARGB(255, 180, 195, 235);

  ///Surface color
  static const Color lightSurfaceColor = Colors.white;

  ///Card,Container color
  static const Color lightSecondaryColor = Color.fromARGB(255, 43, 68, 138);

  ///Text color
  static const Color lightTextColor = Color(0xFF141210);
  static const Color lightGreyColor = Colors.grey;

  ///Application main color
  static const Color darkPrimaryColor = Color(0xFF1E3A8A);

  ///Surface color
  static const Color darkSurfaceColor = Color(0xFF000000);

  ///Card,Container color
  static const Color darkSecondaryColor = Color.fromARGB(255, 75, 154, 146);

  ///Text color
  static const Color darkTextColor = Color.fromARGB(255, 0, 0, 0);
  static const Color darkGreyColor = Color(0x99FFFFFF);
  //Error color
  static const Color errorColor = Color(0xFFBA1A1A);
  //Other colors
  static const Color whiteColor = Colors.white;
  static const Color headerColor = Color(0xFFBCE4FC);
  static const Color redColor = Colors.red;
  static const Color greenColor = Color(0xFF008A00);
  //status colors
  static const Color pendingColor = Color(0xFF9E9E9E); // Grey
  static const Color preparingColor = Color(0xFFFFD600); // Yellow
  static const Color readyForPickUpColor = Color(0xFFFFAB00); // Amber
  static const Color arrivedAtBusinessPartnerColor = Color(0xFF03A9F4); // Light Blue
  static const Color pickedUpFromBusinessPartnerColor = Color(0xFFFF9008); // Orange (Primary)
  static const Color pickedUpByDeliveryBoyColor = Color(0xFFFF5722); // Deep Orange
  static const Color deliveringColor = Color(0xFF2196F3); // Blue
  static const Color arrivedAtCustomerColor = Color(0xFF009688); // Teal
  static const Color deliveredColor = Color(0xFF4CAF50); // Green
  static const Color rejectedColor = Color(0xFFD32F2F); // Red
  //Linear gradient colors
  static const Color linearGradientLightPrimaryColor = Color(0xFFFBF1EC);
  static const Color linearGradientLightSecondaryColor = Color(0xFFFFFFFF);
  static const Color linearGradientDarkPrimaryColor = Color(0xFF000000);
  static const Color linearGradientDarkSecondaryColor = Color(0xFF212121);
  static const Color orangeColor = Color(0xFFFFA434);
}

final _textButtonTheme = TextButtonThemeData(
  style: TextButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
);
