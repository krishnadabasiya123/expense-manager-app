import 'dart:convert';

import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Applocalization {
  Applocalization(this.locale);

  final Locale locale;
  late Map<String, String> localizedKeyAndValue;

  static Applocalization? of(BuildContext context) {
    return Localizations.of<Applocalization>(context, Applocalization);
  }

  Future<void> loadJson() async {
    // for en , hi locale.luanguageCode work
    // for zh-TW , zh-CN locale.languageCode}-${locale.countryCode work
    final languageJsonName = locale.countryCode == null ? locale.languageCode : '${locale.languageCode}-${locale.countryCode}';
    final jsonStringValues = await rootBundle.loadString('assets/languages/$languageJsonName.json');
    //value from rootbundle will be encoded string

    final mappedJson = jsonDecode(jsonStringValues) as Map<String, dynamic>;

    localizedKeyAndValue = mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String? gettranslatedkey(String? key) {
    ///will returns the matching translated value
    return localizedKeyAndValue[key!];
  }

  static LocalizationsDelegate<Applocalization> delegate = const _AppLocalizationDelegate();
}

class _AppLocalizationDelegate extends LocalizationsDelegate<Applocalization> {
  const _AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return supportedLocales.map(UiUtils.getLocaleFromLanguageCode).toList().contains(locale);
  }

  @override
  Future<Applocalization> load(Locale locale) async {
    final localization = Applocalization(locale);
    await localization.loadJson();
    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<Applocalization> old) => false;
}
