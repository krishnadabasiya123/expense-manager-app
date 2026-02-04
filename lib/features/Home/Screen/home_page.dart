import 'package:expenseapp/commons/widgets/BottomNavigationPageChange.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/Home/Cubits/edit_home_cubit.dart';
import 'package:expenseapp/features/Home/Model/HomeMenuItem.dart';
import 'package:expenseapp/features/Home/Model/enums/HomeMenuType.dart';
import 'package:expenseapp/features/Transaction/Widgets/transaction_list_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<HomeMenuItem> homeMenuData = [];

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
    final colorScheme = Theme.of(context).colorScheme;
    switch (type) {
      case HomeMenuType.TRANSACTION_LIST:
        return _displayTransactionList();

      case HomeMenuType.BUDGETS:
        return const Text('Text Widget BUDGETS ');

      case HomeMenuType.INCOME_EXPENSE:
        return _buildIncomExpenseCard();

      case HomeMenuType.NET_WORTH:
        return _buildNetWorthCard();

      default:
        return const SizedBox();
    }
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
                  child: _buildCard(text: context.tr('expenseKey'), amount: totalExpense, color: context.colorScheme.expenseColor, count: expenseTransactionCount),
                ),
                SizedBox(width: context.width * 0.03),
                Expanded(
                  child: _buildCard(text: context.tr('incomeKey'), amount: totalIncome, color: context.colorScheme.incomeColor, count: incomeTransactionCount),
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
