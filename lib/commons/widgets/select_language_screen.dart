import 'package:expenseapp/commons/models/Language.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/localization/auth_localization_cubit.dart';
import 'package:flutter/material.dart';

class InitialLanguageSelectionScreen extends StatefulWidget {
  const InitialLanguageSelectionScreen({super.key});

  @override
  State<InitialLanguageSelectionScreen> createState() => _InitialLanguageSelectionScreenState();
}

class _InitialLanguageSelectionScreenState extends State<InitialLanguageSelectionScreen> {
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<AppLocalizationCubit, AppLocalizationState>(
      builder: (context, state) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsetsDirectional.only(top: context.height * 0.09),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: ResponsivePadding(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  SizedBox(height: context.height * 0.03),
                  Row(
                    children: [
                      SizedBox(width: context.width * 0.05),
                      CustomTextView(text: context.tr('selectLanguageLbl'), textAlign: TextAlign.center, fontSize: 20.sp(context), fontWeight: FontWeights.bold, color: colorScheme.onSecondary),
                    ],
                  ),

                  SizedBox(height: context.height * 0.01),
                  Expanded(
                    child: RadioGroup<String>(
                      groupValue: state.language.languageCode,
                      onChanged: (value) {
                        if (value != null) {
                          context.read<AppLocalizationCubit>().changeLanguage(value);
                        }
                      },
                      child: ListView.builder(
                        padding: EdgeInsetsDirectional.zero,
                        itemCount: supportedLocales.length,
                        itemBuilder: (context, index) {
                          final langCode = supportedLocales[index];
                          final selectedLang = state.language.languageCode;
                          final languageName = languageModels[langCode]!.name;
                          final isSelected = langCode == selectedLang;

                          return Container(
                            margin: EdgeInsetsDirectional.only(bottom: context.height * 0.012),
                            padding: EdgeInsetsDirectional.symmetric(
                              horizontal: context.width * 0.01,
                              vertical: context.isTablet ? context.height * 0.007 : context.height * 0.004,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: isSelected ? colorScheme.primary : colorScheme.primary.withValues(alpha: 0.3),
                            ),
                            child: RadioListTile<String>(
                              value: langCode,
                              activeColor: Colors.white,
                              title: CustomTextView(
                                text: languageName,
                                fontSize: context.isTablet ? 18.sp(context) : 16.sp(context),
                                color: isSelected ? Colors.white : Colors.black,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsetsDirectional.all(5),
                    child: Align(
                      alignment: Alignment.bottomRight,

                      child: FloatingActionButton(
                        onPressed: () {
                          Hive.box<dynamic>(settingsBox).put(isLanguageSelected, true);
                          Navigator.of(context).pushReplacementNamed(Routes.selectCurrency);
                        },
                        child: const Icon(Icons.check_rounded, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
