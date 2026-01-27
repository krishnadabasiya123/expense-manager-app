import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    required this.controller,
    super.key,
    this.isDesne,
    this.hintText,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.maxLines,
    this.radius,
    this.suffixIcon,
    this.height,
    this.borderSide,
    this.hintTextSize,
    this.focusNode,
    this.nextFocusNode,
    this.onFieldSubmitted,
    this.unfocusOnDone = true,
    this.onDoneKeyPressed,
    this.onChanged,
  });

  final TextEditingController controller;
  final String? hintText;
  final bool? isDesne;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Icon? prefixIcon;
  final int? maxLines;
  final double? radius;
  final Icon? suffixIcon;
  final double? height;
  final BorderSide? borderSide;
  final double? hintTextSize;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final bool unfocusOnDone;
  final VoidCallback? onDoneKeyPressed;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      focusNode: focusNode,
      maxLines: maxLines ?? 1,
      cursorColor: colorScheme.onTertiary,
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onFieldSubmitted: (value) {
        onFieldSubmitted?.call(value);
        if (nextFocusNode != null) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        } else {
          if (unfocusOnDone) focusNode?.unfocus();
          onDoneKeyPressed?.call();
        }
      },
      onChanged: onChanged,
      style: TextStyle(color: colorScheme.onTertiary.withValues(alpha: 0.8), fontSize: 16, fontWeight: FontWeights.regular),
      decoration: InputDecoration(
        errorMaxLines: 3,
        suffixIcon: suffixIcon,
        fillColor: colorScheme.surface.withValues(alpha: 0.8),
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(radius ?? 8), borderSide: borderSide ?? BorderSide.none),
        prefixIcon: prefixIcon,
        prefixIconColor: colorScheme.onTertiary.withValues(alpha: 0.4),
        hintText: hintText,
        hintStyle: TextStyle(color: colorScheme.onTertiary.withValues(alpha: 0.4), fontSize: hintTextSize, fontWeight: FontWeights.regular),
        contentPadding: const EdgeInsetsDirectional.all(16),
      ),
    );
  }
}
