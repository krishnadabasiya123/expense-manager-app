import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/core/theme/app_theme.dart';

class ThemeState {
  const ThemeState(this.appTheme);

  final AppThemeType appTheme;
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this.settingsLocalDataSource) : super(ThemeState(settingsLocalDataSource.theme == darkThemeKey ? AppThemeType.dark : AppThemeType.light));

  SystemSettingLocalData settingsLocalDataSource;

  void changeTheme(AppThemeType appTheme) {
    settingsLocalDataSource.theme = appTheme == AppThemeType.dark ? darkThemeKey : lightThemeKey;
    emit(ThemeState(appTheme));
  }
}
