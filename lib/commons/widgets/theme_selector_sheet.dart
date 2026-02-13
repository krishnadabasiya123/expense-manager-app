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
          final currTheme = state.appTheme;
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

                RadioGroup<AppThemeType>(
                  groupValue: currTheme,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<ThemeCubit>().changeTheme(value);
                    }
                  },
                  child: Column(
                    children: [
                      _buildThemeTile(
                        context,
                        type: AppThemeType.light,
                        label: 'lightTheme',
                        currentSelection: currTheme,
                      ),
                      SizedBox(height: size.height * 0.01),
                      _buildThemeTile(
                        context,
                        type: AppThemeType.dark,
                        label: 'darkTheme',
                        currentSelection: currTheme,
                      ),
                    ],
                  ),
                ),

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

Widget _buildThemeTile(
  BuildContext context, {
  required AppThemeType type,
  required String label,
  required AppThemeType? currentSelection,
}) {
  final isSelected = currentSelection == type;
  final colorScheme = Theme.of(context).colorScheme;
  final contentColor = isSelected ? Colors.white : colorScheme.onTertiary;

  return Container(
    decoration: BoxDecoration(
      color: isSelected ? Theme.of(context).primaryColor : colorScheme.onTertiary.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(10),
    ),
    child: RadioListTile<AppThemeType>(
      value: type,
      toggleable: true,
      activeColor: Colors.white,
      controlAffinity: ListTileControlAffinity.leading,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        context.tr(label),
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.sp(context),
          color: contentColor,
        ),
      ),
      secondary: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: contentColor.withValues(alpha: isSelected ? 1.0 : 0.2),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsetsDirectional.all(2),
        child: const QImage(imageUrl: AppImages.loginScreen, width: 76, height: 28),
      ),
    ),
  );
}
