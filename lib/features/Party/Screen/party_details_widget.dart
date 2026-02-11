import 'dart:ui';

import 'package:expenseapp/core/app/all_import_file.dart';

import 'package:expenseapp/features/Party/Cubits/PartyTransaction/delete_party_transaction_cubit.dart';
import 'package:expenseapp/features/Transaction/Cubits/add_transaction_cubit.dart';

import 'package:flutter/material.dart';

void showPartyDetailsWidgetBottomSheet(BuildContext context, {required PartyTransaction transaction, bool? isEdit, String? partyId}) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    constraints: const BoxConstraints(),

    builder: (_) {
      return PartyTransactionDetailsWidget(transaction: transaction, partyId: partyId);
    },
  );
}

class PartyTransactionDetailsWidget extends StatefulWidget {
  const PartyTransactionDetailsWidget({required this.transaction, super.key, this.partyId});
  final PartyTransaction transaction;
  final String? partyId;

  @override
  State<PartyTransactionDetailsWidget> createState() => _PartyTransactionDetailsWidgetState();
}

class _PartyTransactionDetailsWidgetState extends State<PartyTransactionDetailsWidget> {
  TransactionType type = TransactionType.CREDIT;
  String description = '';
  String account = '';
  String category = '';
  bool isCredit = false;
  @override
  void initState() {
    super.initState();
    type = widget.transaction.type;
    isCredit = type == TransactionType.CREDIT;
    description = widget.transaction.description;
    account = context.read<GetAccountCubit>().getAccountName(id: widget.transaction.accountId);
    category = context.read<GetCategoryCubit>().getCategoryName(widget.transaction.category);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsDirectional.only(start: 8, end: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: context.height * 0.01),

              Padding(
                padding: const EdgeInsetsDirectional.all(8),
                child: Row(
                  children: [
                    Container(
                      height: 35.sp(context),
                      width: 35.sp(context),
                      decoration: BoxDecoration(color: type.color!.withValues(alpha: 0.2), shape: BoxShape.circle),
                      child: Icon(
                        type.icon,
                        color: type.color,
                        size: 20.sp(context),
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextView(
                            text: isCredit ? context.tr('paymentReceivedKey') : context.tr('outgoingTransferKey'),
                            fontSize: 17.sp(context),
                            fontWeight: FontWeight.w600,
                          ),
                          CustomTextView(text: UiUtils.convertCustomDate(widget.transaction.date), fontSize: 12.sp(context), color: Colors.grey.shade600),
                        ],
                      ),
                    ),

                    CustomTextView(
                      text: '${context.symbol} ${widget.transaction.amount.formatAmt()}',
                      fontSize: 18.sp(context),
                      fontWeight: FontWeight.w600,
                      color: isCredit ? context.colorScheme.incomeColor : context.colorScheme.expenseColor,
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              Padding(
                padding: const EdgeInsetsDirectional.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //SizedBox(height: context.height * 0.01),
                    if (description.isNotEmpty || account.isNotEmpty || category.isNotEmpty || widget.transaction.image.isNotEmpty) ...[
                      CustomTextView(text: context.tr('partyDetailsKey'), fontSize: 17.sp(context), color: Colors.black, fontWeight: FontWeight.bold),
                    ],
                    SizedBox(height: context.height * 0.01),

                    if (description.isNotEmpty) ...[
                      _buildTransactionDetails(icon: Icons.description, title: context.tr('descriptionLbl'), value: description),
                      SizedBox(height: context.height * 0.01),
                    ],

                    if (account.isNotEmpty) ...[
                      _buildTransactionDetails(icon: Icons.account_balance_wallet, title: context.tr('accountLbl'), value: account),
                      SizedBox(height: context.height * 0.01),
                    ],

                    if (category.isNotEmpty) ...[
                      _buildTransactionDetails(icon: Icons.category, title: context.tr('categoryLbl'), value: category),
                      SizedBox(height: context.height * 0.02),
                    ],
                    if (widget.transaction.image.isNotEmpty)
                      SizedBox(
                        height: context.isTablet ? context.height * 0.30 : context.height * 0.3,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.transaction.image.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsetsDirectional.only(start: context.width * 0.02),
                              color: Colors.white,
                              width: context.isTablet ? context.width * 0.60 : context.width * 0.7,
                              child: Image.memory(
                                widget.transaction.image[index].picture,

                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),

              const Divider(height: 1),

              SizedBox(height: context.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(
                        Routes.addPartyTransaction,
                        arguments: {
                          'party': widget.transaction,
                          'isEdit': true,
                        },
                      );
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.edit),
                        SizedBox(width: context.width * 0.02),
                        CustomTextView(text: context.tr('editKey'), fontSize: 15.sp(context)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      showDeleteAlertDialog(context, transaction: widget.transaction, partyId: widget.partyId!);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: context.colorScheme.expenseColor),
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
        ),
      ),
    );
  }

  Widget _buildTransactionDetails({required IconData icon, required String title, required String value}) {
    return Row(
      children: [
        Icon(icon, color: const Color.fromARGB(255, 0, 0, 0), size: 20.sp(context)),

        SizedBox(width: context.height * 0.02),

        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              CustomTextView(text: title, fontSize: 15.sp(context), fontWeight: FontWeight.bold, color: Colors.black),

              CustomTextView(text: value, fontSize: 14.sp(context), color: Colors.black, maxLines: 3, softWrap: true),
            ],
          ),
        ),
      ],
    );
  }

  void showDeleteAlertDialog(BuildContext context, {required PartyTransaction transaction, required String partyId}) {
    context.showAppDialog(
      child: BlocProvider(
        create: (context) => DeletePartyTransactionCubit(),
        child: Builder(
          builder: (dialogContext) {
            return Center(
              child: PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop) return;
                  if (dialogContext.read<DeletePartyTransactionCubit>().state is! DeletePartyTransactionLoading) {
                    Navigator.of(dialogContext).pop();
                    return;
                  }
                },
                child: AlertDialog(
                  constraints: BoxConstraints(maxHeight: context.height * 0.45, maxWidth: context.width * 0.85),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: CustomTextView(text: context.tr('deleteAccountTitleKey'), fontWeight: FontWeight.bold, fontSize: 20.sp(context)),
                  content: CustomTextView(text: context.tr('deletePartyTransactionDilogueMsg'), softWrap: true, maxLines: 3),
                  actions: [
                    BlocConsumer<DeletePartyTransactionCubit, DeletePartyTransactionState>(
                      listener: (context, state) {
                        if (state is DeletePartyTransactionSuccess) {
                          Navigator.of(context).pop();

                          if (state.transaction.mainTransactionId.isNotEmpty) {
                            context.read<GetPartyCubit>().deletePartyTransactionLocally(transaction: transaction, partyId: partyId);
                            context.read<GetTransactionCubit>().deleteTransacionLocally(
                              Transaction(id: state.transaction.mainTransactionId, partyId: state.transaction.partyId, partyTransactionId: state.transaction.id),
                            );

                            context.read<GetPartyCubit>().saveSoftDeletedPartytransactionById(transaction: state.transaction);

                            context.read<AddTransactionCubit>().addSoftDeleteTransaction(
                              Transaction(
                                id: state.transaction.mainTransactionId,
                                amount: state.transaction.amount,
                                title: state.transaction.partyName,
                                description: state.transaction.description,
                                categoryId: state.transaction.category,
                                date: state.transaction.date,
                                type: state.transaction.type == TransactionType.CREDIT ? TransactionType.INCOME : TransactionType.EXPENSE,
                                accountId: state.transaction.accountId,
                                image: state.transaction.image,
                                partyId: state.transaction.partyId,
                                partyTransactionId: state.transaction.id,
                                addFromType: state.transaction.type,
                              ),
                            );
                          }
                        }
                        if (state is DeletePartyTransactionFailure) {
                          Navigator.of(context).pop();
                          UiUtils.showCustomSnackBar(context: context, errorMessage: state.errorMessage);
                        }
                      },
                      builder: (context, state) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: CustomRoundedButton(
                                height: 45.sp(context),
                                backgroundColor: Theme.of(context).primaryColor,
                                textStyle: TextStyle(fontSize: 15.sp(context)),
                                onPressed: () {
                                  if (state is! DeletePartyTransactionLoading) {
                                    Navigator.of(context).pop();
                                  }
                                },
                                text: context.tr('deleteAccountCancelKey'),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: CustomRoundedButton(
                                height: 45.sp(context),
                                backgroundColor: Theme.of(context).primaryColor,
                                textStyle: TextStyle(fontSize: 15.sp(context)),
                                onPressed: () {
                                  // Navigator.of(context).pop();
                                  context.read<DeletePartyTransactionCubit>().deletePartyTransaction(transaction: transaction, partyId: partyId);
                                },
                                text: context.tr('deleteAccountConfirmKey'),
                                isLoading: state is DeletePartyTransactionLoading,
                                borderRadius: BorderRadius.circular(8),
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
