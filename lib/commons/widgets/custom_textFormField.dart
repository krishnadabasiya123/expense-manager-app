import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
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
    this.isReadOnly = false,
    this.onTap,
    this.textInputAction,
    this.inputFormatters,
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
  final bool isReadOnly;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      readOnly: widget.isReadOnly,
      focusNode: widget.focusNode,
      maxLines: widget.maxLines,
      cursorColor: colorScheme.onTertiary,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      textInputAction: widget.textInputAction,
      // inputFormatters: [
      //   FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      // ],
      inputFormatters: widget.inputFormatters,

      onTap: widget.onTap,
      onFieldSubmitted: (value) {
        widget.onFieldSubmitted?.call(value);
        if (widget.nextFocusNode != null) {
          FocusScope.of(context).requestFocus(widget.nextFocusNode);
        } else {
          if (widget.unfocusOnDone) widget.focusNode?.unfocus();
          widget.onDoneKeyPressed?.call();
        }
      },
      onChanged: widget.onChanged,
      style: TextStyle(color: colorScheme.onTertiary.withValues(alpha: 0.8), fontSize: 16, fontWeight: FontWeights.regular),
      decoration: InputDecoration(
        errorMaxLines: 3,
        suffixIcon: widget.suffixIcon,
        fillColor: colorScheme.surface.withValues(alpha: 0.8),
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(widget.radius ?? 8), borderSide: widget.borderSide ?? BorderSide.none),
        prefixIcon: widget.prefixIcon,
        prefixIconColor: colorScheme.onTertiary.withValues(alpha: 0.4),
        hintText: widget.hintText,
        hintStyle: TextStyle(color: colorScheme.onTertiary.withValues(alpha: 0.4), fontSize: widget.hintTextSize, fontWeight: FontWeights.regular),
        contentPadding: const EdgeInsetsDirectional.all(16),
      ),
    );
  }
}
