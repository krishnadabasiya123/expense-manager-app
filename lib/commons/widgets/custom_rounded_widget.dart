import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:flutter/material.dart';

/// An enum to determine the position of the icon in the button.
enum IconPosition { leading, trailing }

/// A highly customizable button built from scratch using `Container` and `InkWell`.
///
/// This approach provides full control over styling, including borders, shadows,
/// and a built-in loading state, without relying on Flutter's pre-made button widgets.
class CustomRoundedButton extends StatelessWidget {
  const CustomRoundedButton({
    // --- Sizing ---
    required this.height,
    super.key,
    // --- Content ---
    this.text,
    this.icon,
    this.child,
    this.iconPosition = IconPosition.leading,
    // --- Behavior ---
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.stretch = false,
    this.padding,
    // --- Styling ---
    this.backgroundColor,
    this.disabledColor,
    this.foregroundColor,
    this.elevation,
    this.shadowColor,
    this.borderRadius,
    this.borderSide,
    this.textStyle,
  }) : assert(child != null || text != null || icon != null, 'A button must have at least a child, text, or an icon.');

  // --- Content ---
  /// The text to display in the button. Ignored if `child` is provided.
  final String? text;

  /// An optional icon to display. Ignored if `child` is provided.
  final Widget? icon;

  /// A custom widget to display as the button's content. Overrides `text` and `icon`.
  final Widget? child;

  /// The position of the `icon` relative to the `text`.
  final IconPosition iconPosition;

  // --- Behavior ---
  /// The callback for when the button is tapped. If null or `isLoading` is true,
  /// the button will be in a disabled state.
  final VoidCallback? onPressed;

  /// If true, a loading indicator is shown and the button is disabled.
  final bool isLoading;

  // --- Sizing ---
  /// The height of the button. Defaults to 48.
  final double height;

  /// The fixed width of the button. If `stretch` is true, this is ignored.
  final double? width;

  /// If true, the button expands to fill the available width.
  final bool stretch;

  /// Padding around the button's content. Defaults to horizontal padding of 16.
  final EdgeInsetsDirectional? padding;

  // --- Styling ---
  /// The background color of the button.
  final Color? backgroundColor;

  /// The background color when the button is disabled.
  final Color? disabledColor;

  /// The color for the `text` and `icon`.
  final Color? foregroundColor;

  /// The z-coordinate at which to place this button relative to its parent.
  final double? elevation;

  /// The color of the shadow below the button.
  final Color? shadowColor;

  /// The border radius for the button's corners.
  final BorderRadius? borderRadius;

  /// The border to display around the button.
  final BorderSide? borderSide;

  /// The text style for the button's `text`.
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onPressed != null && !isLoading;

    final effectiveBackgroundColor = isEnabled ? (backgroundColor ?? theme.colorScheme.primary) : (disabledColor ?? theme.disabledColor.withValues(alpha: 0.12));

    final effectiveForegroundColor = foregroundColor ?? (ThemeData.estimateBrightnessForColor(effectiveBackgroundColor) == Brightness.dark ? Colors.white : Colors.black);

    // This widget provides the visual container (color, shape, border, shadow)
    final Widget buttonBody = Container(
      height: height,
      width: stretch ? double.infinity : width,
      padding: padding ?? EdgeInsetsDirectional.symmetric(horizontal: 16.sp(context)),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(8.sp(context)),
        border: borderSide != null ? Border.fromBorderSide(borderSide!) : null,
      ),
      alignment: Alignment.center,
      child: _buildContent(theme, effectiveForegroundColor, context),
    );

    // Material widget is used to properly handle elevation and clipping for the InkWell splash
    return Material(
      color: Colors.transparent, // The color is handled by the Container
      elevation: elevation ?? 0,
      shadowColor: shadowColor,
      borderRadius: borderRadius ?? BorderRadius.circular(8.sp(context)),
      child: InkWell(onTap: isEnabled ? onPressed : null, borderRadius: borderRadius ?? BorderRadius.circular(8.sp(context)), child: buttonBody),
    );
  }

  /// Builds the content inside the button (loader, custom child, or text/icon).
  Widget _buildContent(ThemeData theme, Color fgColor, BuildContext context) {
    if (isLoading) {
      return SizedBox(width: 24.sp(context), height: 24.sp(context), child: const CustomCircularProgressIndicator());
    }

    if (child != null) {
      return child!;
    }

    // final textWidget = text != null
    //     ? Text(
    //         text!,
    //         textAlign: TextAlign.center,
    //         style: (textStyle ?? theme.textTheme.labelLarge)?.copyWith(color: fgColor),
    //       )
    //     : const SizedBox.shrink();
    final textWidget = text != null
        ? Text(
            text!,
            textAlign: TextAlign.center,
            style: (textStyle ?? theme.textTheme.labelLarge)?.copyWith(
              color: textStyle?.color ?? fgColor,
            ),
          )
        : const SizedBox.shrink();

    if (icon != null) {
      final iconWidget = IconTheme(
        data: IconThemeData(color: fgColor, size: (textStyle?.fontSize ?? 16.sp(context)) * 1.25),
        child: icon!,
      );
      final spacing = SizedBox(width: 8.sp(context));

      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: iconPosition == IconPosition.leading ? [iconWidget, spacing, textWidget] : [textWidget, spacing, iconWidget],
      );
    }

    return textWidget;
  }
}
