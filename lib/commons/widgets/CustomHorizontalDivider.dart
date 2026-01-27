

import 'package:flutter/material.dart';

// If you are using a custom sizing extension like 'sp', you might import it here.
// However, the widget itself is more reusable if it accepts a standard 'double'.
// import 'package:restaurant_app/utils/extensions/device_hight_width_extensions.dart';

/// A custom divider widget that fades out towards the left and right edges.
///
/// This widget uses a [LinearGradient] to create a visual effect where the
/// center is a solid color and the ends are transparent, providing a more
/// subtle separation of content.
class CustomHorizontalDivider extends StatelessWidget {
  /// Creates a fading divider.
  const CustomHorizontalDivider({super.key, this.height = 1.0, this.color, this.endOpacity = 0.0, this.padding = const EdgeInsetsDirectional.symmetric(vertical: 8)});

  /// The thickness of the divider line. Defaults to 1.0.
  final double height;

  /// The primary color of the divider at its center.
  ///
  /// If null, it defaults to [Theme.of(context).dividerColor].
  final Color? color;

  /// The opacity of the color at the extreme left and right ends of the divider.
  ///
  /// Defaults to 0.0 (fully transparent). A value of 0.2 would match
  /// your original code snippet.
  final double endOpacity;

  /// The empty space to add around the divider.
  ///
  /// Defaults to `EdgeInsetsDirectional.symmetric(vertical: 8.0)`.
  // final EdgeInsetsDirectionalGeometry padding;
  final EdgeInsetsDirectional padding;

  @override
  Widget build(BuildContext context) {
    // Use the provided color, or fall back to the theme's default divider color.
    final dividerColor = Color(0xff848484);

    // Create the transparent version of the color for the gradient ends.
    final transparentColor = dividerColor.withValues(alpha: endOpacity);

    return Padding(
      padding: padding,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // Define the colors for the gradient.
            // It goes from transparent -> solid -> transparent.
            colors: [
              transparentColor, // Left (faded)
              dividerColor, // Center (solid)
              transparentColor, // Right (faded)
            ],
            // The `stops` property controls where the color transitions occur.
            // [0.0] is the far left.
            // [0.5] is the exact center.
            // [1.0] is the far right.
            // This setup ensures the `dividerColor` is at its most opaque in the middle.
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }
}
