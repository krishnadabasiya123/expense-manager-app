import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/Restore/Cubit/get_soft_delete_party_transaction_cubit.dart';
import 'package:expenseapp/features/Restore/Cubit/get_soft_delete_transactions_cubit.dart';
import 'package:expenseapp/features/Restore/Cubit/restore_transaction_cubit.dart';
import 'package:expenseapp/features/Restore/Cubit/soft_delete_transaction_cubit.dart';
import 'package:flutter/material.dart';

class SoftDeleteTransactionList extends StatelessWidget {
  const SoftDeleteTransactionList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetSoftDeleteTransactionsCubit, GetSoftDeleteTransactionsState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is GetSoftDeleteTransactionsSuccess) {
          final transactions = state.transactions;

          if (transactions.isEmpty) {
            return CustomErrorWidget(
              errorMessage: context.tr('noDataFound'),
              errorType: CustomErrorType.noDataFound,
              onRetry: () {
                context.read<GetSoftDeleteTransactionsCubit>().getSoftDeleteTransactions();
              },
            );
          }

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              final accountName = context.read<GetAccountCubit>().getAccountName(id: transaction.accountId ?? '');
              final accountFromName = context.read<GetAccountCubit>().getAccountName(id: transaction.accountFromId ?? '');
              final accountToName = context.read<GetAccountCubit>().getAccountName(id: transaction.accountToId ?? '');
              final categoryName = context.read<GetCategoryCubit>().getCategoryName(transaction.categoryId ?? '');
              return RestoreTransactionCard(
                transaction: transaction,
                subtitle: transaction.title ?? '',
                amount: transaction.amount.formatAmt(),
                account: accountName,
                type: transaction.type,
                accountFromName: accountFromName,
                accountToName: accountToName,
                categoryName: categoryName,
              );
            },
          );
        }
        if (state is GetSoftDeleteTransactionsFailure) {
          return CustomErrorWidget(
            errorMessage: context.tr('dataNotFound'),
            onRetry: () {
              context.read<GetSoftDeleteTransactionsCubit>().getSoftDeleteTransactions();
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class RestoreTransactionCard extends StatefulWidget {
  const RestoreTransactionCard({
    required this.transaction,
    required this.subtitle,
    required this.amount,
    required this.account,
    required this.type,
    required this.accountFromName,
    required this.accountToName,
    required this.categoryName,
    super.key,
  });
  final Transaction transaction;
  final String subtitle;
  final String amount;
  final String account;
  final String accountFromName;
  final String accountToName;
  final String categoryName;
  final TransactionType type;

  @override
  State<RestoreTransactionCard> createState() => _RestoreTransactionCardState();
}

class _RestoreTransactionCardState extends State<RestoreTransactionCard> {
  bool isIncome = false;
  bool isExpense = false;
  bool isTransfer = false;

  @override
  void initState() {
    super.initState();
    isIncome = widget.type == TransactionType.INCOME;
    isExpense = widget.type == TransactionType.EXPENSE;
    isTransfer = widget.type == TransactionType.TRANSFER;
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.type.color;

    return Opacity(
      opacity: 1,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsetsDirectional.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: .center,

                children: [
                  Container(
                    height: 30.sp(context),
                    width: 30.sp(context),
                    decoration: BoxDecoration(
                      color: color!.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.type.icon,

                      color: color,

                      size: 20.sp(context),
                    ),
                  ),

                  SizedBox(width: context.width * 0.02),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: .center,
                      children: [
                        if (widget.categoryName.isNotEmpty && (isExpense || isIncome)) ...[
                          CustomTextView(
                            text: widget.categoryName,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: context.isTablet ? 18.sp(context) : 15.sp(context),
                            maxLines: 2,
                          ),
                        ] else ...[
                          if (isTransfer) ...[
                            if (widget.accountFromName.isNotEmpty && widget.accountToName.isNotEmpty) ...[
                              CustomTextView(
                                text: '${widget.accountFromName} → ${widget.accountToName}',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: context.isTablet ? 18.sp(context) : 15.sp(context),
                                maxLines: 2,
                              ),
                            ],
                          ],
                        ],
                        if (widget.subtitle.isNotEmpty) ...[
                          CustomTextView(
                            text: widget.subtitle,
                            color: Colors.black,
                            fontSize: context.isTablet ? 16.sp(context) : 15.sp(context),
                          ),
                        ],
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,

                    children: [
                      CustomTextView(
                        text: widget.amount,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),

                      if (widget.type != TransactionType.TRANSFER) CustomTextView(text: widget.account, fontSize: 14.sp(context), color: Colors.grey.shade600),
                    ],
                  ),
                ],
              ),
              SizedBox(height: context.height * 0.002),
              const CustomHorizontalDivider(endOpacity: 0.2),
              SizedBox(height: context.height * 0.002),

              Row(
                children: [
                  Expanded(
                    child: CustomRoundedButton(
                      height: context.isTablet ? context.height * 0.038 : context.height * 0.045,
                      icon: Icon(Icons.restore, color: context.colorScheme.incomeColor, size: 20.sp(context)),
                      backgroundColor: context.colorScheme.incomeColor.withValues(alpha: 0.08),
                      text: context.tr('restoreKey'),
                      borderRadius: BorderRadius.circular(8),
                      onPressed: () {
                        showRestoreDialogue(context: context, transaction: widget.transaction);
                      },
                      //isLoading: state is RestoreTransactionLoading,
                      textStyle: TextStyle(color: context.colorScheme.incomeColor, fontSize: 14.sp(context)),
                      borderSide: BorderSide(color: context.colorScheme.incomeColor),
                    ),
                  ),

                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomRoundedButton(
                      height: context.isTablet ? context.height * 0.038 : context.height * 0.045,
                      icon: Icon(Icons.delete, color: context.colorScheme.expenseColor, size: 20.sp(context)),
                      backgroundColor: context.colorScheme.expenseColor.withValues(alpha: 0.08),
                      text: context.tr('deleteKey'),
                      textStyle: TextStyle(color: context.colorScheme.expenseColor, fontSize: 14.sp(context)),
                      borderSide: BorderSide(color: context.colorScheme.expenseColor),
                      // textStyle: const TextStyle(color: context.colorScheme.expenseColor),
                      borderRadius: BorderRadius.circular(8),
                      onPressed: () {
                        showDeleteAlertDialog(context: context, transaction: widget.transaction);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showDeleteAlertDialog({required Transaction transaction, required BuildContext context}) async {
    context.showAppDialog(
      child: BlocProvider(
        create: (context) => SoftDeleteTransactionCubit(),
        child: Builder(
          builder: (dialogContext) {
            return Center(
              child: PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop) return;
                  if (dialogContext.read<SoftDeleteTransactionCubit>().state is! SoftDeleteTransactionLoading) {
                    Navigator.of(dialogContext).pop();
                    return;
                  }
                },
                child: AlertDialog(
                  constraints: BoxConstraints(maxHeight: context.height * 0.45, maxWidth: context.width * 0.85),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: CustomTextView(text: context.tr('deleteAccountTitleKey'), fontWeight: FontWeight.bold, fontSize: 18.sp(context)),
                  content: CustomTextView(text: context.tr('deleteRestoreTransactionDialogMsg'), softWrap: true, maxLines: 3),
                  actions: [
                    BlocConsumer<SoftDeleteTransactionCubit, SoftDeleteTransactionState>(
                      listener: (context, state) {
                        if (state is SoftDeleteTransactionSuccess) {
                          context.read<GetSoftDeleteTransactionsCubit>().getSoftDeleteTransactionLocally(transaction);

                          if (state.transaction.partyTransactionId.isNotEmpty) {
                            context.read<GetSoftDeletePartyTransactionCubit>().updateSoftDeletePartyTransactionLocally(partyTransaactioId: transaction.partyTransactionId);
                          }
                          Navigator.pop(context);
                        }
                        if (state is SoftDeleteTransactionFailure) {
                          UiUtils.showCustomSnackBar(context: context, errorMessage: state.errorMessage);
                          Navigator.of(context).pop();
                        }
                      },
                      builder: (context, state) {
                        return Row(
                          children: [
                            Expanded(
                              child: CustomRoundedButton(
                                onPressed: () {
                                  if (state is! SoftDeleteTransactionLoading) {
                                    Navigator.pop(context);
                                  }
                                },
                                width: 1,
                                backgroundColor: Theme.of(context).primaryColor,
                                text: context.tr('cancelKey'),
                                borderRadius: BorderRadius.circular(8),
                                //showBorder: false,
                                height: 40.sp(context),
                                textStyle: TextStyle(fontSize: 18.sp(context)),

                                //isLoading: widget.isEdit ? updateCategoryState is UpdateCategoryLoading : addCategoryState is AddCategoryLoading,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomRoundedButton(
                                onPressed: () {
                                  context.read<SoftDeleteTransactionCubit>().softDeleteTransaction(transaction);
                                },
                                width: 1,
                                backgroundColor: Theme.of(context).primaryColor,
                                text: context.tr('deleteKey'),
                                borderRadius: BorderRadius.circular(8),
                                height: 40.sp(context),
                                textStyle: TextStyle(
                                  fontSize: 18.sp(context),
                                ),
                                isLoading: state is SoftDeleteTransactionLoading,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<void> showRestoreDialogue({required Transaction transaction, required BuildContext context}) async {
  context.showAppDialog(
    child: BlocProvider(
      create: (context) => RestoreTransactionCubit(),
      child: Builder(
        builder: (dialogContext) {
          return Center(
            child: PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;
                if (dialogContext.read<RestoreTransactionCubit>().state is! RestoreTransactionLoading) {
                  Navigator.of(dialogContext).pop();
                  return;
                }
              },
              child: AlertDialog(
                constraints: BoxConstraints(maxHeight: context.height * 0.45, maxWidth: context.width * 0.85),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: CustomTextView(text: context.tr('restoreTitleKey'), fontWeight: FontWeight.bold, fontSize: 18.sp(context)),
                content: CustomTextView(text: context.tr('confirmRestoreDialogMsg'), softWrap: true, maxLines: 3),
                actions: [
                  BlocConsumer<RestoreTransactionCubit, RestoreTransactionState>(
                    listener: (context, state) {
                      if (state is RestoreTransactionSuccess) {
                        context.read<GetSoftDeleteTransactionsCubit>().getSoftDeleteTransactionLocally(transaction);

                        context.read<GetTransactionCubit>().addTransactionLocally(transaction);

                        UiUtils.showCustomSnackBar(
                          context: context,
                          errorMessage: context.tr('transactionRestoredSuccessfullyKey'),
                        );

                        if (state.transaction.partyTransactionId.isNotEmpty) {
                          final partyTransactionmodel = context.read<GetSoftDeletePartyTransactionCubit>().getPartyTransaction(transactionId: state.transaction.id);

                          context.read<GetSoftDeletePartyTransactionCubit>().getSoftDeletePartyTransactionLocally(transaction: partyTransactionmodel);
                        }
                        Navigator.pop(context);
                      }

                      if (state is RestoreTransactionFailure) {
                        UiUtils.showCustomSnackBar(
                          context: context,
                          errorMessage: state.errorMessage,
                        );
                      }
                    },
                    builder: (context, state) {
                      return Row(
                        children: [
                          Expanded(
                            child: CustomRoundedButton(
                              onPressed: () {
                                if (state is! RestoreTransactionLoading) {
                                  Navigator.pop(context);
                                }
                              },
                              width: 1,
                              backgroundColor: Theme.of(context).primaryColor,
                              text: context.tr('cancelKey'),
                              borderRadius: BorderRadius.circular(8),
                              //showBorder: false,
                              height: 40.sp(context),
                              textStyle: TextStyle(fontSize: 18.sp(context)),

                              //isLoading: widget.isEdit ? updateCategoryState is UpdateCategoryLoading : addCategoryState is AddCategoryLoading,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomRoundedButton(
                              onPressed: () {
                                context.read<RestoreTransactionCubit>().restoreTransaction(transaction);
                              },
                              width: 1,
                              backgroundColor: Theme.of(context).primaryColor,
                              text: context.tr('restoreKey'),
                              borderRadius: BorderRadius.circular(8),
                              height: 40.sp(context),
                              textStyle: TextStyle(
                                fontSize: 18.sp(context),
                              ),
                              isLoading: state is RestoreTransactionLoading,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}
