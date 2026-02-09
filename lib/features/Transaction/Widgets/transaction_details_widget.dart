import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Recurring.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/RecurringTransaction.dart';
import 'package:expenseapp/features/RecurringTransaction/Widget/delete_recurring_dialogue.dart';
import 'package:expenseapp/features/Transaction/Cubits/add_transaction_cubit.dart';
import 'package:expenseapp/features/Transaction/Cubits/delete_transactions_cubit.dart';
import 'package:expenseapp/main.dart' hide TransactionType;
import 'package:flutter/material.dart';

void showTransactionDetailsBottomSheet(BuildContext context, {required Transaction transaction, bool? isEdit}) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20), // Apply border radius to all corners
    ),

    constraints: BoxConstraints(
      minHeight: context.screenHeight * (context.isMobile ? 1.0 : 0.95),
    ),
    builder: (_) => TapRegion(
      onTapOutside: (_) {
        Navigator.of(context).pop();
      },

      child: TransactionDetails(transaction: transaction),
    ),
  );
}

class TransactionDetails extends StatefulWidget {
  const TransactionDetails({required this.transaction, super.key});
  final Transaction transaction;

  @override
  State<TransactionDetails> createState() => TransactionDetailsState();
}

class TransactionDetailsState extends State<TransactionDetails> {
  String accountName = '';
  String categoryName = '';
  String accountFromName = '';
  String accountToName = '';
  TransactionType type = TransactionType.NONE;
  bool isIncome = false;
  bool isTransfer = false;
  bool isExpense = false;
  late Transaction transaction;

  @override
  void initState() {
    super.initState();
    //TODO: check
    transaction = widget.transaction;
    accountName = context.read<GetAccountCubit>().getAccountName(id: widget.transaction.accountId);
    categoryName = context.read<GetCategoryCubit>().getCategoryName(widget.transaction.categoryId);

    accountFromName = context.read<GetAccountCubit>().getAccountName(id: widget.transaction.accountFromId);
    accountToName = context.read<GetAccountCubit>().getAccountName(id: widget.transaction.accountToId);
    type = widget.transaction.type;
    isIncome = type == TransactionType.INCOME;
    isTransfer = type == TransactionType.TRANSFER;
    isExpense = type == TransactionType.EXPENSE;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(8),
      child: DraggableScrollableSheet(
        minChildSize: 0.3,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
            decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Column(
              children: [
                SizedBox(height: context.height * 0.01),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.all(8),
                        child: Row(
                          children: [
                            Container(
                              height: 40.sp(context),
                              width: 40.sp(context),
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: Icon(
                                isExpense
                                    ? Icons.arrow_upward
                                    : isIncome
                                    ? Icons.arrow_downward
                                    : Icons.transform_outlined,

                                color: isExpense
                                    ? context.colorScheme.expenseColor
                                    : isIncome
                                    ? Colors.green
                                    : Colors.blue,
                                size: 20.sp(context),
                              ),
                            ),
                            SizedBox(width: context.width * 0.02),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (transaction.title.isNotEmpty) ...[
                                    if (!isTransfer) ...[
                                      CustomTextView(
                                        text: transaction.title,
                                        fontSize: 18.sp(context),
                                        fontWeight: FontWeight.w600,
                                        softWrap: true,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ],
                                  if (isTransfer) ...[
                                    CustomTextView(
                                      text: '${context.tr('transferFromLbl')} $accountFromName ${context.tr('transferToLbl')} $accountToName',
                                      fontSize: 16.sp(context),
                                      fontWeight: FontWeight.w600,
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                  ],

                                  CustomTextView(text: UiUtils.convertCustomDate(transaction.date), fontSize: 13.sp(context), color: Colors.grey.shade600),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CustomTextView(
                                  text: transaction.amount.formatAmt(),
                                  fontSize: 15.sp(context),
                                  fontWeight: FontWeight.w600,
                                  color: isIncome
                                      ? Colors.green
                                      : isTransfer
                                      ? Colors.blue
                                      : context.colorScheme.expenseColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const Divider(height: 1),
                      SizedBox(height: context.height * 0.02),

                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 8, end: 8, bottom: 10),
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            CustomTextView(text: context.tr('transactionDetailsKey'), fontSize: 16.sp(context), color: Colors.black, fontWeight: FontWeight.bold),

                            if (!isTransfer) ...[
                              if (accountName.isNotEmpty) ...[SizedBox(height: context.height * 0.02), _buildTransactionDetails(icon: Icons.wallet, title: 'Account', value: accountName)],
                            ],

                            if (!isTransfer) ...[
                              if (categoryName.isNotEmpty) ...[
                                SizedBox(height: context.height * 0.02),
                                _buildTransactionDetails(icon: Icons.category, title: 'Category', value: categoryName),
                              ],
                              SizedBox(height: context.height * 0.02),
                            ],
                            if (isTransfer) ...[
                              SizedBox(height: context.height * 0.02),
                            ],
                            if (transaction.description.isNotEmpty) ...[
                              _buildTransactionDetails(icon: Icons.description, title: context.tr('descriptionLbl'), value: transaction.description),
                              SizedBox(height: context.height * 0.02),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.height * 0.01),
                const Divider(height: 1),
                SizedBox(height: context.height * 0.02),

                Row(
                  mainAxisAlignment: .spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);

                        if (widget.transaction.addFromType == TransactionType.RECURRING) {
                          Navigator.of(context).pushNamed(Routes.editMainRecurringTransaction, arguments: {'recurringId': widget.transaction.recurringId});
                        } else if (widget.transaction.addFromType == TransactionType.DEBIT || widget.transaction.addFromType == TransactionType.CREDIT) {
                          Navigator.pushNamed(
                            context,
                            Routes.addPartyTransaction,
                            arguments: {
                              'party': PartyTransaction(
                                id: widget.transaction.partyTransactionId,
                                date: widget.transaction.date,
                                type: widget.transaction.addFromType,
                                amount: widget.transaction.amount,
                                description: widget.transaction.description,
                                category: widget.transaction.categoryId,
                                isMainTransaction: true,
                                accountId: widget.transaction.accountId,
                                image: widget.transaction.image,
                                mainTransactionId: widget.transaction.id,
                                partyId: widget.transaction.partyId,
                                updatedAt: DateTime.now().toString(),
                              ),
                              'isEdit': true,
                            },
                          );
                        } else if (widget.transaction.type == TransactionType.INCOME || widget.transaction.type == TransactionType.EXPENSE || widget.transaction.type == TransactionType.TRANSFER) {
                          Navigator.pushNamed(context, Routes.transactionTabBarView, arguments: {'transactionType': widget.transaction.type, 'isEdit': true, 'transaction': widget.transaction});
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18.sp(context)),
                          SizedBox(width: context.width * 0.02),
                          CustomTextView(text: context.tr('editKey'), fontSize: 15.sp(context)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        if (transaction.recurringId.isNotEmpty) {
                          showDeleteRecurringDialogue(context, recurringId: transaction.recurringId);
                        } else {
                          showDeleteAlertDialog(transaction: transaction, context: context);
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: context.colorScheme.expenseColor, size: 18.sp(context)),
                          SizedBox(width: context.width * 0.02),
                          CustomTextView(text: context.tr('deleteKey'), fontSize: 15.sp(context), color: context.colorScheme.expenseColor),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.height * 0.02),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionDetails({required IconData icon, required String title, required String value}) {
    return Row(
      children: [
        Container(
          height: 30.sp(context),
          width: 30.sp(context),
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: Icon(icon, color: const Color.fromARGB(255, 0, 0, 0), size: 20.sp(context)),
        ),

        SizedBox(width: context.height * 0.02),

        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              CustomTextView(text: title, fontSize: 15.sp(context), fontWeight: FontWeight.bold, color: Colors.black),
              CustomTextView(text: value, fontSize: 13.sp(context), color: Colors.black, maxLines: 3, softWrap: true),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> showDeleteAlertDialog({required Transaction transaction, required BuildContext context}) async {
    context.showAppDialog(
      child: BlocProvider(
        create: (context) => DeleteTransactionsCubit(),
        child: Builder(
          builder: (dilogueContext) {
            return Center(
              child: PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop) return;
                  if (dilogueContext.read<DeleteTransactionsCubit>().state is! DeleteTransactionsLoading) {
                    Navigator.of(dilogueContext).pop();
                  }
                },
                child: AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: CustomTextView(text: context.tr('deleteAccountTitleKey'), fontWeight: FontWeight.bold, fontSize: 18.sp(context)),
                  content: CustomTextView(text: context.tr('deleteTransactionDialogMsg'), softWrap: true, maxLines: 3),
                  actions: [
                    BlocConsumer<DeleteTransactionsCubit, DeleteTransactionsState>(
                      listener: (context, state) {
                        if (state is DeleteTransactionsSuccess) {
                          context.read<GetTransactionCubit>().deleteTransacionLocally(state.transaction);

                          context.read<AddTransactionCubit>().addSoftDeleteTransaction(state.transaction);

                          if (state.transaction.partyTransactionId.isNotEmpty) {
                            context.read<GetPartyCubit>().deletePartyTransactionLocally(
                              transaction: PartyTransaction(id: state.transaction.partyTransactionId, partyId: state.transaction.partyId, mainTransactionId: state.transaction.id),
                              partyId: state.transaction.partyId,
                            );

                            context.read<GetPartyCubit>().saveSoftDeletedPartytransactionById(
                              transaction: PartyTransaction(
                                id: state.transaction.partyTransactionId,
                                partyId: state.transaction.partyId,
                                partyName: state.transaction.title,
                                mainTransactionId: state.transaction.id,
                                type: state.transaction.type == TransactionType.EXPENSE ? TransactionType.DEBIT : TransactionType.CREDIT,
                                accountId: state.transaction.accountId,
                                amount: state.transaction.amount,
                                category: state.transaction.categoryId,
                                date: state.transaction.date,
                                description: state.transaction.description,
                                image: state.transaction.image,

                                isMainTransaction: true,
                                updatedAt: DateTime.now().toString(),
                              ),
                            );
                          }

                          Navigator.of(context).pop();
                        }
                        if (state is DeleteTransactionsFailure) {
                          UiUtils.showCustomSnackBar(context: context, errorMessage: state.errorMessage);
                          Navigator.of(context).pop();
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
                                text: context.tr('deleteAccountCancelKey'),
                                backgroundColor: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(8),
                                textStyle: TextStyle(fontSize: 15.sp(context)),
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
                                text: context.tr('deleteAccountConfirmKey'),
                                backgroundColor: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(8),
                                textStyle: TextStyle(fontSize: 15.sp(context)),
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
