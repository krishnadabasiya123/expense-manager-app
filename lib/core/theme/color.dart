import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Light Theme
const klBackgroundColor = Color(0xffffffff);
const klCanvasColor = Color(0xcc000000);
const klPageBackgroundColor = Color(0xfff3f7fa);
const klPrimaryColor = Color.fromARGB(255, 0, 0, 0);
const klPrimaryTextColor = Color(0xff45536d);
const klBoarderColor = Color(0xff515151);
const MaterialColor lexpenseColor = Colors.red;
const MaterialColor lincomeColor = Colors.green;

/// Dark Theme
const kdSecondaryColor = Color(0xff848484);
const kdBackgroundColor = Color(0xff1D1D1D);
const kdCanvasColor = Color.fromARGB(255, 255, 255, 255);
const kdPageBackgroundColor = Color.fromARGB(255, 0, 0, 0);
const kdPrimaryColor = Color.fromARGB(255, 1, 1, 1);
const kdPrimaryTextColor = Color(0xfffefefe);
const kdBoarderColor = Color(0xff515151);
const dexpenseColor = Color.fromARGB(255, 222, 91, 82);
const dincomeColor = Color.fromARGB(255, 100, 177, 103);

extension AppColors on ColorScheme {
  Color get backgroundColor => brightness == Brightness.light ? klBackgroundColor : kdBackgroundColor;

  Color get borderColor => brightness == Brightness.light ? klBoarderColor : kdBoarderColor;

  Color get canvasColor => brightness == Brightness.light ? klCanvasColor : kdCanvasColor;

  Color get pageBackgroundColor => brightness == Brightness.light ? klPageBackgroundColor : kdPageBackgroundColor;

  Color get primaryColor => brightness == Brightness.light ? klPrimaryColor : kdPrimaryColor;

  Color get primaryTextColor => brightness == Brightness.light ? klPrimaryTextColor : kdPrimaryTextColor;

  Color get secondaryColor => brightness == Brightness.light ? lightGreyColor : kdSecondaryColor;

  Color get expenseColor => brightness == Brightness.light ? lexpenseColor : dexpenseColor;

  Color get incomeColor => brightness == Brightness.light ? lincomeColor : dincomeColor;

  Color get lightGreyColor => const Color(0xff8B8B8B);

  static const Color splashScreenGradientTopColor = Color(0xff2050D2);
  static const Color splashScreenGradientBottomColor = Color(0xff143386);

  Color get shimmerBaseColor => brightness == Brightness.light
      ? const Color(0xFFE0E0E0) // Example shimmerBaseColorLight
      : const Color(0xFF424242); // Example shimmerBaseColorDark

  Color get shimmerHighlightColor => brightness == Brightness.light
      ? const Color(0xFFF5F5F5) // Example shimmerHighlightColorLight
      : const Color(0xFF616161); // Example shimmerHighlightColorDark

  Color get shimmerContentColor => brightness == Brightness.light
      ? Colors
            .white // Example shimmerContentColorLight
      : Colors.black; // Example shimmerContentColorDark
  //endregion
}
