import 'package:expenseapp/commons/widgets/CommonSearchController.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/Transaction/Cubits/add_transaction_cubit.dart';
import 'package:expenseapp/features/Transaction/Cubits/update_trasansaction_cubit.dart';
import 'package:expenseapp/features/Transaction/Widgets/transaction_list_widget.dart';
import 'package:expenseapp/utils/constants/Debouncer.dart';

import 'package:flutter/material.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  late final TextEditingController searchController = TextEditingController();

  ValueNotifier<TransactionType> selectedTab = ValueNotifier(TransactionType.ALL);

  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    _focusedDay = DateTime.now();
    searchController.addListener(_onSearch);

    super.initState();
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearch);
    selectedTab.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> getTransactionByFilterDate({String? searchText, DateTime? date, TransactionType? seelectedTab}) {
    return context.read<GetTransactionCubit>().getTransactionByFilterDate(date: _focusedDay, selectedTab: selectedTab.value, searchText: searchText ?? '');
  }

  void _onSearch() {
    _debouncer.run(() {
      setState(() {
        getTransactionByFilterDate(searchText: searchController.text, seelectedTab: selectedTab.value, date: _focusedDay);
      });
    });
  }

  DateTime _monthOnly(DateTime d) => DateTime(d.year, d.month);

  void _previousMonth(DateTime minDate) {
    final prevMonth = DateTime(_focusedDay.year, _focusedDay.month - 1);

    if (_monthOnly(prevMonth).isBefore(_monthOnly(minDate))) return;

    setState(() {
      _focusedDay = prevMonth;
    });
  }

  void _nextMonth(DateTime maxDate) {
    final nextMonth = DateTime(_focusedDay.year, _focusedDay.month + 1);

    if (_monthOnly(nextMonth).isAfter(_monthOnly(maxDate))) return;

    setState(() {
      _focusedDay = nextMonth;
    });
  }

  @override
  Widget build(BuildContext context) {
    final result = context.read<GetTransactionCubit>().getMinMaxDate();
    final minDate = result.minDate;
    final maxDate = result.maxDate;

    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,

      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: QAppBar(
        title: Center(
          child: CustomTextView(
            text: context.tr('transactionKey'),
            fontSize: 24.sp(context),
            color: colorScheme.surface,
          ),
        ),
      ),

      body: ResponsivePadding(
        topPadding: context.height * 0.01,
        bottomPadding: 5,
        leftPadding: context.width * 0.05,
        rightPadding: context.width * 0.05,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _previousMonth(result.minDate);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsetsDirectional.all(5),
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                        child: Icon(
                          Icons.chevron_left,
                          color: minDate == DateTime.now() ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),
                  ),

                  CustomTextView(text: UiUtils.getFormattedDate(DateTime.parse(_focusedDay.toString())), fontSize: 16.sp(context), fontWeight: FontWeight.bold),

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _nextMonth(result.maxDate);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsetsDirectional.all(5),
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                        child: Icon(Icons.chevron_right, color: maxDate == DateTime.now() ? Colors.grey : Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.height * 0.01),
              if (context.isMobile)
                Container(
                  width: double.infinity,
                  padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.055, vertical: context.height * 0.012),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF4F7DF3), Color(0xFF2F5FEA), Color(0xFF1E3A8A)]),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Stack(
                    children: [
                      BlocBuilder<GetTransactionCubit, GetTransactionState>(
                        builder: (context, state) {
                          final totalExpense = context.read<GetTransactionCubit>().getTotalExpenseFilterByMonth(_focusedDay);
                          final totalIncome = context.read<GetTransactionCubit>().getTotalIncomeFilterByMonth(_focusedDay);
                          final totalBalance = totalExpense - totalIncome;
                          return Column(
                            children: [
                              CustomTextView(text: context.tr('totalBalanceKey'), fontSize: 16.sp(context), color: colorScheme.surface),
                              CustomTextView(text: '${context.symbol} ${totalBalance.formatAmt()}', fontSize: 22.sp(context), color: Colors.white, fontWeight: FontWeight.bold),

                              Divider(color: Colors.white.withValues(alpha: 0.35), thickness: 0.8),

                              Row(
                                children: [
                                  Expanded(
                                    child: _buildAmountTile(
                                      icon: Icons.arrow_downward_rounded,
                                      label: context.tr('incomeKeyC'),
                                      amount: '+ ${context.symbol}${totalIncome.formatAmt()}',
                                      color: context.colorScheme.incomeColor,
                                    ),
                                  ),

                                  _buildAmountTile(
                                    icon: Icons.arrow_upward_rounded,
                                    label: context.tr('expenseKeyC'),
                                    amount: '- ${context.symbol}${totalExpense.formatAmt()}',
                                    color: context.colorScheme.expenseColor,
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                )
              else
                BlocBuilder<GetTransactionCubit, GetTransactionState>(
                  builder: (context, state) {
                    final expense = context.read<GetTransactionCubit>().getTotalExpense().formatAmt();

                    final income = context.read<GetTransactionCubit>().getTotalIncome().formatAmt();

                    final balance = context.read<GetTransactionCubit>().getTotalBalance().formatAmt();

                    return Row(
                      children: [
                        Expanded(
                          child: _buildCard(text: context.tr('expenseKey'), amount: expense, colorScheme: colorScheme),
                        ),
                        SizedBox(width: context.width * 0.02),
                        Expanded(
                          child: _buildCard(text: context.tr('incomeKey'), amount: income, colorScheme: colorScheme),
                        ),
                        SizedBox(width: context.width * 0.02),
                        Expanded(
                          child: _buildCard(text: context.tr('balanceKey'), amount: balance, colorScheme: colorScheme),
                        ),
                      ],
                    );
                  },
                ),

              SizedBox(height: context.height * 0.01),

              ValueListenableBuilder(
                valueListenable: selectedTab,
                builder: (context, value, child) {
                  return Column(
                    children: [
                      CommonSearchController(
                        controller: searchController,
                        hintText: context.tr('searchTransactionKey'),
                        borderRadius: 15,
                        fontSize: 14.sp(context),
                        prefixIconSize: 20.sp(context),
                      ),
                      SizedBox(height: context.height * 0.01),
                      SizedBox(
                        height: context.isTablet ? context.height * 0.038 : context.height * 0.042,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final isSelected = selectedTab.value == TransactionType.values[index];
                            return GestureDetector(
                              onTap: () {
                                selectedTab.value = TransactionType.values[index];
                              },
                              child: (TransactionType.values[index] != TransactionType.NONE)
                                  ? Container(
                                      margin: const EdgeInsetsDirectional.symmetric(horizontal: 4),
                                      decoration: BoxDecoration(color: isSelected ? colorScheme.primary : colorScheme.surface, borderRadius: BorderRadius.circular(10)),
                                      padding: EdgeInsetsDirectional.symmetric(vertical: context.height * 0.008, horizontal: context.width * 0.04),
                                      child: Center(
                                        child: CustomTextView(
                                          text: UiUtils.getTransactionTypeString(TransactionType.values[index]),
                                          fontSize: context.isTablet ? 16.sp(context) : 14.sp(context),
                                          color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            );
                          },
                          itemCount: TransactionType.values.length,
                        ),
                      ),

                      BlocConsumer<GetTransactionCubit, GetTransactionState>(
                        listener: (context, state) {
                          if (state is GetTransactionFailure) {
                            UiUtils.showCustomSnackBar(context: context, errorMessage: state.message);
                          }
                        },
                        builder: (context, state) {
                          if (state is GetTransactionSuccess) {
                            final data = getTransactionByFilterDate(date: _focusedDay, seelectedTab: selectedTab.value, searchText: searchController.text);

                            log('data $data');

                            if (data.isEmpty) {
                              return NoDataFoundScreen(title: context.tr('noTransactionFnd'), subTitle: context.tr('noTransactionFndPlsAdd'));
                            }

                            return TransactionList(
                              transactions: data,
                              isScrollable: false,
                              filterType: selectedTab.value,
                            );
                          }
                          if (state is GetTransactionFailure) {
                            return CustomErrorWidget(
                              errorMessage: context.tr('dataNotFound'),
                              onRetry: () {
                                context.read<GetTransactionCubit>().fetchTransaction();
                              },
                            );
                          } else {
                            return const CustomCircularProgressIndicator();
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountTile({required IconData icon, required String label, required String amount, required Color color}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsetsDirectional.all(6),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.2), shape: BoxShape.circle),
          child: Icon(icon, size: 16.sp(context), color: color),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextView(
              text: label,
              color: Colors.white70,
              fontSize: 12.sp(context),
            ),
            const SizedBox(height: 2),
            CustomTextView(
              text: amount,
              color: color,
              fontSize: 14.sp(context),
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCard({required String text, required String amount, required ColorScheme colorScheme}) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF4F7DF3), Color(0xFF2F5FEA), Color(0xFF1E3A8A)]),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextView(text: text, fontSize: 20.sp(context), color: colorScheme.surface, fontWeight: FontWeight.bold),

            CustomTextView(text: '${context.symbol} $amount', fontSize: 18.sp(context), color: colorScheme.surface),
          ],
        ),
      ),
    );
  }
}
