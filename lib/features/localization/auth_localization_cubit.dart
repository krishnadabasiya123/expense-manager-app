import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:flutter/material.dart';

class AppLocalizationState {
  AppLocalizationState(this.language);
  final Locale language;
}

class AppLocalizationCubit extends Cubit<AppLocalizationState> {
  AppLocalizationCubit(this.systemSettingLocalData) : super(AppLocalizationState(UiUtils.getLocaleFromLanguageCode(defaultLanguageCode))) {
    changeLanguage(systemSettingLocalData.languageCode);
  }

  final SystemSettingLocalData systemSettingLocalData;

  void changeLanguage(String languageCode) {
    systemSettingLocalData.languageCode = languageCode;
    emit(AppLocalizationState(UiUtils.getLocaleFromLanguageCode(languageCode)));
  }
}
