import 'package:expenseapp/core/app/all_import_file.dart';

import 'package:flutter/material.dart';

/// A custom padding widget that applies padding to any side of its child.
///
/// This widget is highly flexible, allowing you to define padding for each side
/// (`left`, `top`, `right`, `bottom`) individually. For each side, you can provide
/// either a fixed pixel value (e.g., `leftPadding: 16.0`) or a factor of the
/// screen's dimensions (e.g., `leftFactor: 0.04` for 4% of screen width).
///
/// This widget is RTL-aware when using `EdgeInsetsDirectional.only`, which is handled by
/// the underlying framework.
class ResponsivePadding extends StatelessWidget {
  /// Creates a responsive padding widget with individual side control.
  ///
  /// For each side, you must provide either a fixed padding value (e.g., [leftPadding])
  /// or a screen factor (e.g., [leftFactor]), but not both. If neither is
  /// provided for a side, the padding for that side will be 0.
  const ResponsivePadding({
    required this.child,
    super.key,
    // Left padding options
    this.leftPadding,
    this.leftFactor,
    // Right padding options
    this.rightPadding,
    this.rightFactor,
    // Top padding options
    this.topPadding,
    this.topFactor,
    // Bottom padding options
    this.bottomPadding,
    this.bottomFactor,
  }) : assert(leftPadding == null || leftFactor == null, 'Cannot provide both a fixed leftPadding and a leftFactor.'),
       assert(rightPadding == null || rightFactor == null, 'Cannot provide both a fixed rightPadding and a rightFactor.'),
       assert(topPadding == null || topFactor == null, 'Cannot provide both a fixed topPadding and a topFactor.'),
       assert(bottomPadding == null || bottomFactor == null, 'Cannot provide both a fixed bottomPadding and a bottomFactor.');

  /// The widget below this widget in the tree.
  final Widget child;

  // Fixed padding values
  final double? leftPadding;
  final double? rightPadding;
  final double? topPadding;
  final double? bottomPadding;

  // Screen dimension factors
  final double? leftFactor;
  final double? rightFactor;
  final double? topFactor;
  final double? bottomFactor;

  @override
  Widget build(BuildContext context) {
    // Determine the final padding value for each side.
    // Precedence: Fixed padding > Factor > 0.0
    final finalLeft = leftPadding ?? (context.screenWidth * (leftFactor ?? 0.035));
    final finalRight = rightPadding ?? (context.screenWidth * (rightFactor ?? 0.035));
    final finalTop = topPadding ?? (context.screenHeight * (topFactor ?? 0.0));
    final finalBottom = bottomPadding ?? (context.screenHeight * (bottomFactor ?? 0.0));

    // Use EdgeInsetsDirectional.only for granular control over each side.
    return Padding(
      padding: EdgeInsetsDirectional.only(start: finalLeft, end: finalRight, top: finalTop, bottom: finalBottom),
      child: child,
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:restaurant_app/utils/extensions/device_hight_width_extensions.dart';

// /// A custom padding widget that applies symmetric horizontal and/or vertical
// /// padding to its child.
// ///
// /// By default, if no horizontal padding is specified, it applies a padding
// /// equal to 3% of the screen width (`horizontalFactor: 0.03`).
// ///
// /// This widget is RTL-aware and highly customizable. You can provide padding
// /// as a fixed pixel value (e.g., 16.0) or as a factor of the screen's
// /// dimensions (e.g., 0.04 for 4% of the screen width).
// class CustomSymmetricPadding extends StatelessWidget {
//   /// Creates a symmetric padding widget.
//   ///
//   /// You must provide either a fixed padding value (e.g., [horizontalPadding])
//   /// or a screen factor (e.g., [horizontalFactor]), but not both for the
//   /// same axis.
//   const CustomSymmetricPadding({required this.child, super.key, this.horizontalPadding, this.verticalPadding, this.horizontalFactor, this.verticalFactor})
//     : assert(horizontalPadding == null || horizontalFactor == null, 'Cannot provide both a fixed horizontalPadding and a horizontalFactor.'),
//       assert(verticalPadding == null || verticalFactor == null, 'Cannot provide both a fixed verticalPadding and a verticalFactor.');

//   /// The widget below this widget in the tree.
//   final Widget child;

//   /// The fixed horizontal padding to apply on both left and right sides.
//   /// Overrides the default and any [horizontalFactor].
//   final double? horizontalPadding;

//   /// The fixed vertical padding to apply on both top and bottom sides.
//   /// Overrides any [verticalFactor].
//   final double? verticalPadding;

//   /// The factor of the screen width to use as horizontal padding.
//   /// If this and [horizontalPadding] are null, a default of `0.03` is used.
//   final double? horizontalFactor;

//   /// The factor of the screen height to use as vertical padding.
//   final double? verticalFactor;

//   @override
//   Widget build(BuildContext context) {
//     // Determine the final horizontal padding value.
//     // Precedence:
//     // 1. `horizontalPadding` (if not null)
//     // 2. `horizontalFactor` (if not null)
//     // 3. Default factor of 0.03
//     final finalHorizontal = horizontalPadding ?? (context.screenWidth * (horizontalFactor ?? 0.03));

//     // Determine the final vertical padding value.
//     // Defaults to 0.0 if neither is provided.
//     final finalVertical = verticalPadding ?? (context.screenHeight * (verticalFactor ?? 0.0));

//     // Use EdgeInsetsDirectional.symmetric to ensure it automatically handles
//     // LTR and RTL text directions correctly.
//     return Padding(
//       padding: EdgeInsetsDirectional.symmetric(horizontal: finalHorizontal, vertical: finalVertical),
//       child: child,
//     );
//   }
// }
