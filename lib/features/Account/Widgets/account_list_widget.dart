import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/Account/Screen/show_account_create_screen.dart';
import 'package:flutter/material.dart';

class AccountListWidget extends StatefulWidget {
  const AccountListWidget({this.selectedAccountId, super.key, this.iconDisplay = true, this.isDisplayTransactionCount = false});
  final bool iconDisplay;
  final bool isDisplayTransactionCount;
  final ValueNotifier<String?>? selectedAccountId;

  @override
  State<AccountListWidget> createState() => _AccountListWidgetState();
}

class _AccountListWidgetState extends State<AccountListWidget> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<GetAccountCubit, GetAccountState>(
      builder: (context, state) {
        if (state is GetAccountSuccess) {
          final accounts = state.account;

          if (accounts.isEmpty) {
            return NoDataFoundScreen(title: context.tr('noAccAddKey'), subTitle: context.tr('accAddDesKey'));
          }

          return SizedBox(
            height: context.isTablet ? context.height * 0.12 : context.height * 0.141,
            child: ValueListenableBuilder(
              valueListenable: widget.selectedAccountId!,
              builder: (context, value, child) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    final account = accounts[index];
                    final isSelected = widget.selectedAccountId!.value == account.id;
                    final totalIncome = context.read<GetTransactionCubit>().getTotalIncomeByAccountId(accountId: account.id);
                    final totalExpense = context.read<GetTransactionCubit>().getTotalExpenseByAccountId(accountId: account.id);
                    final totalTransfer = context.read<GetTransactionCubit>().getTotalTransferAmount(accountId: account.id);
                    final totalActualBalance = totalIncome - totalExpense + account.amount + totalTransfer;

                    return GestureDetector(
                      onTap: () {
                        widget.selectedAccountId!.value = account.id;
                      },
                      child: Container(
                        padding: EdgeInsetsDirectional.symmetric(vertical: context.height * 0.007, horizontal: context.width * 0.02),
                        width: context.isTablet ? context.width * 0.23 : context.width * 0.32,
                        margin: EdgeInsetsDirectional.only(end: context.width * 0.03),
                        // padding: EdgeInsetsDirectional.symmetric(vertical: context.height * 0.01, horizontal: context.width * 0.012),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(15),

                          border: Border.all(color: (isSelected && (account.id != '-2')) ? colorScheme.primary : colorScheme.surface, width: 2),
                        ),
                        child: (account.id == '-2')
                            ? GestureDetector(
                                onTap: () {
                                  showCreateAccountSheet(context);
                                },
                                child: Column(
                                  mainAxisAlignment: .center,
                                  children: [
                                    Icon(Icons.add_card, size: 23.sp(context), color: Colors.black),

                                    CustomTextView(
                                      text: context.tr('addAccountKey'),
                                      fontSize: 16.sp(context),
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                crossAxisAlignment: .start,
                                mainAxisAlignment: .spaceEvenly,
                                children: [
                                  Container(
                                    height: 33.sp(context),
                                    width: 33.sp(context),
                                    decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                                    child: Icon(Icons.wallet, size: 22.sp(context), color: isSelected ? colorScheme.primary : colorScheme.onTertiary),
                                  ),

                                  UiUtils.marqueeText(
                                    text: account.name,
                                    textStyle: TextStyle(fontSize: 15.sp(context), color: isSelected ? colorScheme.primary : colorScheme.onTertiary),
                                    width: context.isTablet ? context.width * 0.23 : context.width * 0.32,
                                    //width: double.infinity,
                                  ),

                                  UiUtils.marqueeText(
                                    text: '${context.symbol} ${totalActualBalance.formatAmt()}',
                                    textStyle: TextStyle(fontSize: 15.sp(context), color: isSelected ? colorScheme.primary : colorScheme.onTertiary, fontWeight: FontWeight.bold),
                                    width: context.isTablet ? context.width * 0.23 : context.width * 0.32,
                                    //width: double.infinity,
                                  ),

                                  // CustomTextView(
                                  //   text: '${context.symbol} ${account.amount}',
                                  //   fontSize: 16.sp(context),
                                  //   color: isSelected ? colorScheme.primary : colorScheme.onTertiary,
                                  //   fontWeight: FontWeight.bold,
                                  // ),
                                ],
                              ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        }
        return const CustomCircularProgressIndicator();
      },
    );
  }
}
