import 'package:expenseapp/commons/widgets/custom_textFormField.dart';
import 'package:expenseapp/utils/extensions/num_extensions.dart';
import 'package:flutter/material.dart';

class CommonSearchController extends StatelessWidget {
  const CommonSearchController({required this.controller, required this.hintText, super.key, this.onChanged, this.hintTextColor = Colors.grey, this.borderRadius, this.fontSize, this.prefixIconSize});
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onChanged;
  final Color? hintTextColor;
  final double? borderRadius;
  final double? fontSize;
  final double? prefixIconSize;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // return CustomTextFormField(
    //   onChanged: onChanged,
    //   isFilled: true,
    //   fillColor: Colors.white,
    //   hintText: hintText,
    //   fontSize: fontSize,
    //   prefixIconSize: prefixIconSize,

    //   controller: controller,
    //   borderRadius: borderRadius ?? 20.sp(context),
    //   color: colorScheme.surface,
    //   textColor: colorScheme.onTertiary,
    //   hintTextColor: colorScheme.onTertiary,
    //   prefixIcon: Icons.search,
    //   prefixIconColor: colorScheme.onTertiary,
    // );
    return CustomTextFormField(
      controller: controller,
      hintText: hintText,
      onChanged: onChanged,
      radius: 20.sp(context),
      prefixIcon: Icon(Icons.search, color: colorScheme.onTertiary),

      // hintTextColor: colorScheme.onTertiary,
      //borderRadius: borderRadius ?? 20.sp(context),
      // color: colorScheme.surface,
      //textColor: colorScheme.onTertiary,
      //hintTextColor: colorScheme.onTertiary,
      // prefixIcon: Icons.search,
      // prefixIconColor: colorScheme.onTertiary,
      //isPassword: false,
      //prefixIconSize: prefixIconSize,
    );
  }
}
