import 'package:expenseapp/core/localization/app_localization.dart';
import 'package:flutter/material.dart';

extension LocalizationExtension on BuildContext {
  String tr(String key) {
    return Applocalization.of(this)?.gettranslatedkey(key) ?? key;
  }
}

extension LocalizationExtensions on String {
  String tr(BuildContext context, {Map<String, String>? namedArgs}) {
    var text = Applocalization.of(context)?.gettranslatedkey(this) ?? this;
    if (namedArgs != null) {
      namedArgs.forEach((key, value) {
        text = text.replaceAll('{$key}', value);
      });
    }
    return text;
  }
}
