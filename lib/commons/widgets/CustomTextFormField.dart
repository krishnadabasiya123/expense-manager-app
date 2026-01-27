import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    this.hintText,
    required this.controller,
    this.isReadOnly = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.isFilled,
    this.fillColor,
    this.showError = false,
    this.textColor,
    super.key,
    this.borderRadius,
    this.color,
    this.hintTextColor,
    this.suffixIcon,
    this.iconColor,
    this.validator,
    this.errorIconColor,
    this.prefixIcon,
    this.prefixIconColor,
    this.isPassword = false,
    this.onTap,
    this.textInputAction = TextInputAction.next,
    this.fontSize,
    this.prefixIconSize,
  });
  final String? hintText;
  final TextEditingController controller;
  final double? borderRadius;
  final Color? color;
  final Color? hintTextColor;
  final IconData? suffixIcon;
  final Color? iconColor;
  final String? Function(String?)? validator;
  final Color? errorIconColor;
  final bool showError;
  final Color? textColor;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final bool isPassword;
  final Color? fillColor;
  final bool? isFilled;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final bool isReadOnly;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;
  final double? fontSize;
  final double? prefixIconSize;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  // late bool _obscureText;

  final ValueNotifier<bool> _obscureText = ValueNotifier(false);

  @override
  void initState() {
    _obscureText.value = widget.isPassword;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _obscureText,
      builder: (context, value, child) {
        return TextFormField(
          onTap: widget.onTap,
          readOnly: widget.isReadOnly,
          keyboardType: widget.keyboardType,
          //  keyboardType: widget.isNumberKeyboard! ? TextInputType.number : TextInputType.text,
          controller: widget.controller,
          validator: widget.validator,
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          onChanged: widget.onChanged,
          obscureText: _obscureText.value,
          style: TextStyle(color: widget.textColor, fontSize: widget.fontSize ?? 16),

          autovalidateMode: AutovalidateMode.disabled,
          decoration: InputDecoration(
            filled: widget.isFilled,
            fillColor: widget.fillColor,
            hintText: widget.hintText,
            suffixIcon: widget.suffixIcon != null
                ? GestureDetector(
                    onTap: () {
                      if (widget.isPassword) {
                        _obscureText.value = !_obscureText.value;
                      }
                    },
                    child: Icon(_obscureText.value ? Icons.visibility_off : Icons.visibility, color: widget.showError ? (widget.errorIconColor ?? Colors.red) : (widget.iconColor ?? Colors.white)),
                  )
                : null,
            hintStyle: TextStyle(color: widget.hintTextColor),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              borderSide: BorderSide(color: widget.color!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              borderSide: BorderSide(color: widget.color!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              borderSide: BorderSide(color: widget.color!),
            ),
            prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon, color: widget.prefixIconColor, size: widget.prefixIconSize) : null,
            isDense: true,
          ),
        );
      },
    );
  }
}
