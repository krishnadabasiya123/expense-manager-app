import 'package:expenseapp/core/app/all_import_file.dart';

class SystemSettingLocalData {
  Box<dynamic> get _box => Hive.box<dynamic>(settingsBox);

  String get languageCode => _box.get(languageCodeKey, defaultValue: 'en') as String;

  set languageCode(String value) => _box.put(languageCodeKey, value);

  String get theme => _box.get(settingsThemeKey, defaultValue: defaultThemeKey) as String;

  set theme(String value) => _box.put(settingsThemeKey, value);

  // String get currency => _box.get(currencyKey, defaultValue: defaultCurrencyKey) as String;

  Map<String, String> get currency {
    final dynamic data = _box.get(currencyKey, defaultValue: defaultCurrencyKey);

    if (data is Map) {
      return data.map<String, String>(
        (k, v) => MapEntry(k.toString(), v.toString()),
      );
    }

    return {
      'name': 'Dollar',
      'symbol': r'$',
    };
  }

  set currency(Map<String, String> value) {
    _box.put(currencyKey, value);
  }

  bool get isCurrencySelect => _box.get(isCurrencySelected, defaultValue: false) as bool;

  set isCurrencySelect(bool value) => _box.put(isCurrencySelected, value);

  bool get isLanguageSelect => _box.get(isLanguageSelected, defaultValue: false) as bool;

  set isLanguageSelect(bool value) => _box.put(isLanguageSelected, value);
}
