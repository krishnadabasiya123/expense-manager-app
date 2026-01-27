import 'dart:ui' as ui;
import 'package:expenseapp/core/app/all_import_file.dart';

class AppLanguage {
  const AppLanguage({required this.code, required this.name});
  final String code;
  final String name;

  ui.Locale get locale => UiUtils.getLocaleFromLanguageCode(code);
}

const Map<String, AppLanguage> languageModels = {'en': AppLanguage(code: 'en', name: 'English'), 'gu': AppLanguage(code: 'gu', name: 'Gujarati'), 'ar-AE': AppLanguage(code: 'ar-AE', name: 'Arabic')};
