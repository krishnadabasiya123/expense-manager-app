
import 'package:expenseapp/commons/models/Language.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/localization/auth_localization_cubit.dart';
import 'package:flutter/material.dart';

Future<void> showLanguageSelectorSheet(BuildContext context) async {
  return showModalBottomSheet<void>(
    context: context,
    constraints: BoxConstraints(
      maxHeight: context.screenHeight * (context.isMobile ? 1.2 : 0.95),
      minHeight: context.screenHeight * (context.isMobile ? 1.2 : 0.95),
    ),
    shape: const RoundedRectangleBorder(borderRadius: UiUtils.bottomSheetTopRadius),
    builder: (_) => const _LanguageSelectorWidget(),
  );
}

class _LanguageSelectorWidget extends StatelessWidget {
  const _LanguageSelectorWidget();

  @override
  Widget build(BuildContext context) {
    final size = context;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: UiUtils.bottomSheetTopRadius),
      padding: EdgeInsetsDirectional.only(top: size.height * .02),
      child: BlocConsumer<AppLocalizationCubit, AppLocalizationState>(
        listener: (context, state) {},
        builder: (context, state) {
          final textStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp(context), color: Theme.of(context).colorScheme.onTertiary);

          var currLangId = state.language.languageCode;

          return Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: size.width * UiUtils.hzMarginPct),
            child: Column(
              children: [
                CustomTextView(text: context.tr('selectLanguageKey'), fontWeight: FontWeight.w800, fontSize: 18.sp(context), color: colorScheme.onTertiary),
                const Divider(),
                Expanded(
                  child: Container(
                    margin: EdgeInsetsDirectional.zero,
                    constraints: BoxConstraints(minHeight: size.height * .2, maxHeight: size.height * .4),
                    child: ListView.separated(
                      itemBuilder: (_, i) {
                        final supportedLanguage = supportedLocales[i];
                        final languageId = supportedLanguage;
                        final languageName = languageModels[supportedLanguage]!.name;
                        final colorScheme = Theme.of(context).colorScheme;
                        return Container(
                          decoration: BoxDecoration(
                            color: currLangId == languageId ? Theme.of(context).primaryColor : colorScheme.onTertiary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: RadioListTile(
                            toggleable: true,
                            activeColor: Colors.white,
                            value: languageId,
                            title: CustomTextView(
                              text: languageName,
                              color: currLangId == languageId ? Colors.white : colorScheme.onTertiary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp(context),
                            ),
                            groupValue: currLangId,
                            onChanged: (value) {
                              if (value == null) return;
                              currLangId = value;
                              context.read<AppLocalizationCubit>().changeLanguage(value);
                            },
                          ),
                        );
                      },
                      separatorBuilder: (_, i) => const SizedBox(height: 12),
                      itemCount: supportedLocales.length,
                    ),
                  ),
                ),

                CustomRoundedButton(
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: Theme.of(context).primaryColor,
                  text: context.tr('addKey'),
                  borderRadius: BorderRadius.circular(8),
                  height: 45.sp(context),
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
