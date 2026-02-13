import 'package:expenseapp/commons/cubit/currency_cubit.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:flutter/material.dart';

class SelectCurrencyScreen extends StatefulWidget {
  const SelectCurrencyScreen({super.key});

  @override
  State<SelectCurrencyScreen> createState() => _SelectCurrencyScreenState();
}

class _SelectCurrencyScreenState extends State<SelectCurrencyScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
                  CustomTextView(text: context.tr('selectCurrencyLbl'), textAlign: TextAlign.center, fontSize: 20.sp(context), fontWeight: FontWeights.bold, color: colorScheme.onSecondary),
                ],
              ),

              SizedBox(height: context.height * 0.01),

              Expanded(
                child: BlocBuilder<CurrencyCubit, String>(
                  builder: (context, selectedCurrencyName) {
                    return RadioGroup<String>(
                      groupValue: selectedCurrencyName,
                      onChanged: (value) {
                        if (value == null) return;
                        context.read<CurrencyCubit>().updateCurrencyByName(value);
                      },
                      child: ListView.builder(
                        padding: EdgeInsetsDirectional.zero,
                        itemCount: currecyList.length,
                        itemBuilder: (context, index) {
                          final currency = currecyList[index];
                          final isSelected = currency['name']! == selectedCurrencyName;
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
                              value: currency['name']!,
                              activeColor: Colors.white,
                              title: CustomTextView(
                                text: currency['name']!,
                                fontSize: context.isTablet ? 18.sp(context) : 16.sp(context),
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              Container(
                padding: const EdgeInsetsDirectional.all(5),
                child: Align(
                  alignment: Alignment.bottomRight,

                  child: FloatingActionButton(
                    onPressed: () {
                      Hive.box<dynamic>(settingsBox).put(isCurrencySelected, true);
                      Navigator.of(context).pushReplacementNamed(Routes.bottomNavigationBar);
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
  }
}
