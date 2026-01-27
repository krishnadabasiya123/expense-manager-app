import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/utils/validators.dart';
import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({required this.controller, super.key, this.isDesne});

  final TextEditingController controller;
  final bool? isDesne;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hintText = "${context.tr('emailAddress')}*";

    return TextFormField(
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      cursorColor: colorScheme.onTertiary,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      validator: (val) => Validators.validateEmail(val!, context.tr('emailRequiredMsg'), context.tr('enterValidEmailMsg')),
      style: TextStyle(color: colorScheme.onTertiary.withValues(alpha: 0.8), fontSize: 16, fontWeight: FontWeights.regular),
      decoration: InputDecoration(
        fillColor: colorScheme.surface.withValues(alpha: 0.8),
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: const Icon(Icons.mail_outline_rounded),
        prefixIconColor: colorScheme.onTertiary.withValues(alpha: 0.4),
        hintText: hintText,
        hintStyle: TextStyle(color: colorScheme.onTertiary.withValues(alpha: 0.4), fontSize: 16, fontWeight: FontWeights.regular),
        contentPadding: const EdgeInsetsDirectional.all(0),
        isDense: isDesne ?? false,
      ),
    );
  }
}
