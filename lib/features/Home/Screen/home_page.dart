import 'package:expenseapp/commons/widgets/BottomNavigationPageChange.dart';
import 'package:expenseapp/commons/widgets/custom_painter.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/Home/Cubits/edit_home_cubit.dart';
import 'package:expenseapp/features/Home/Model/HomeMenuItem.dart';
import 'package:expenseapp/features/Home/Model/enums/HomeMenuType.dart';
import 'package:expenseapp/features/Transaction/Widgets/transaction_list_widget.dart';
import 'package:expenseapp/features/budget/cubits/get_budget_cubit.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<HomeMenuItem> homeMenuData = [];
  String label = '';
  double left = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    selectedAccountId.dispose();
    selectedTab.dispose();
    super.dispose();
  }

  String? lastDate;
  String? previousDate;

  ValueNotifier<String> selectedAccountId = ValueNotifier('-1');
  ValueNotifier<TransactionType> selectedTab = ValueNotifier(TransactionType.ALL);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: QAppBar(
        title: CustomTextView(text: context.tr('homeKey'), fontSize: 25.sp(context), fontWeight: FontWeight.bold, color: colorScheme.surface),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.editHomeScreen);
            },
            icon: Icon(Icons.menu, color: colorScheme.surface),
          ),
        ],
      ),
      body: ResponsivePadding(
        bottomPadding: context.height * 0.01,
        leftPadding: context.width * 0.05,
        rightPadding: context.width * 0.05,
        child: SingleChildScrollView(
          child: BlocBuilder<EditHomeCubit, EditHomeState>(
            builder: (context, state) {
              if (state is EditHomeSuccess) {
                homeMenuData = state.menuItems;

                final menuMap = context.read<EditHomeCubit>().getMenuMapFromSaved(homeMenuData);

                final List<Widget> widgets = menuMap
                    .map(
                      (type) => ValueListenableBuilder(
                        valueListenable: selectedAccountId,
                        builder: (context, value, child) {
                          return getWidgetByType(type, selectedAccountId);
                        },
                      ),
                    )
                    .toList();

                return SingleChildScrollView(
                  child: Column(crossAxisAlignment: .start, children: widgets),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget getWidgetByType(HomeMenuType type, ValueNotifier<String> selectedAccountId) {
    switch (type) {
      case HomeMenuType.TRANSACTION_LIST:
        return _displayTransactionList();

      case HomeMenuType.BUDGETS:
        return _buildBudgetCard();

      case HomeMenuType.INCOME_EXPENSE:
        return _buildIncomExpenseCard();

      case HomeMenuType.NET_WORTH:
        return _buildNetWorthCard();

      default:
        return const SizedBox();
    }
  }

  Widget _buildBudgetCard() {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<GetTransactionCubit, GetTransactionState>(
      builder: (context, state) {
        if (state is GetTransactionSuccess) {
          return BlocBuilder<GetBudgetCubit, GetBudgetState>(
            builder: (context, state) {
              log('GetBudgetSuccess $state');
              if (state is GetBudgetSuccess) {
                final budgetList = context.read<GetBudgetCubit>().getBudgetList(count: 3);
                if (budgetList.isEmpty) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.addBudget);
                    },
                    child: Container(
                      margin: EdgeInsetsDirectional.only(top: context.height * 0.01),
                      padding: EdgeInsetsDirectional.all(context.width * 0.05),
                      width: context.width * 0.9,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colorScheme.primary),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.format_list_bulleted_add, color: colorScheme.primary, size: 40.sp(context)),
                          // const SizedBox(height: 5),
                          CustomTextView(text: context.tr('noBudgetFound'), fontSize: 18.sp(context), fontWeight: FontWeight.bold, softWrap: true, maxLines: 3),
                        ],
                      ),
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: .start,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(top: 5, bottom: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextView(text: context.tr('budgetKey'), fontSize: 18.sp(context), fontWeight: FontWeight.bold, softWrap: true, maxLines: 3),
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.budget);
                            },
                            child: Center(
                              child: CustomTextView(
                                text: context.tr('viewAllKey'),
                                fontSize: 12.sp(context),
                                color: colorScheme.onTertiary.withValues(alpha: 0.5),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      padding: EdgeInsetsDirectional.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: budgetList.length,
                      itemBuilder: (context, index) {
                        final item = budgetList[index];
                        final result = context.read<GetTransactionCubit>().getTotalBudgetSpent(categoryIds: item.catedoryId, type: item.type, date: item.endDate);

                        final spent = result;
                        final percent = (spent / item.amount) * 100;

                        final limit = item.amount;
                        final parseEndDate = UiUtils.parseDate(item.endDate);

                        if (item.type == TransactionType.INCOME) {
                          if (spent > limit) {
                            // Over saved
                            left = spent - limit;
                            label = context.tr('overSavedKey');
                          } else {
                            // Remaining to reach goal
                            left = limit - spent;
                            label = context.tr('leftKey');
                          }
                        } else if (item.type == TransactionType.EXPENSE) {
                          // EXPENSE
                          if (spent > limit) {
                            // Over spent
                            left = spent - limit;
                            label = context.tr('overSpentKey');
                          } else {
                            // Remaining budget
                            left = limit - spent;
                            label = context.tr('leftKey');
                          }
                        } else {
                          // ALL Type

                          if (spent < 0) {
                            // Income case
                            left = spent.abs();
                            label = context.tr('overSavedKey');
                          } else if (spent > limit) {
                            // Overspent
                            left = spent - limit;
                            label = context.tr('overSpentKey');
                          } else {
                            // Normal remaining
                            left = limit - spent;
                            label = context.tr('leftKey');
                          }
                        }
                        return GestureDetector(
                          onTap: () {
                            if (parseEndDate.isPast) {
                              return;
                            }
                            Navigator.pushNamed(context, Routes.budgetHistory, arguments: {'item': item});
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Container(
                                margin: const EdgeInsetsDirectional.only(bottom: 7),
                                padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.04, vertical: context.height * 0.02),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border(left: BorderSide(color: colorScheme.primary, width: 4)),
                                ),
                                child: Row(
                                  children: [
                                    // RadialPercentageResultContainer(
                                    //   percentage: percent,
                                    //   size: const Size(70, 50),

                                    //   // circleColor: Colors.grey, // Track color
                                    //   arcColor: colorScheme.primary, // Progress color
                                    //   textFontSize: 10,
                                    //   circleStrokeWidth: 3,
                                    //   arcStrokeWidth: 3,
                                    // ),
                                    RadialPercentageResultContainer(
                                      key: ValueKey('${item.budgetName}_${percent.toStringAsFixed(2)}'),
                                      percentage: percent,
                                      size: const Size(70, 50),
                                      arcColor: colorScheme.primary,
                                      circleColor: Colors.grey.shade300,
                                      arcStrokeWidth: 3,
                                      circleStrokeWidth: 3,
                                      textFontSize: 11,
                                    ),
                                    // SizedBox(width: context.width * 0.03),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomTextView(
                                            text: item.budgetName,
                                            fontSize: 14.sp(context),
                                            fontWeight: FontWeight.w600,
                                            softWrap: true,
                                            maxLines: 3,
                                          ),
                                          SizedBox(height: context.height * 0.003),
                                          CustomTextView(
                                            text: '${UiUtils.budgetCustomDate(item.startDate)} - ${UiUtils.budgetCustomDate(item.endDate)}',
                                            fontSize: 13.sp(context),
                                            //color: colorScheme.surfaceDim,
                                          ),
                                          if (parseEndDate.isPast) ...[
                                            Container(
                                              decoration: BoxDecoration(
                                                color: colorScheme.primary.withValues(alpha: 0.2),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              padding: const EdgeInsetsDirectional.symmetric(
                                                horizontal: 5,
                                                vertical: 2,
                                              ),
                                              child: CustomTextView(
                                                text: context.tr('endedKey'),
                                                fontSize: 11.sp(context),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: .end,

                                      children: [
                                        CustomTextView(
                                          text: '${context.symbol}$left ',
                                          fontSize: 15.sp(context),
                                          fontWeight: FontWeight.bold,
                                        ),

                                        CustomTextView(
                                          text: label,
                                          fontSize: 12.sp(context),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              } else if (state is GetBudgetFailure) {
                return CustomErrorWidget(errorMessage: state.error);
              }
              return const CustomCircularProgressIndicator();
            },
          );
        }
        return Container();
      },
    );
  }

  Widget _buildCard({required String text, required String amount, required int count, Color? color}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.01, vertical: context.height * 0.02),
      //   height: context.height * 0.1,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Color.fromARGB(255, 133, 131, 131), blurRadius: 15, spreadRadius: -6, offset: Offset(0, 5))],
        // border: Border.all(),
      ),
      child: Column(
        //  mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomTextView(text: text, fontSize: 16.sp(context), color: colorScheme.onTertiary, fontWeight: FontWeight.bold),

          CustomTextView(
            text: '${context.symbol} $amount',
            fontSize: 18.sp(context),
            color: color,
            fontWeight: FontWeight.bold,
          ),

          CustomTextView(
            text: '$count ${context.tr('transactionsKey')}',
            fontSize: 14.sp(context),
            color: colorScheme.surfaceDim,
          ),
        ],
      ),
    );
  }

  Widget _buildNetWorthCard() {
    return Column(
      children: [
        SizedBox(height: context.height * 0.01),
        SizedBox(
          width: context.width,
          child: BlocBuilder<GetTransactionCubit, GetTransactionState>(
            builder: (context, state) {
              final totalBalance = context.read<GetTransactionCubit>().getTotalBalance().formatAmt();
              final incomeTransactionCount = context.read<GetTransactionCubit>().totalIncomeTransactionCount();
              final expenseTransactionCount = context.read<GetTransactionCubit>().totalExpenseTransactionCount();

              final count = incomeTransactionCount + expenseTransactionCount;
              return _buildCard(text: context.tr('netWorthKey'), amount: totalBalance, count: count);
            },
          ),
        ),
        SizedBox(height: context.height * 0.01),
      ],
    );
  }

  Widget _buildIncomExpenseCard() {
    return Column(
      children: [
        SizedBox(height: context.height * 0.01),
        BlocBuilder<GetTransactionCubit, GetTransactionState>(
          builder: (context, state) {
            final totalExpense = context.read<GetTransactionCubit>().getTotalExpense().formatAmt();
            final totalIncome = context.read<GetTransactionCubit>().getTotalIncome().formatAmt();
            final incomeTransactionCount = context.read<GetTransactionCubit>().totalIncomeTransactionCount();
            final expenseTransactionCount = context.read<GetTransactionCubit>().totalExpenseTransactionCount();

            return Row(
              children: [
                Expanded(
                  child: _buildCard(text: context.tr('expenseKey'), amount: totalExpense, color: Colors.red, count: expenseTransactionCount),
                ),
                SizedBox(width: context.width * 0.03),
                Expanded(
                  child: _buildCard(text: context.tr('incomeKey'), amount: totalIncome, color: Colors.green, count: incomeTransactionCount),
                ),
              ],
            );
          },
        ),

        SizedBox(height: context.height * 0.01),
      ],
    );
  }

  Widget _displayTransactionList() {
    final colorScheme = Theme.of(context).colorScheme;
    return ValueListenableBuilder(
      valueListenable: selectedTab,
      builder: (context, value, child) {
        return BlocConsumer<GetTransactionCubit, GetTransactionState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is GetTransactionSuccess) {
              final transactions = context.read<GetTransactionCubit>().getTransactionByFilterDate(selectedTab: selectedTab.value, count: 5);
              return Column(
                crossAxisAlignment: .start,
                children: [
                  SizedBox(height: context.height * 0.01),
                  Container(
                    padding: const EdgeInsetsDirectional.all(4),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SizedBox(
                      height: 35.sp(context),
                      child: Row(
                        children: [
                          segmentItem(context, tab: TransactionType.ALL, text: context.tr('allKey')),
                          segmentItem(context, tab: TransactionType.EXPENSE, text: context.tr('expenseKey')),
                          segmentItem(context, tab: TransactionType.INCOME, text: context.tr('incomeKey')),
                        ],
                      ),
                    ),
                  ),
                  TransactionList(transactions: transactions, isScrollable: false),
                  SizedBox(height: context.height * 0.01),
                  if (transactions.length >= 5) ...[
                    GestureDetector(
                      onTap: () {
                        bottomNavKey.currentState?.changeTab(1);
                      },
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.3), borderRadius: const BorderRadius.all(Radius.circular(15))),
                          padding: EdgeInsetsDirectional.symmetric(vertical: context.height * 0.005, horizontal: context.width * 0.04),
                          child: CustomTextView(
                            text: context.tr('viewAllTransactionsKey'),
                            fontSize: 12.sp(context),
                            color: colorScheme.onTertiary.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: context.height * 0.01),
                ],
              );
            }
            if (state is GetTransactionFailure) {
              return CustomErrorWidget(
                errorMessage: context.tr('dataNotFound'),
                onRetry: () {
                  context.read<GetTransactionCubit>().fetchTransaction();
                },
              );
            }
            return const CustomCircularProgressIndicator();
          },
        );
      },
    );
  }

  Widget segmentItem(BuildContext context, {required TransactionType tab, required String text}) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = selectedTab.value == tab;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          selectedTab.value = tab;
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected ? [const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))] : [],
          ),
          alignment: Alignment.center,
          child: CustomTextView(
            text: text,
            fontSize: 15.sp(context),
            color: isSelected ? Colors.white : colorScheme.primary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
