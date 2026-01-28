import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PswdTextField extends StatefulWidget {
  const PswdTextField({required this.controller, super.key, this.validator, this.hintText, this.isDense});

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? hintText;
  final bool? isDense;

  @override
  State<PswdTextField> createState() => _PswdTextFieldState();
}

class _PswdTextFieldState extends State<PswdTextField> {
  // bool _obscureText = true;
  final ValueNotifier<bool> _obscureText = ValueNotifier(true);

  @override
  void dispose() {
    _obscureText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onTertiary;

    return ValueListenableBuilder(
      valueListenable: _obscureText,
      builder: (context, value, child) {
        return TextFormField(
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          controller: widget.controller,
          cursorColor: textColor,
          style: TextStyle(color: textColor.withValues(alpha: 0.8), fontSize: 16, fontWeight: FontWeights.regular),
          obscureText: _obscureText.value,
          obscuringCharacter: '*',
          validator: (val) {
            if (val!.isEmpty) {
              return context.tr('passwordRequired');
            } else if (val.length < 6) {
              return context.tr('pwdLengthMsg');
            }

            return widget.validator?.call(val);
          },
          decoration: InputDecoration(
            isDense: widget.isDense ?? false,
            fillColor: Theme.of(context).colorScheme.surface,
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsetsDirectional.all(0),
            hintText: widget.hintText ?? "${context.tr('pwdLbl')}*",
            hintStyle: TextStyle(color: textColor.withValues(alpha: 0.4), fontWeight: FontWeights.regular, fontSize: 16),
            prefixIcon: const Icon(CupertinoIcons.lock),
            prefixIconColor: textColor.withValues(alpha: 0.4),
            suffixIconColor: textColor.withValues(alpha: 0.4),
            suffixIcon: GestureDetector(
              child: Icon(_obscureText.value ? Icons.visibility : Icons.visibility_off),
              onTap: () {
                _obscureText.value = !_obscureText.value;
              },
            ),
          ),
        );
      },
    );
  }
}
