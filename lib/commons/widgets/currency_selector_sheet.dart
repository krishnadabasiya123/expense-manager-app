import 'package:expenseapp/commons/cubit/currency_cubit.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:flutter/material.dart';

Future<void> showCurrencySelectorSheet(BuildContext context) async {
  return showModalBottomSheet<void>(
    context: context,

    constraints: BoxConstraints(
      maxHeight: context.screenHeight * (context.isMobile ? 1.0 : 0.95),
      minHeight: context.screenHeight * (context.isMobile ? 1.0 : 0.95),
    ),
    shape: const RoundedRectangleBorder(borderRadius: UiUtils.bottomSheetTopRadius),
    builder: (_) => const CurrencySelectorWidget(),
  );
}

class CurrencySelectorWidget extends StatefulWidget {
  const CurrencySelectorWidget({super.key});

  @override
  State<CurrencySelectorWidget> createState() => _CurrencySelectorWidgetState();
}

class _CurrencySelectorWidgetState extends State<CurrencySelectorWidget> {
  // late String selectedCurrency;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final colorScheme = Theme.of(context).colorScheme;

    final textStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: colorScheme.onTertiary);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: UiUtils.bottomSheetTopRadius),
        padding: EdgeInsetsDirectional.only(top: size.height * .02),
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: size.width * UiUtils.hzMarginPct),
          child: Column(
            children: [
              CustomTextView(text: context.tr('selectCurrencyKey'), fontWeight: FontWeight.w800, fontSize: 18.sp(context), color: colorScheme.onTertiary),

              const Divider(),

              Expanded(
                child: BlocBuilder<CurrencyCubit, String>(
                  builder: (context, selectedCurrencyName) {
                    return RadioGroup<String>(
                      groupValue: selectedCurrencyName,
                      onChanged: (value) {
                        if (value != null) {
                          context.read<CurrencyCubit>().updateCurrencyByName(value);
                        }
                      },
                      child: ListView.builder(
                        padding: EdgeInsetsDirectional.zero,
                        itemCount: currecyList.length,
                        itemBuilder: (context, index) {
                          final currency = currecyList[index];
                          final currencyName = currency['name']!;
                          final isSelected = currencyName == selectedCurrencyName;

                          return Container(
                            margin: EdgeInsetsDirectional.only(bottom: context.height * 0.012),
                            padding: EdgeInsetsDirectional.symmetric(
                              horizontal: context.width * 0.01,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: isSelected ? colorScheme.primary : colorScheme.onTertiary.withValues(alpha: 0.1),
                            ),
                            child: RadioListTile<String>(
                              value: currencyName,
                              activeColor: Colors.white,
                              title: CustomTextView(
                                text: currencyName,
                                fontSize: 16.sp(context),
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeights.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              CustomRoundedButton(
                onPressed: () => Navigator.pop(context),
                backgroundColor: Theme.of(context).primaryColor,
                text: context.tr('addKey'),
                borderRadius: BorderRadius.circular(8),
                height: 45.sp(context),
                textStyle: TextStyle(fontSize: 18.sp(context)),
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
