import 'dart:ui';

import 'package:expenseapp/commons/widgets/common_text_view.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/Account/Cubits/delete_account_cubit.dart';
import 'package:expenseapp/features/Account/Screen/show_account_create_screen.dart';
import 'package:expenseapp/features/Account/Widgets/handle_account_delete_sucess.dart';
import 'package:expenseapp/features/Restore/Cubit/get_soft_delete_party_transaction_cubit.dart';
import 'package:expenseapp/features/Restore/Cubit/get_soft_delete_transactions_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key, this.isEdit = false});

  final bool isEdit;

  @override
  State<AccountScreen> createState() => _AccountScreenState();

  static Route<dynamic>? route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => const AccountScreen(),
    );
  }
}

class _AccountScreenState extends State<AccountScreen> {
  String selectedAccountId = '';
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: QAppBar(
        title: CustomTextView(text: context.tr('accountKey'), fontSize: 20.sp(context), color: colorScheme.surface),
      ),
      body: ResponsivePadding(
        topPadding: context.height * 0.01,
        bottomPadding: context.height * 0.01,
        leftPadding: context.width * 0.05,
        rightPadding: context.width * 0.05,
        child: Column(
          mainAxisAlignment: .spaceEvenly,
          children: [
            BlocConsumer<GetAccountCubit, GetAccountState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is GetAccountSuccess) {
                  final accountList = state.account;

                  if (accountList.isEmpty) {
                    return CustomErrorWidget(
                      errorMessage: context.tr('noDataFound'),
                      errorType: CustomErrorType.noDataFound,
                      onRetry: () {
                        context.read<GetAccountCubit>().getAccount();
                      },
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: accountList.length,
                      itemBuilder: (context, index) {
                        final account = accountList[index];

                        return (account.id == '-2')
                            ? Container()
                            : GestureDetector(
                                onTap: () async {
                                  Navigator.of(context).pushNamed(
                                    Routes.accountTransaction,
                                    arguments: {'account': account},
                                  );
                                },
                                child: BlocBuilder<GetTransactionCubit, GetTransactionState>(
                                  builder: (context, state) {
                                    final totalIncome = context.read<GetTransactionCubit>().getTotalIncomeByAccountId(accountId: account.id);
                                    final totalExpense = context.read<GetTransactionCubit>().getTotalExpenseByAccountId(accountId: account.id);
                                    final totalTransfer = context.read<GetTransactionCubit>().getTotalTransferAmount(accountId: account.id);
                                    final totalActualBalance = account.amount + totalIncome - totalExpense + totalTransfer;
                                    log('transaction fetchTransaction  total balance ${totalIncome - totalExpense}');
                                    log('transaction fetchTransaction  total totalTransfer $totalTransfer');
                                    log('transaction fetchTransaction  total ActualBalance $totalActualBalance');
                                    return Container(
                                      margin: const EdgeInsetsDirectional.only(bottom: 15),
                                      height: context.height * 0.25,
                                      width: context.width * 0.8,
                                      decoration: BoxDecoration(color: colorScheme.secondary, borderRadius: BorderRadius.circular(20)),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.05, vertical: context.height * 0.01),

                                              width: double.infinity,

                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(color: const Color.fromARGB(255, 229, 222, 222).withValues(alpha: 0.2), blurRadius: 15, spreadRadius: -6, offset: const Offset(0, 10)),
                                                ],
                                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                                color: Colors.white,
                                              ),

                                              child: Column(
                                                mainAxisAlignment: .spaceEvenly,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: .start,
                                                    children: [
                                                      Icon(Icons.wallet, color: Theme.of(context).colorScheme.onSecondary, size: 25.sp(context)),
                                                      const SizedBox(width: 10),

                                                      // Expanded(
                                                      //   child: UiUtils.marqueeText(
                                                      //     text: account.name,
                                                      //     textStyle: TextStyle(fontSize: 17.sp(context)),
                                                      //     width: context.width * 0.5,
                                                      //   ),
                                                      // ),
                                                      Expanded(
                                                        child: CustomTextView(
                                                          text: account.name,
                                                          fontSize: 17.sp(context),
                                                          color: Theme.of(context).colorScheme.onSecondary,
                                                          maxLines: 5,
                                                          softWrap: true,
                                                        ),
                                                      ),

                                                      GestureDetector(
                                                        onTap: () {
                                                          showCreateAccountSheet(context, isEdit: true, account: account);
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsetsDirectional.only(start: 8),
                                                          child: Container(
                                                            height: context.height * .03,
                                                            width: context.height * .03,
                                                            decoration: BoxDecoration(
                                                              border: Border.all(color: Colors.grey),
                                                              borderRadius: BorderRadius.circular(2),
                                                            ),
                                                            child: Center(child: Icon(Icons.edit, size: context.height * .017)),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: context.width * 0.02),

                                                      GestureDetector(
                                                        onTap: () {
                                                          showDeleteAlertDialog(account: account, accountList: accountList, actualBalance: totalActualBalance);
                                                        },
                                                        child: Container(
                                                          height: context.height * .03,
                                                          width: context.height * .03,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(color: Colors.grey),
                                                            borderRadius: BorderRadius.circular(2),
                                                          ),

                                                          child: Center(
                                                            child: Icon(Icons.delete, color: context.colorScheme.expenseColor, size: context.height * .017),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  const CustomHorizontalDivider(
                                                    padding: EdgeInsetsDirectional.only(top: 5, bottom: 5),
                                                    endOpacity: 0.5,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: .spaceEvenly,
                                                    children: [
                                                      _buildInitialBalanceCardTextAndAmonut(
                                                        text: context.tr('initialBalanceKey'),
                                                        amount: account.amount.formatAmt(),
                                                      ),
                                                      Container(width: 1.5, height: context.height * 0.07, color: colorScheme.surfaceDim),
                                                      _buildInitialBalanceCardTextAndAmonut(
                                                        text: context.tr('actualBalanceKey'),
                                                        amount: totalActualBalance.formatAmt(),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            //  height: context.height * 0.09,
                                            padding: const EdgeInsetsDirectional.only(top: 6, bottom: 6),
                                            child: Row(
                                              mainAxisAlignment: .spaceEvenly,
                                              children: [
                                                _buildCardTextAndAmonut(text: context.tr('totalIncomeKey'), amount: totalIncome.formatAmt(), type: TransactionType.INCOME),
                                                Container(width: 1.5, height: context.height * 0.07, color: colorScheme.surface),
                                                _buildCardTextAndAmonut(text: context.tr('totalExpenseKey'), amount: totalExpense.formatAmt(), type: TransactionType.EXPENSE),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                      },
                    ),
                  );
                }
                if (state is GetAccountFailure) {
                  return CustomErrorWidget(
                    errorMessage: state.errorMessage,
                    errorMessageFontSize: 20.sp(context),
                    onRetry: () {
                      context.read<GetAccountCubit>().getAccount();
                    },
                  );
                }
                return const CustomCircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCreateAccountSheet(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void showDeleteAlertDialog({required Account account, required List<Account> accountList, required double actualBalance}) {
    context.showAppDialog(
      child: BlocProvider(
        create: (context) => DeleteAccountCubit(),
        child: Builder(
          builder: (dialogueContext) {
            return Center(
              child: PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop) return;
                  if (dialogueContext.read<DeleteAccountCubit>().state is! DeleteAccountLoading) {
                    Navigator.of(dialogueContext).pop();
                    return;
                  }
                },
                child: AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: Text(
                    context.tr('deleteAccountTitleKey'),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp(context)),
                  ),
                  content: CustomTextView(text: context.tr('deleteDialogMsg'), softWrap: true, maxLines: 3, fontSize: 15.sp(context)),
                  actions: [
                    BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
                      listener: (context, state) {
                        if (state is DeleteAccountSuccess) {
                          // context.read<GetAccountCubit>().deleteAccountLocally(account: state.account);
                          // context.read<GetTransactionCubit>().deleteTransacionLocally(Transaction(id: state.account.id));
                          // context.read<GetTransactionCubit>().deleteTransactionWhenDeleteAccount(accountId: state.account.id, accountFromId: state.account.id, accountToId: state.account.id);
                          // context.read<GetSoftDeleteTransactionsCubit>().updateSoftDeleteTransactionAfterDeleteAccount(
                          //   accountId: state.account.id,
                          //   accountFromId: state.account.id,
                          //   accountToId: state.account.id,
                          // );
                          // context.read<GetSoftDeletePartyTransactionCubit>().updateSoftDeletePartyTransactionAfterDeleteAccount(accountId: state.account.id);
                          // UiUtils.showCustomSnackBar(context: context, errorMessage: context.tr('accountDeleteSucess'));

                          // context.read<GetPartyCubit>().deletePartyTransactionWhenDeleteAccount(accountId: state.account.id);
                          // Navigator.pop(context);
                          handleAccountDeleteSuccess(context, state.account);
                        }
                        if (state is DeleteAccountFailure) {
                          UiUtils.showCustomSnackBar(context: context, errorMessage: state.errorMessage);
                          Navigator.pop(context);
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: CustomRoundedButton(
                                    onPressed: () {
                                      if (state is! DeleteAccountLoading) {
                                        Navigator.of(context).pop();
                                      }
                                    },

                                    width: 1,
                                    backgroundColor: Theme.of(context).primaryColor,
                                    text: context.tr('deleteAccountCancelKey'),
                                    borderRadius: BorderRadius.circular(8),
                                    height: 45.sp(context),
                                  ),
                                ),

                                const SizedBox(width: 15),

                                Expanded(
                                  child: CustomRoundedButton(
                                    onPressed: () {
                                      final realAccounts = accountList.where((acc) => acc.id != '-2').toList();

                                      if (realAccounts.length > 1) {
                                        // context.read<DeleteAccountCubit>().deleteAccount(account: account);
                                        final totalTransaction = context.read<GetTransactionCubit>().totalTransactionCount(account: account.id);
                                        log('totalTransaction $totalTransaction');
                                        if (totalTransaction > 0) {
                                          Navigator.pop(context);
                                          _openAlertDialogueWithMoreTransaction(account: account);
                                        } else {
                                          context.read<DeleteAccountCubit>().deleteAccount(account: account);
                                        }
                                      } else {
                                        Navigator.pop(context);
                                        showAccountLimitWarning(
                                          context,
                                        );
                                      }
                                    },
                                    isLoading: state is DeleteAccountLoading,
                                    width: 1,
                                    backgroundColor: Theme.of(context).primaryColor,
                                    text: context.tr('deleteAccountConfirmKey'),
                                    borderRadius: BorderRadius.circular(8),
                                    height: 45.sp(context),
                                  ),
                                ),
                              ],
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

  void _openAlertDialogueWithMoreTransaction({required Account account}) {
    context.showAppDialog(
      child: BlocProvider(
        create: (context) => DeleteAccountCubit(),
        child: Builder(
          builder: (dialogueContext) {
            return Center(
              child: PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop) return;
                  if (dialogueContext.read<DeleteAccountCubit>().state is! DeleteAccountLoading) {
                    Navigator.of(dialogueContext).pop();
                    return;
                  }
                },
                child: AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: Center(
                    child: Column(
                      children: [
                        Icon(Icons.delete, color: Theme.of(context).colorScheme.error, size: 40.sp(context)),
                        const SizedBox(height: 10),
                        Text(
                          context.tr('deleteAccountTitleKey'),
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp(context)),
                        ),
                      ],
                    ),
                  ),
                  content: CustomTextView(
                    text: context.tr('deleteDialogMsgwithMoreTransaction'),
                    softWrap: true,
                    maxLines: 6,
                    fontSize: 14.sp(context),
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
                      listener: (context, state) {
                        if (state is DeleteAccountSuccess) {
                          handleAccountDeleteSuccess(context, state.account);
                        }
                        if (state is DeleteAccountFailure) {
                          UiUtils.showCustomSnackBar(context: context, errorMessage: state.errorMessage);
                          Navigator.pop(context);
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: CustomRoundedButton(
                                        onPressed: () {
                                          if (state is! DeleteAccountLoading) {
                                            Navigator.of(context).pop();
                                          }
                                        },

                                        width: 1,
                                        backgroundColor: Theme.of(context).primaryColor,
                                        text: context.tr('deleteAccountCancelKey'),
                                        borderRadius: BorderRadius.circular(8),
                                        height: 40.sp(context),
                                      ),
                                    ),

                                    const SizedBox(width: 15),

                                    Expanded(
                                      child: CustomRoundedButton(
                                        onPressed: () {
                                          context.read<DeleteAccountCubit>().deleteAccount(account: account);
                                        },
                                        isLoading: state is DeleteAccountLoading,
                                        width: 1,
                                        backgroundColor: Theme.of(context).primaryColor,
                                        text: context.tr('deleteAccountConfirmKey'),
                                        borderRadius: BorderRadius.circular(8),
                                        height: 40.sp(context),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: context.height * 0.01),
                                CustomRoundedButton(
                                  onPressed: () {
                                    if (state is! DeleteAccountLoading) {
                                      Navigator.of(context).pop();
                                      showSelectAccountSheet(context, account);
                                    }
                                  },

                                  //  backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.6),
                                  backgroundColor: Theme.of(context).colorScheme.surface,
                                  text: context.tr('moveTransactionKey'),
                                  borderRadius: BorderRadius.circular(15),
                                  height: 40.sp(context),
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                ),
                              ],
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

  void showSelectAccountSheet(BuildContext context, Account accountToDelete) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => DeleteAccountCubit(),
          child: StatefulBuilder(
            builder: (context, StateSetter setState) {
              return Container(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 30,
                      offset: const Offset(0, -8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextView(text: context.tr('selectAccountLbl'), fontSize: 20.sp(context), fontWeight: FontWeight.bold, softWrap: true, maxLines: 3),

                    CustomTextView(text: context.tr('accountToTransferAllTransactionKey'), fontSize: 15.sp(context), color: Colors.grey, softWrap: true, maxLines: 3),
                    BlocBuilder<GetAccountCubit, GetAccountState>(
                      builder: (context, state) {
                        if (state is GetAccountSuccess) {
                          final accountList = state.account;
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: accountList.length,
                            itemBuilder: (context, index) {
                              final account = accountList[index];
                              if (account.id != accountToDelete.id && account.id != '-2') {
                                return Builder(
                                  builder: (context) {
                                    final totalIncome = context.read<GetTransactionCubit>().getTotalIncomeByAccountId(accountId: account.id);
                                    final totalExpense = context.read<GetTransactionCubit>().getTotalExpenseByAccountId(accountId: account.id);
                                    final totalTransfer = context.read<GetTransactionCubit>().getTotalTransferAmount(accountId: account.id);
                                    final totalActualBalance = account.amount + totalIncome - totalExpense + totalTransfer;
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: RadioListTile<String>(
                                            contentPadding: EdgeInsets.zero,
                                            dense: true,
                                            title: Text(account.name),
                                            value: account.id,
                                            groupValue: selectedAccountId,
                                            onChanged: (value) {
                                              selectedAccountId = value!;
                                              context.read<GetTransactionCubit>().moveTransactionsLocally(
                                                fromAccountId: accountToDelete.id,
                                                toAccountId: selectedAccountId,
                                              );
                                              context.read<GetAccountCubit>().deleteAccountLocally(account: accountToDelete);
                                              // context.read<DeleteAccountCubit>().deleteAccount(account: accountToDelete);
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                        CustomTextView(
                                          text: ' ${context.symbol}${totalActualBalance.formatAmt()}',
                                          fontSize: 15.sp(context),
                                          color: Colors.black,
                                          softWrap: true,
                                          maxLines: 3,
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          );
                        } else if (state is GetAccountFailure) {
                          return CustomErrorWidget(
                            errorMessage: context.tr('dataNotFound'),
                            onRetry: () {
                              context.read<GetAccountCubit>().getAccount();
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCardTextAndAmonut({required String text, required String amount, required TransactionType type}) {
    final isIncome = type == TransactionType.INCOME;
    return Column(
      mainAxisAlignment: .spaceEvenly,
      children: [
        CustomTextView(text: text, fontSize: 12.sp(context), color: Theme.of(context).colorScheme.surface, fontWeight: FontWeight.w400),

        Row(
          children: [
            Icon(isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded, color: isIncome ? context.colorScheme.incomeColor : context.colorScheme.expenseColor, size: 17.sp(context)),
            const SizedBox(width: 5),
            CustomTextView(text: '${context.symbol} $amount', fontSize: 17.sp(context), color: Theme.of(context).colorScheme.surface, fontWeight: FontWeight.bold),
          ],
        ),
      ],
    );
  }

  Widget _buildInitialBalanceCardTextAndAmonut({required String text, required String amount}) {
    return Column(
      mainAxisAlignment: .spaceEvenly,
      children: [
        CustomTextView(text: text, fontSize: 15.sp(context), color: Colors.black, fontWeight: FontWeight.w400),

        CustomTextView(text: '${context.symbol} $amount', fontSize: 17.sp(context), color: Colors.black, fontWeight: FontWeight.bold),
      ],
    );
  }

  Future<void> showAccountLimitWarning(BuildContext context) async {
    final colorScheme = Theme.of(context).colorScheme;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // Material 3 Icon at the top
          icon: Icon(
            Icons.warning_amber_rounded,
            color: colorScheme.error,
            size: 40.sp(context),
          ),
          title: CustomTextView(
            text: context.tr('accRestrictedKey'),
            textAlign: TextAlign.center,
            fontWeight: FontWeight.bold,

            fontSize: 18.sp(context),
          ),
          content: CustomTextView(
            text: context.tr('accountRestrictedMsg'),
            softWrap: true,
            maxLines: 4,
            textAlign: TextAlign.center,
            fontSize: 16.sp(context),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: CustomTextView(text: context.tr('gotitKey'), fontSize: 16.sp(context)),
            ),

            CustomRoundedButton(
              height: context.height * 0.05,

              onPressed: () {
                Navigator.pop(context);
                showCreateAccountSheet(context);
              },
              textStyle: TextStyle(fontSize: 16.sp(context)),
              backgroundColor: colorScheme.error,
              text: context.tr('addNewAccountKey'),
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        );
      },
    );
  }
}

class AccountItem extends StatelessWidget {
  const AccountItem({
    required this.account,
    required this.totalIncome,
    required this.totalExpense,
    super.key,
  });

  final Account account;
  final double totalIncome;
  final double totalExpense;

  @override
  Widget build(BuildContext context) {
    Widget buildInitialBalanceCardTextAndAmonut({required String text, required String amount}) {
      return Column(
        mainAxisAlignment: .spaceEvenly,
        children: [
          CustomTextView(text: text, fontSize: 15.sp(context), color: Colors.black, fontWeight: FontWeight.w400),

          CustomTextView(text: '${context.symbol} $amount', fontSize: 17.sp(context), color: Colors.black, fontWeight: FontWeight.bold),
        ],
      );
    }

    Widget buildCardTextAndAmonut({required String text, required String amount, required TransactionType type}) {
      return Column(
        mainAxisAlignment: .spaceEvenly,
        children: [
          CustomTextView(text: text, fontSize: 12.sp(context), color: Theme.of(context).colorScheme.surface, fontWeight: FontWeight.w400),

          Row(
            children: [
              Icon(type.icon, color: type.color, size: 17.sp(context)),
              const SizedBox(width: 5),
              CustomTextView(text: '${context.symbol} $amount', fontSize: 17.sp(context), color: Theme.of(context).colorScheme.surface, fontWeight: FontWeight.bold),
            ],
          ),
        ],
      );
    }

    final colorScheme = Theme.of(context).colorScheme;
    final totalActualBalance = totalIncome - totalExpense + account.amount;

    if (account.id == '-2') return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          Routes.accountTransaction,
          arguments: {
            'account': account,
            'totalActualBalance': totalActualBalance,
            'totalIncome': totalIncome,
            'totalExpense': totalExpense,
          },
        );
      },
      child: Container(
        margin: const EdgeInsetsDirectional.only(bottom: 15),
        height: context.height * 0.25,
        width: context.width * 0.8,
        decoration: BoxDecoration(
          color: colorScheme.secondary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.05, vertical: context.height * 0.01),
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 229, 222, 222).withValues(alpha: .2),
                      blurRadius: 15,
                      spreadRadius: -6,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.wallet, color: colorScheme.onSecondary, size: 25.sp(context)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: UiUtils.marqueeText(
                            text: account.name,
                            textStyle: TextStyle(fontSize: 17.sp(context)),
                            width: context.width * 0.5,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showCreateAccountSheet(context, isEdit: true, account: account);
                          },
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(start: 8),
                            child: Container(
                              height: context.height * .03,
                              width: context.height * .03,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Center(child: Icon(Icons.edit, size: context.height * .017)),
                            ),
                          ),
                        ),
                        SizedBox(width: context.width * 0.02),
                        GestureDetector(
                          onTap: () {
                            // showDeleteAlertDialog(account: account, accountList: []);
                          },
                          child: Container(
                            height: context.height * .03,
                            width: context.height * .03,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Center(
                              child: Icon(Icons.delete, color: context.colorScheme.expenseColor, size: context.height * .017),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const CustomHorizontalDivider(
                      padding: EdgeInsetsDirectional.only(top: 5, bottom: 5),
                      endOpacity: 0.5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildInitialBalanceCardTextAndAmonut(
                          text: context.tr('initialBalanceKey'),
                          amount: account.amount.formatAmt(),
                        ),
                        Container(width: 1.5, height: context.height * 0.07, color: colorScheme.surfaceDim),
                        buildInitialBalanceCardTextAndAmonut(
                          text: context.tr('actualBalanceKey'),
                          amount: totalActualBalance.formatAmt(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsetsDirectional.only(top: 6, bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildCardTextAndAmonut(text: context.tr('totalIncomeKey'), amount: totalIncome.formatAmt(), type: TransactionType.INCOME),
                  Container(width: 1.5, height: context.height * 0.07, color: colorScheme.surface),
                  buildCardTextAndAmonut(text: context.tr('totalExpenseKey'), amount: totalExpense.formatAmt(), type: TransactionType.EXPENSE),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
