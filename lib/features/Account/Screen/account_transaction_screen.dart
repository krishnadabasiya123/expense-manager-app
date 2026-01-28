import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/Transaction/Widgets/transaction_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountTransactionScreen extends StatefulWidget {
  const AccountTransactionScreen({required this.account, super.key});
  final Account account;

  @override
  State<AccountTransactionScreen> createState() => _AccountTransactionScreenState();

  static Route<dynamic> route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments! as Map;
    return MaterialPageRoute(
      builder: (_) => AccountTransactionScreen(
        account: arguments['account'] as Account,
      ),
    );
  }
}

class _AccountTransactionScreenState extends State<AccountTransactionScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: colorScheme.surface),
        backgroundColor: colorScheme.primary,
        title: CustomTextView(text: widget.account.name, fontSize: 20.sp(context), color: colorScheme.surface),
      ),
      body: Column(
        children: [
          Expanded(
            child: ResponsivePadding(
              leftPadding: context.width * 0.05,
              rightPadding: context.width * 0.05,
              child: Column(
                children: [
                  Expanded(
                    child: BlocConsumer<GetTransactionCubit, GetTransactionState>(
                      listener: (context, state) {
                        if (state is GetTransactionFailure) {
                          UiUtils.showCustomSnackBar(context: context, errorMessage: state.message);
                        }
                      },
                      builder: (context, state) {
                        if (state is GetTransactionSuccess) {
                          final data = context.read<GetTransactionCubit>().getTransactionByAccountId(accountId: widget.account.id);

                          if (data.isEmpty) {
                            return NoDataFoundScreen(title: context.tr('noTransactionFnd'), subTitle: context.tr('noTransactionFndPlsAdd'));
                          }

                          return TransactionList(
                            transactions: data,

                            // filterType: selectedTab.value,
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
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: context.height * 0.01),

          BlocBuilder<GetTransactionCubit, GetTransactionState>(
            builder: (context, state) {
              final totalIncome = context.read<GetTransactionCubit>().getTotalIncomeByAccountId(accountId: widget.account.id);
              final totalExpense = context.read<GetTransactionCubit>().getTotalExpenseByAccountId(accountId: widget.account.id);
              final totalActualBalance = totalIncome - totalExpense + widget.account.amount;
              return _buildBalanceDetails(
                initialBalance: widget.account.amount,
                totalIncome: totalIncome,
                totalExpense: totalExpense,
                totalActualBalance: totalActualBalance,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceDetails({required double initialBalance, required double totalIncome, required double totalExpense, required double totalActualBalance}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsetsDirectional.only(top: context.height * 0.01, start: context.width * 0.05, end: context.width * 0.05, bottom: context.height * 0.02),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 30,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          CustomTextView(text: 'Summary', fontSize: 16.sp(context), color: Colors.black, fontWeight: FontWeight.bold),
          // const SizedBox(height: 10),
          _summaryRow(context.tr('initialBalanceKey'), initialBalance.formatAmt()),
          _summaryRow(context.tr('totalIncomeKey'), totalIncome.formatAmt(), color: Colors.green),
          _summaryRow(context.tr('totalExpenseKey'), totalExpense.formatAmt(), color: Colors.red),

          const CustomHorizontalDivider(
            endOpacity: 0.2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextView(
                text: context.tr('actualBalanceKey'),
                fontSize: 16.sp(context),
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              CustomTextView(
                text: '${context.symbol} ${totalActualBalance.formatAmt()}',
                fontSize: 20.sp(context),
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomTextView(text: label, fontSize: 16.sp(context), color: Colors.black),
          CustomTextView(text: '${context.symbol} $value', fontSize: 16.sp(context), color: color, fontWeight: FontWeight.bold),
        ],
      ),
    );
  }
}
