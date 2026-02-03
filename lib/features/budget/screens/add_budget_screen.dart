import 'package:expenseapp/commons/cubit/theme_cubit.dart';
import 'package:expenseapp/commons/widgets/custom_app_bar.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/core/theme/app_theme.dart';
import 'package:expenseapp/features/budget/cubits/add_budget_cubit.dart';
import 'package:expenseapp/features/budget/cubits/get_budget_cubit.dart';
import 'package:expenseapp/features/budget/cubits/update_budget_cubit.dart';
import 'package:expenseapp/features/budget/models/Budget.dart';
import 'package:expenseapp/features/budget/models/enums/BudgetPeriod.dart';
import 'package:expenseapp/features/budget/models/enums/BudgetType.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddBudgetScreen extends StatefulWidget {
  const AddBudgetScreen({super.key});

  @override
  State<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends State<AddBudgetScreen> {
  final amountCtrl = TextEditingController();
  final titleCtrl = TextEditingController();
  BudgetPeriod selectedPeriod = BudgetPeriod.WEEKLY;
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();
  final ValueNotifier<bool> isDialogueOpen = ValueNotifier(false);
  final ValueNotifier<BudgetType> selectedBudgetType = ValueNotifier(BudgetType.INCOME);

  double alert = 80;

  List<Map<String, dynamic>> categories = [];
  List<String> selectedCategories = [];

  String get selectedCategoryText {
    final selected = categories.where((c) => c['selected'] == true).map((e) => e['name']);
    return selected.isEmpty ? context.tr('selectCatgoriesLbl') : selected.join(', ');
  }

  @override
  void initState() {
    super.initState();
    categories = context.read<GetCategoryCubit>().getCatgoryListWithSelected();
    final tomorrow = DateTime.now();
    startDateController.text = DateFormat(dateFormat).format(tomorrow);
    endDateController.text = DateFormat(dateFormat).format(getNextDate(DateTime.now(), selectedPeriod));
  }

  AppThemeType newTheme = AppThemeType.dark;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AddBudgetCubit()),
        BlocProvider(create: (context) => UpdateBudgetCubit()),
      ],
      child: Builder(
        builder: (screenContext) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              if (screenContext.read<AddBudgetCubit>().state is! AddBudgetLoading) {
                Navigator.of(screenContext).pop();
                return;
              }
            },
            child: Scaffold(
              appBar: QAppBar(
                title: CustomTextView(
                  text: context.tr('addBudgetKey'),
                  fontSize: 20.sp(context),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      if (newTheme == AppThemeType.dark) {
                        newTheme = AppThemeType.light;
                        context.read<ThemeCubit>().changeTheme(newTheme);
                      } else {
                        newTheme = AppThemeType.dark;
                        context.read<ThemeCubit>().changeTheme(newTheme);
                      }
                    },
                    icon: const Icon(Icons.change_circle),
                  ),
                ],
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: ResponsivePadding(
                        topPadding: context.height * 0.01,
                        bottomPadding: context.height * 0.01,
                        leftPadding: context.width * 0.05,
                        rightPadding: context.width * 0.05,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _type(),
                            SizedBox(height: context.height * 0.02),
                            _amount(),
                            SizedBox(height: context.height * 0.02),
                            _title(),
                            SizedBox(height: context.height * 0.02),
                            _categoryPicker(),
                            SizedBox(height: context.height * 0.02),
                            _periodTabs(),
                            SizedBox(height: context.height * 0.02),
                            _dates(),
                            SizedBox(height: context.height * 0.02),
                            _alert(),
                            SizedBox(height: context.height * 0.02),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.03, vertical: context.height * 0.01),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.surfaceDim,
                          offset: const Offset(0, -2.5),
                          blurRadius: 1,
                        ),
                      ],
                    ),
                    child: BlocConsumer<AddBudgetCubit, AddBudgetState>(
                      listener: (context, addState) {
                        if (addState is AddBudgetSuccess) {
                          context.read<GetBudgetCubit>().addBudgetLocally(addState.budget);
                          Navigator.of(context).pop();
                        }
                        if (addState is AddBudgetFailure) {
                          UiUtils.showCustomSnackBar(context: context, errorMessage: addState.error);
                        }
                      },
                      builder: (context, addState) {
                        return Row(
                          children: [
                            Expanded(
                              child: CustomRoundedButton(
                                onPressed: () async {
                                  final budgetId = 'BG'.withDateTimeMillisRandom();
                                  if (amountCtrl.text.isEmpty) {
                                    UiUtils.showCustomSnackBar(context: context, errorMessage: context.tr('PlsenterBudgetAmount'));
                                    return;
                                  }
                                  if (titleCtrl.text.isEmpty) {
                                    UiUtils.showCustomSnackBar(context: context, errorMessage: context.tr('PlsenterBudgetTitle'));
                                    return;
                                  }
                                  if (selectedCategories.isEmpty) {
                                    UiUtils.showCustomSnackBar(context: context, errorMessage: context.tr('PlsselectCatgoriesLbl'));
                                    return;
                                  }
                                  context.read<AddBudgetCubit>().addBudget(
                                    Budget(
                                      budgetId: budgetId,
                                      budgetName: titleCtrl.text,
                                      amount: double.parse(amountCtrl.text),
                                      catedoryId: selectedCategories,
                                      type: selectedBudgetType.value,
                                      period: selectedPeriod,
                                      startDate: startDateController.text,
                                      endDate: endDateController.text,
                                      alertPercentage: alert.toInt(),
                                      createdAt: DateTime.now().toString(),
                                      updatedAt: DateTime.now().toString(),
                                    ),
                                  );
                                },
                                width: 1,
                                backgroundColor: colorScheme.primary,
                                text: context.tr('addKey'),
                                textStyle: TextStyle(fontSize: context.isTablet ? 18.sp(context) : 16.sp(context)),
                                borderRadius: BorderRadius.circular(8),
                                height: context.height * 0.05,
                                isLoading: addState is AddBudgetLoading,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomRoundedButton(
                                onPressed: () {
                                  if (addState is! AddBudgetLoading) {
                                    Navigator.of(context).pop();
                                  }
                                },
                                width: 1,
                                backgroundColor: Theme.of(context).primaryColor,
                                text: context.tr('cancelKey'),
                                textStyle: TextStyle(fontSize: context.isTablet ? 18.sp(context) : 16.sp(context)),

                                borderRadius: BorderRadius.circular(8),
                                height: context.height * 0.05,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _amount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextView(text: context.tr('budgetAmountLbl'), fontSize: 14.sp(context), fontWeight: FontWeight.w600),
        SizedBox(height: context.height * 0.01),
        CustomTextFormField(
          focusNode: _amountFocusNode,
          nextFocusNode: _titleFocusNode,
          textInputAction: TextInputAction.next,
          controller: amountCtrl,
          hintText: context.tr('enterBudgetAmount'),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _type() {
    final colorScheme = Theme.of(context).colorScheme;
    return ValueListenableBuilder(
      valueListenable: selectedBudgetType,
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextView(
              text: context.tr('budgetTypeLbl'),
              fontSize: 14.sp(context),
              fontWeight: FontWeight.w600,
            ),

            SizedBox(height: context.height * 0.01),

            Row(
              children: List.generate(
                BudgetType.values.length,
                (index) {
                  final isSelected = BudgetType.values[index] == selectedBudgetType.value;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
                      child: CustomRoundedButton(
                        height: context.height * 0.05,
                        backgroundColor: isSelected ? colorScheme.primary : colorScheme.surface,
                        text: UiUtils.getStringBudgetType(BudgetType.values[index]),
                        textStyle: TextStyle(
                          fontSize: context.isTablet ? 17.sp(context) : 15.sp(context),
                        ),
                        borderRadius: BorderRadius.circular(8),
                        onPressed: () {
                          selectedBudgetType.value = BudgetType.values[index];
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _title() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextView(text: context.tr('budgetTitleLbl'), fontSize: 14.sp(context), fontWeight: FontWeight.w600),
        SizedBox(height: context.height * 0.01),
        CustomTextFormField(
          controller: titleCtrl,
          hintText: context.tr('enterBudgetTitle'),
          focusNode: _titleFocusNode,
        ),
      ],
    );
  }

  // ---------- Category Picker Field
  Widget _categoryPicker() => ValueListenableBuilder(
    valueListenable: isDialogueOpen,
    builder: (context, value, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextView(text: context.tr('categoryKey'), fontSize: 14.sp(context), fontWeight: FontWeight.w600),
          SizedBox(height: context.height * 0.01),
          GestureDetector(
            onTap: () {
              _openCategorySheet();
              isDialogueOpen.value = true;
            },
            child: Container(
              padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.04, vertical: context.height * 0.02),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.category, color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(selectedCategoryText, style: const TextStyle(fontWeight: FontWeight.w500)),
                  ),
                  Icon((isDialogueOpen.value) ? Icons.expand_less : Icons.expand_more, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );

  void _openCategorySheet() {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isDismissible: false,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) {
        return StatefulBuilder(
          builder: (_, setModal) {
            return Padding(
              padding: const EdgeInsetsDirectional.all(5),
              child: Column(
                children: [
                  SizedBox(height: context.height * 0.02),
                  CustomTextView(text: context.tr('selectCatgoriesLbl'), fontSize: 18.sp(context), fontWeight: FontWeight.bold),
                  SizedBox(height: context.height * 0.01),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsetsDirectional.zero,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        return Padding(
                          padding: const EdgeInsetsDirectional.only(start: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomTextView(text: cat['name'] as String, fontSize: 15.sp(context), fontWeight: FontWeight.w300),
                              ),
                              Checkbox(
                                value: cat['selected'] as bool,
                                onChanged: (bool? value) {
                                  setModal(() {
                                    categories[index]['selected'] = value;
                                    if (value ?? false) {
                                      if (!selectedCategories.contains(cat['id'] as String)) {
                                        selectedCategories.add(cat['id'] as String);
                                      }
                                    } else {
                                      selectedCategories.remove(cat['id']);
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: categories.length,
                    ),
                  ),
                  SizedBox(height: context.height * 0.02),
                  CustomRoundedButton(
                    height: context.height * 0.05,
                    width: context.width * 0.9,

                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                      isDialogueOpen.value = false;
                    },

                    backgroundColor: Theme.of(context).primaryColor,
                    text: context.tr('doneKey'),
                    textStyle: TextStyle(fontSize: context.isTablet ? 18.sp(context) : 16.sp(context)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ---------- Period Tabs
  Widget _periodTabs() {
    final coloScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextView(text: context.tr('periodTypeLbl'), fontSize: 14.sp(context), fontWeight: FontWeight.w600),
        const SizedBox(height: 8),
        Row(
          children: BudgetPeriod.values.map((period) {
            final selected = period == selectedPeriod;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedPeriod = period;
                    final startDate = UiUtils.parseDate(startDateController.text);
                    endDateController.text = DateFormat(dateFormat).format(getNextDate(startDate, selectedPeriod));
                  });
                },
                child: Container(
                  padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
                  margin: const EdgeInsetsDirectional.all(2),
                  decoration: BoxDecoration(
                    color: selected ? Colors.white : coloScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    UiUtils.getStringBudgetPeriod(period),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: selected ? coloScheme.primary : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  DateTime getNextDate(
    DateTime current,
    BudgetPeriod frequency,
  ) {
    switch (frequency) {
      case BudgetPeriod.WEEKLY:
        return current.add(const Duration(days: 7));

      case BudgetPeriod.MONTHLY:
        return DateTime(
          current.year,
          current.month + 1,
          0,
        );

      case BudgetPeriod.YEARLY:
        return DateTime(
          current.year + 1,
          1,
          0,
        );

      case BudgetPeriod.CUSTOM:
        return DateTime.now();
    }
  }

  // ---------- Dates
  Widget _dates() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextView(text: context.tr('startDateLbl'), fontSize: 14.sp(context), fontWeight: FontWeight.w600),
              SizedBox(height: context.height * 0.01),
              CustomTextFormField(
                isReadOnly: true,
                controller: startDateController,
                onTap: () async {
                  final pickedDate = await UiUtils.selectDate(context, startDateController);

                  if (pickedDate == null) return;

                  setState(() {
                    startDateController.text = DateFormat(dateFormat).format(pickedDate);

                    final endDate = getNextDate(
                      pickedDate,
                      selectedPeriod,
                    );

                    endDateController.text = DateFormat(dateFormat).format(endDate);
                  });
                },
              ),
            ],
          ),
        ),
        SizedBox(width: context.width * 0.02),

        Expanded(
          child: Opacity(
            opacity: selectedPeriod == BudgetPeriod.CUSTOM ? 1 : .6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextView(text: context.tr('endDateLbl'), fontSize: 14.sp(context), fontWeight: FontWeight.w600),
                SizedBox(height: context.height * 0.01),
                CustomTextFormField(
                  isReadOnly: true,
                  controller: endDateController,
                  onTap: () async {
                    final pickedDate = await UiUtils.selectDate(context, endDateController);

                    if (pickedDate == null) return;

                    endDateController.text = DateFormat(dateFormat).format(pickedDate);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------- Alert
  Widget _alert() => Container(
    padding: const EdgeInsetsDirectional.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextView(
          text: 'alertKey'.tr(
            context,
            namedArgs: {
              'alert': alert.toInt().toString(),
            },
          ),
          fontSize: 14.sp(context),
          fontWeight: FontWeight.bold,
        ),
        Slider(
          value: alert,
          activeColor: Theme.of(context).colorScheme.primary,
          inactiveColor: Theme.of(context).colorScheme.primary.withValues(alpha: .2),
          max: 100,
          onChanged: (v) => setState(() => alert = v),
        ),
        CustomTextView(
          text: context.tr(
            'alertNotificationMsg'.tr(
              context,
              namedArgs: {
                'alert': alert.toInt().toString(),
              },
            ),
          ),
          fontSize: 12.sp(context),
          softWrap: true,
          maxLines: 3,
        ),
      ],
    ),
  );
}
