
import 'package:expenseapp/core/app/all_import_file.dart';

class CurrencyCubit extends Cubit<String> {
  CurrencyCubit(this.settingsLocalDataSource) : super(settingsLocalDataSource.currency['name'] ?? 'Dollar');
  final SystemSettingLocalData settingsLocalDataSource;

  void updateCurrencyByName(String name) {
    final currency = currecyList.firstWhere(
      (e) => e['name'] == name,
      orElse: () => defaultCurrencyKey,
    );

    settingsLocalDataSource.currency = Map<String, String>.from(currency);

    emit(name);
  }

  String get symbol => settingsLocalDataSource.currency['symbol'] ?? r'$';
}
