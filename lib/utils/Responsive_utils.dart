// import 'package:flutter/material.dart';

// /// A utility class for creating responsive layouts and font sizes.
// ///
// /// It uses the screen's shortest side to determine the device type
// /// (mobile, tablet, large tablet) and scales dimensions accordingly.
// class ResponsiveUtils {
//   // Private constructor to prevent instantiation.
//   ResponsiveUtils._();

//   /// The breakpoint for mobile devices.
//   static const double mobileBreakpoint = 600;

//   /// The breakpoint for small tablets.
//   static const double tabletBreakpoint = 900;

//   /// Calculates a responsive dimension (width, height, padding, margin, etc.)
//   /// based on the screen's shortest side.
//   ///
//   /// This method uses the [baseSize] as the dimension for mobile screens
//   /// and scales it up for tablets.
//   ///
//   /// - **Mobile (< 600dp):** Returns `baseSize` (1.0x)
//   /// - **Small Tablet (600dp - 900dp):** Returns `baseSize * 1.2` (20% larger)
//   /// - **Large Tablet (> 900dp):** Returns `baseSize * 1.5` (50% larger)
//   ///
//   /// [context] The build context to get media query information.
//   /// [baseSize] The base dimension for a mobile screen.
//   ///
//   ///
//   ///
//   static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < mobileBreakpoint;

//   /// Returns true if the screen width is between [mobileBreakpoint] and [tabletBreakpoint].
//   static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= mobileBreakpoint && MediaQuery.of(context).size.width < tabletBreakpoint;

//   /// Returns true if the screen width is greater than or equal to [tabletBreakpoint].
//   static bool isLargeScreen(BuildContext context) => MediaQuery.of(context).size.width >= tabletBreakpoint;

//   static double getResponsiveSize(BuildContext context, double baseSize) {
//     final shortestSide = MediaQuery.of(context).size.shortestSide;

//     if (shortestSide < mobileBreakpoint) {
//       return baseSize; // Mobile (no change)
//     } else if (shortestSide < tabletBreakpoint) {
//       return baseSize * 1.2; // Small Tablets
//     } else {
//       return baseSize * 1.5; // Large Tablets / iPads
//     }
//   }

//   static T getResponsiveValue<T>(
//     BuildContext context, {
//     required T mobile,
//     T? tablet,
//     T? largeScreen,
//   }) {
//     final width = MediaQuery.of(context).size.width;

//     if (width >= tabletBreakpoint && largeScreen != null) {
//       return largeScreen;
//     }
//     if (width >= mobileBreakpoint && tablet != null) {
//       return tablet;
//     }
//     return mobile;
//   }

//   /// Calculates a responsive font size based on the screen's shortest side.
//   ///
//   /// This method uses the [baseFontSize] as the font size for mobile screens
//   /// and scales it up for larger screens, but with slightly different multipliers
//   /// than UI dimensions to ensure text remains readable.
//   ///
//   /// - **Mobile (< 600dp):** Returns `baseFontSize` (1.0x)
//   /// - **Small Tablet (600dp - 900dp):** Returns `baseFontSize * 1.1` (10% larger)
//   /// - **Large Tablet (> 900dp):** Returns `baseFontSize * 1.3` (30% larger)
//   ///
//   /// [context] The build context to get media query information.
//   /// [baseFontSize] The base font size for a mobile screen.
//   static double getResponsiveFontSize(BuildContext context, double baseFontSize) {
//     final shortestSide = MediaQuery.of(context).size.shortestSide;

//     // Using a switch expression for a more modern syntax
//     return switch (shortestSide) {
//       < mobileBreakpoint => baseFontSize * 0.8,
//       < tabletBreakpoint => baseFontSize * 1.1, // Small Tablet
//       _ => baseFontSize * 1.4, // Large Tablet
//     };
//   }
// }

import 'package:flutter/material.dart';

/// The core logic engine for responsive calculations.
class ResponsiveUtils {
  ResponsiveUtils._();

  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 905;
  static const double desktopBreakpoint = 1240;
  static const double largeDesktopBreakpoint = 1440;

  // UI Multipliers
  static const double mobileMultiplier = 1;
  static const double tabletMultiplier = 1.2;
  static const double desktopMultiplier = 1.5;

  // Font Multipliers
  static const double mobileFontMultiplier = 1;
  static const double tabletFontMultiplier = 1.15;
  static const double desktopFontMultiplier = 1.35;

  /// Calculates responsive UI size (dp)
  static double getResponsiveSize(BuildContext context, double baseSize) {
    final shortestSide = MediaQuery.sizeOf(context).shortestSide;

    return switch (shortestSide) {
      < mobileBreakpoint => baseSize * mobileMultiplier,
      < tabletBreakpoint => baseSize * tabletMultiplier,
      _ => baseSize * desktopMultiplier,
    };
  }

  /// Calculates responsive font size (sp)
  static double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final shortestSide = MediaQuery.sizeOf(context).shortestSide;

    return switch (shortestSide) {
      < mobileBreakpoint => baseFontSize * mobileFontMultiplier,
      < tabletBreakpoint => baseFontSize * tabletFontMultiplier,
      _ => baseFontSize * desktopFontMultiplier,
    };
  }

  /// Helper for returning different types of values based on screen size
  static T getResponsiveValue<T>(BuildContext context, {required T mobile, T? tablet, T? desktop}) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= tabletBreakpoint && desktop != null) return desktop;
    if (width >= mobileBreakpoint && tablet != null) return tablet;
    return mobile;
  }
}
