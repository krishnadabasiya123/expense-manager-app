import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/Transaction/Cubits/add_transaction_cubit.dart';
import 'package:expenseapp/features/Transaction/Cubits/delete_transactions_cubit.dart';
import 'package:expenseapp/features/Transaction/Widgets/transaction_details_widget.dart';

import 'package:flutter/material.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({
    required this.transactions,
    super.key,
    this.isScrollable = true,
    this.filterType = TransactionType.ALL,
  });

  final bool isScrollable;
  final TransactionType filterType;

  final List<Map<String, dynamic>> transactions;

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView.builder(
      shrinkWrap: true,
      physics: widget.isScrollable ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
      padding: EdgeInsetsDirectional.zero,
      itemCount: widget.transactions.length,
      itemBuilder: (context, index) {
        final entry = widget.transactions[index];
        final date = entry['date'] as String;
        final dateItems = entry['transactions'] as List<Transaction>;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.symmetric(vertical: context.height * 0.01),
              child: Row(
                children: [
                  SizedBox(width: context.width * 0.02),
                  CustomTextView(
                    text: UiUtils.convertCustomDate(date),
                    fontSize: 14.sp(context),
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onTertiary.withValues(alpha: .8),
                  ),
                ],
              ),
            ),

            ...dateItems.map((item) {
              final type = item.type;
              final subtitle = item.title;
              final categoryName = context.read<GetCategoryCubit>().getCategoryName(item.categoryId);
              final accountName = context.read<GetAccountCubit>().getAccountName(id: item.accountId);
              final accountFromName = context.read<GetAccountCubit>().getAccountName(id: item.accountFromId);
              final accountToName = context.read<GetAccountCubit>().getAccountName(id: item.accountToId);
              final amount = item.amount;
              final isIncome = type == TransactionType.INCOME;

              return GestureDetector(
                onTap: () {
                  showTransactionDetailsBottomSheet(context, transaction: item);
                },
                child: Container(
                  margin: (dateItems.length > 1) ? EdgeInsetsDirectional.only(bottom: context.height * 0.01) : EdgeInsetsDirectional.zero,
                  padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.02, vertical: context.height * 0.0001),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .08), blurRadius: 12, offset: const Offset(0, 6))],
                  ),
                  child: Container(
                    padding: const EdgeInsetsDirectional.all(10),
                    child: Row(
                      mainAxisAlignment: .center,

                      children: [
                        Container(
                          height: 30.sp(context),
                          width: 30.sp(context),
                          decoration: BoxDecoration(
                            color: type == TransactionType.EXPENSE
                                ? Colors.red.shade100
                                : type == TransactionType.INCOME
                                ? Colors.green.shade100
                                : Colors.blue.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            type == TransactionType.EXPENSE
                                ? Icons.arrow_upward
                                : type == TransactionType.INCOME
                                ? Icons.arrow_downward
                                : Icons.transform_outlined,

                            color: type == TransactionType.EXPENSE
                                ? Colors.red
                                : type == TransactionType.INCOME
                                ? Colors.green
                                : type == TransactionType.TRANSFER
                                ? Colors.blue
                                : Colors.blue,

                            size: 20.sp(context),
                          ),
                        ),

                        SizedBox(width: context.width * 0.03),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: .center,
                            children: [
                              // CustomTextView(
                              //   text: item.recurringTransactionId,
                              //   fontWeight: FontWeight.bold,
                              //   color: Colors.black,
                              //   fontSize: context.isTablet ? 18.sp(context) : 15.sp(context),
                              //   maxLines: 3,
                              //   softWrap: true,
                              // ),
                              if (categoryName.isNotEmpty && (type == TransactionType.EXPENSE || type == TransactionType.INCOME)) ...[
                                CustomTextView(
                                  text: categoryName,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: context.isTablet ? 18.sp(context) : 15.sp(context),
                                  maxLines: 2,
                                ),
                              ] else ...[
                                if (type == TransactionType.TRANSFER) ...[
                                  CustomTextView(
                                    text: '$accountFromName → $accountToName',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: context.isTablet ? 18.sp(context) : 15.sp(context),
                                    maxLines: 2,
                                  ),
                                ],
                              ],
                              if (subtitle.isNotEmpty) ...[
                                CustomTextView(
                                  text: subtitle,
                                  color: Colors.black,
                                  fontSize: context.isTablet ? 15.sp(context) : 14.sp(context),
                                ),
                              ],
                            ],
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,

                          children: [
                            Row(
                              children: [
                                if (item.recurringId.isNotEmpty) ...[
                                  Icon(Icons.repeat, color: Colors.black, size: 15.sp(context)),
                                ],
                                SizedBox(width: context.width * 0.02),
                                CustomTextView(
                                  text: amount.formatAmt(),
                                  fontWeight: FontWeight.bold,
                                  color: isIncome
                                      ? Colors.green
                                      : type == TransactionType.TRANSFER
                                      ? Colors.blue
                                      : Colors.red,
                                ),
                              ],
                            ),

                            if (type != TransactionType.TRANSFER) CustomTextView(text: accountName, fontSize: 14.sp(context), color: Colors.grey.shade600),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

Future<void> showRecurringWarningDialog({required BuildContext context, required Transaction transaction}) async {
  final colorScheme = Theme.of(context).colorScheme;
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          }

          if (context.read<DeleteTransactionsCubit>().state is! DeleteTransactionsLoading) {
            Navigator.of(context).pop();
          }
        },
        child: AlertDialog(
          // Material 3 Icon at the top
          icon: Icon(
            Icons.warning_amber_rounded,
            color: colorScheme.error,
            size: 40.sp(context),
          ),
          title: CustomTextView(
            text: context.tr('transactionRestrictionKey'),
            textAlign: TextAlign.center,
            fontWeight: FontWeight.bold,

            fontSize: 18.sp(context),
          ),
          content: CustomTextView(
            text: context.tr('recurringDialogueMsg'),
            softWrap: true,
            maxLines: 4,
            textAlign: TextAlign.center,
            fontSize: 16.sp(context),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            BlocConsumer<DeleteTransactionsCubit, DeleteTransactionsState>(
              listener: (context, state) {
                if (state is DeleteTransactionsSuccess) {
                  Navigator.of(context).pop();
                  context.read<GetTransactionCubit>().deleteTransacionLocally(state.transaction);
                }
              },
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: CustomRoundedButton(
                        height: context.height * 0.05,
                        onPressed: () {
                          if (state is! DeleteTransactionsLoading) {
                            Navigator.of(context).pop();
                          }
                        },
                        text: context.tr('okKey'),
                        backgroundColor: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),

                    const SizedBox(width: 15),
                    Expanded(
                      child: CustomRoundedButton(
                        height: context.height * 0.05,
                        onPressed: () {
                          context.read<DeleteTransactionsCubit>().deleteTransaction(transaction);
                        },
                        isLoading: state is DeleteTransactionsLoading,
                        text: context.tr('deleteKey'),

                        backgroundColor: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      );
    },
  );
}
