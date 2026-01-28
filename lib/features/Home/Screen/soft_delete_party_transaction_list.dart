import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/Party/Cubits/PartyTransaction/get_soft_delete_party_transaction_cubit.dart';
import 'package:expenseapp/features/Party/Cubits/PartyTransaction/permenantly_delete_party_transaction_cubit.dart';
import 'package:expenseapp/features/Party/Cubits/PartyTransaction/restore_party_transaction_cubit.dart';
import 'package:expenseapp/features/Transaction/Cubits/get_soft_delete_transactions_cubit.dart';
import 'package:flutter/material.dart';

class SoftDeletePartyTransactionList extends StatelessWidget {
  const SoftDeletePartyTransactionList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetSoftDeletePartyTransactionCubit, GetSoftDeletePartyTransactionState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is GetSoftDeletePartyTransactionSuccess) {
          final transactions = state.transactions;

          if (transactions.isEmpty) {
            return CustomErrorWidget(
              errorMessage: context.tr('noDataFound'),
              errorType: CustomErrorType.noDataFound,
              onRetry: () {
                context.read<GetSoftDeletePartyTransactionCubit>().getSoftDeletePartyTransaction();
              },
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.transactions.length,
            itemBuilder: (context, index) {
              final transaction = state.transactions[index];
              return ResporePartyCard(
                party: transaction,
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class ResporePartyCard extends StatefulWidget {
  const ResporePartyCard({
    required this.party,

    super.key,
  });
  final PartyTransaction party;

  @override
  State<ResporePartyCard> createState() => _ResporePartyCardState();
}

class _ResporePartyCardState extends State<ResporePartyCard> {
  bool isCredit = false;
  bool isDebit = false;
  String accountName = '';
  String categoryName = '';

  @override
  void initState() {
    super.initState();
    isCredit = widget.party.type == TransactionType.CREDIT;
    isDebit = widget.party.type == TransactionType.DEBIT;
    accountName = context.read<GetAccountCubit>().getAccountName(id: widget.party.accountId ?? '');
    categoryName = context.read<GetCategoryCubit>().getCategoryName(widget.party.category ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final color = isCredit ? Colors.green : Colors.red;

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
            mainAxisAlignment: .center,
            children: [
              Row(
                mainAxisAlignment: .center,
                children: [
                  Container(
                    height: 30.sp(context),
                    width: 30.sp(context),
                    decoration: BoxDecoration(
                      color: isDebit ? Colors.red.shade100 : Colors.green.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isDebit ? Icons.arrow_upward : Icons.arrow_downward,

                      color: color,
                      size: 20.sp(context),
                    ),
                  ),
                  SizedBox(width: context.width * 0.03),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: .center,
                      children: [
                        CustomTextView(
                          text: widget.party.partyName,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 15,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: .center,

                    children: [
                      CustomTextView(
                        text: widget.party.amount.formatAmt(),
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),

                      if (accountName.isNotEmpty) ...[
                        CustomTextView(
                          text: accountName,
                          color: Colors.black,
                        ),
                      ],
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
                      icon: Icon(Icons.delete, color: Colors.green, size: 20.sp(context)),
                      backgroundColor: Colors.green.withOpacity(0.08),
                      text: context.tr('restoreKey'),
                      textStyle: TextStyle(color: Colors.green, fontSize: 14.sp(context)),
                      borderSide: const BorderSide(color: Colors.green),
                      onPressed: () {
                        showPartyTransactionRestoreAlertDialog(context: context, transaction: widget.party);
                      },
                    ),
                  ),

                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomRoundedButton(
                      height: context.isTablet ? context.height * 0.038 : context.height * 0.045,
                      icon: Icon(Icons.delete, color: Colors.red, size: 20.sp(context)),
                      backgroundColor: Colors.red.withOpacity(0.08),
                      text: context.tr('deleteKey'),
                      textStyle: TextStyle(color: Colors.red, fontSize: 14.sp(context)),
                      borderSide: const BorderSide(color: Colors.red),
                      onPressed: () {
                        showPartyTransactionDeleteAlertDialog(context: context, transaction: widget.party);
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

  Future<void> showPartyTransactionDeleteAlertDialog({required PartyTransaction transaction, required BuildContext context}) async {
    context.showAppDialog(
      child: BlocProvider(
        create: (context) => PermenantlyDeletePartyTransactionCubit(),
        child: Builder(
          builder: (diologContext) {
            return Center(
              child: PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop) return;
                  if (diologContext.read<PermenantlyDeletePartyTransactionCubit>().state is! PermenantlyDeletePartyTransactionLoading) {
                    Navigator.of(diologContext).pop();
                    return;
                  }
                },
                child: AlertDialog(
                  constraints: BoxConstraints(maxHeight: context.height * 0.45, maxWidth: context.width * 0.85),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: CustomTextView(text: context.tr('deleteAccountTitleKey'), fontWeight: FontWeight.bold, fontSize: 18.sp(context)),
                  content: CustomTextView(text: context.tr('deleteRestoreTransactionDialogMsg'), softWrap: true, maxLines: 3),
                  actions: [
                    BlocConsumer<PermenantlyDeletePartyTransactionCubit, PermenantlyDeletePartyTransactionState>(
                      listener: (context, state) {
                        if (state is PermenantlyDeletePartyTransactionSuccess) {
                          Navigator.of(context).pop();
                          context.read<GetSoftDeletePartyTransactionCubit>().getSoftDeletePartyTransactionLocally(transaction: transaction);
                          context.read<GetSoftDeleteTransactionsCubit>().updateSoftDeleteTransactionLocally(transaction: Transaction(id: transaction.mainTransactionId));
                        }
                      },
                      builder: (context, state) {
                        return Row(
                          children: [
                            Expanded(
                              child: CustomRoundedButton(
                                onPressed: () {
                                  if (state is! PermenantlyDeletePartyTransactionLoading) {
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
                                  context.read<PermenantlyDeletePartyTransactionCubit>().permenantlyDeletePartyTransaction(transaction: transaction);
                                },
                                width: 1,
                                backgroundColor: Theme.of(context).primaryColor,
                                text: context.tr('deleteKey'),
                                borderRadius: BorderRadius.circular(8),
                                height: 40.sp(context),
                                textStyle: TextStyle(
                                  fontSize: 18.sp(context),
                                ),
                                isLoading: state is PermenantlyDeletePartyTransactionLoading,
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

Future<void> showPartyTransactionRestoreAlertDialog({required PartyTransaction transaction, required BuildContext context}) async {
  context.showAppDialog(
    child: BlocProvider(
      create: (context) => RestorePartyTransactionCubit(),
      child: Builder(
        builder: (dialogContext) {
          return Center(
            child: PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;
                if (dialogContext.read<RestorePartyTransactionCubit>().state is! RestorePartyTransactionLoading) {
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
                  BlocConsumer<RestorePartyTransactionCubit, RestorePartyTransactionState>(
                    listener: (context, state) {
                      if (state is RestorePartyTransactionSuccess) {
                        context.read<GetSoftDeletePartyTransactionCubit>().getSoftDeletePartyTransactionLocally(transaction: transaction);

                        UiUtils.showCustomSnackBar(
                          context: context,
                          errorMessage: context.tr('partyTransactionRestoredSuccessfullyKey'),
                        );

                        if (transaction.mainTransactionId.isNotEmpty) {
                          final transactionModel = context.read<GetSoftDeleteTransactionsCubit>().getTransaction(partyTransactionId: transaction.id);
                          // this method is for if in party transaction party data restore then from transaction forcefully restore transaction
                          //(same transaction id available in main transaction list)
                          context.read<GetSoftDeleteTransactionsCubit>().getSoftDeleteTransactionLocally(transactionModel);

                          context.read<GetTransactionCubit>().addTransactionLocally(transactionModel);
                        }
                        Navigator.pop(context);
                      }

                      if (state is RestorePartyTransactionFailure) {
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
                                if (state is! RestorePartyTransactionLoading) {
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
                                context.read<RestorePartyTransactionCubit>().restorePartyTransaction(transaction);
                              },
                              width: 1,
                              backgroundColor: Theme.of(context).primaryColor,
                              text: context.tr('restoreKey'),
                              borderRadius: BorderRadius.circular(8),
                              height: 40.sp(context),
                              textStyle: TextStyle(
                                fontSize: 18.sp(context),
                              ),
                              isLoading: state is RestorePartyTransactionLoading,
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
