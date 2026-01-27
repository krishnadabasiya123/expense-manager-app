import 'package:expenseapp/commons/cubit/theme_cubit.dart';
import 'package:expenseapp/core/app/all_import_file.dart';

import 'package:expenseapp/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

void showThemeSelectorSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: UiUtils.bottomSheetTopRadius),
    constraints: BoxConstraints(
      maxHeight: context.screenHeight * (context.isMobile ? 1.0 : 0.95),
      minHeight: context.screenWidth * (context.isMobile ? 1.0 : 0.95),
    ),
    builder: (_) => const _ThemeSelectorWidget(),
  );
}

class _ThemeSelectorWidget extends StatelessWidget {
  const _ThemeSelectorWidget();

  @override
  Widget build(BuildContext context) {
    final size = context;

    return Container(
      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: UiUtils.bottomSheetTopRadius),
      padding: EdgeInsetsDirectional.only(top: size.height * .02),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        bloc: context.read<ThemeCubit>(),
        builder: (context, state) {
          AppThemeType? currTheme = state.appTheme;
          final colorScheme = Theme.of(context).colorScheme;

          return Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: size.width * UiUtils.hzMarginPct),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                Align(
                  child: CustomTextView(text: context.tr('themeKey'), fontWeight: FontWeight.w800, fontSize: 18.sp(context), color: colorScheme.onTertiary),
                ),

                Divider(color: colorScheme.onTertiary.withValues(alpha: 0.2), thickness: 1),
                SizedBox(height: size.height * 0.02),

                Container(
                  decoration: BoxDecoration(
                    color: currTheme == AppThemeType.light ? Theme.of(context).primaryColor : colorScheme.onTertiary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RadioListTile<AppThemeType>(
                    toggleable: true,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    tileColor: colorScheme.onTertiary.withValues(alpha: 0.2),
                    value: AppThemeType.light,
                    groupValue: currTheme,
                    activeColor: Colors.white,
                    title: Text(
                      context.tr('lightTheme'),
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp(context), color: currTheme == AppThemeType.light ? Colors.white : colorScheme.onTertiary),
                    ),
                    secondary: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: currTheme == AppThemeType.light ? Colors.white : colorScheme.onTertiary.withValues(alpha: 0.2)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsetsDirectional.all(2),
                      child: const QImage(imageUrl: AppImages.loginScreen, width: 76, height: 28),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (v) {
                      currTheme = v;
                      context.read<ThemeCubit>().changeTheme(currTheme!);
                    },
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Container(
                  decoration: BoxDecoration(
                    color: currTheme == AppThemeType.dark ? Theme.of(context).primaryColor : colorScheme.onTertiary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RadioListTile<AppThemeType>(
                    toggleable: true,
                    value: AppThemeType.dark,
                    groupValue: currTheme,
                    activeColor: Colors.white,
                    title: Text(
                      context.tr('darkTheme'),
                      style: TextStyle(fontWeight: FontWeights.medium, fontSize: 16.sp(context), color: currTheme == AppThemeType.dark ? Colors.white : colorScheme.onTertiary),
                    ),
                    secondary: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: currTheme == AppThemeType.dark ? Colors.white : colorScheme.onTertiary.withValues(alpha: 0.2)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsetsDirectional.all(2),
                      child: const QImage(imageUrl: AppImages.loginScreen, width: 76, height: 28),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (v) {
                      currTheme = v;
                      context.read<ThemeCubit>().changeTheme(currTheme!);
                    },
                  ),
                ),

                ///
                const Spacer(),
                CustomRoundedButton(
                  onPressed: () => Navigator.pop(context),
                  // width: 1,
                  backgroundColor: Theme.of(context).primaryColor,
                  text: context.tr('addKey'),
                  borderRadius: BorderRadius.circular(8),
                  height: 45.sp(context),
                  // height: context.isTablet ? context.height * 0.035 : context.height * 0.05,
                  //height: FontSizeExtension(45).sp(context),
                  textStyle: TextStyle(fontSize: 16.sp(context)),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
