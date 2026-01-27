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
              final totalIncome = state is GetTransactionSuccess ? context.read<GetTransactionCubit>().getTotalIncomeByAccountId(accountId: widget.account.id) : 0;
              final totalExpense = state is GetTransactionSuccess ? context.read<GetTransactionCubit>().getTotalExpenseByAccountId(accountId: widget.account.id) : 0;
              final totalActualBalance = totalIncome - totalExpense + widget.account.amount;
              return _buildBalanceDetails(
                initialBalance: widget.account.amount,
                totalIncome: totalIncome.toDouble(),
                totalExpense: totalExpense.toDouble(),
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

// import 'package:expenseapp/core/app/all_import_file.dart';
// import 'package:expenseapp/features/Account/Cubits/add_account_cubit.dart';
// import 'package:expenseapp/features/Account/Cubits/update_account_cubit.dart';
// import 'package:flutter/material.dart';

// void showCreateAccountSheet(
//   BuildContext context, {
//   bool? isEdit,
//   Account? account,
// }) {
//   showModalBottomSheet<void>(
//     enableDrag: false,
//     context: context,
//     shape: const RoundedRectangleBorder(
//       borderRadius: UiUtils.bottomSheetTopRadius,
//     ),
//     builder: (sheetContext) {
//       return PopScope(
//         canPop: false,
//         onPopInvokedWithResult: (didPop, result) {
//           if (didPop) return;

//           final isAddLoading = sheetContext.read<AddAccountCubit>().state is AddAccountLoading;

//           final isUpdateLoading = sheetContext.read<UpdateAccountCubit>().state is UpdateAccountLoading;

//           if (!isAddLoading && !isUpdateLoading) {
//             Navigator.of(sheetContext).pop();
//           }
//         },
//         child: ConstrainedBox(
//           constraints: const BoxConstraints(minWidth: double.infinity),
//           child: _AccountCreateWidget(
//             isEdit: isEdit ?? false,
//             account: account,
//           ),
//         ),
//       );
//     },
//   );
// }

// class _AccountCreateWidget extends StatefulWidget {
//   const _AccountCreateWidget({required this.isEdit, this.account, super.key});
//   final bool? isEdit;
//   final Account? account;

//   @override
//   State<_AccountCreateWidget> createState() => _AccountCreateWidgetState();
// }

// class _AccountCreateWidgetState extends State<_AccountCreateWidget> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _balanceController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     _nameController.text = widget.isEdit! ? widget.account?.name ?? '' : '';
//     _balanceController.text = widget.isEdit! ? widget.account?.amount.toString() ?? '' : '';
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _balanceController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: UiUtils.bottomSheetTopRadius),
//       padding: EdgeInsetsDirectional.only(top: context.height * .02),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             CustomTextView(text: widget.isEdit! ? context.tr('updateAccount') : context.tr('addAccountKey'), fontWeight: FontWeights.bold, fontSize: 18.sp(context), color: colorScheme.onTertiary),

//             SizedBox(height: context.height * 0.01),

//             Expanded(
//               child: ResponsivePadding(
//                 child: Padding(
//                   padding: const EdgeInsetsDirectional.all(8),
//                   child: Column(
//                     children: [
//                       CustomTextFormField(
//                         controller: _nameController,
//                         hintText: context.tr('accountNameKey'),
//                         prefixIcon: const Icon(Icons.wallet),
//                         validator: (value) => value == null || value.isEmpty ? context.tr('accountNameKyReq') : null,
//                       ),
//                       SizedBox(height: context.height * 0.01),
//                       CustomTextFormField(
//                         controller: _balanceController,
//                         keyboardType: TextInputType.number,
//                         hintText: context.tr('balanceKey'),
//                         prefixIcon: const Icon(Icons.currency_bitcoin),
//                         validator: (value) => value == null || value.isEmpty ? context.tr('balanceReq') : null,
//                       ),
//                       const Spacer(),
//                       BlocConsumer<UpdateAccountCubit, UpdateAccountState>(
//                         listener: (context, updateState) {
//                           if (updateState is UpdateAccountSuccess) {
//                             context.read<GetAccountCubit>().updateAccountLocally(account: updateState.account);
//                             UiUtils.showCustomSnackBar(context: context, errorMessage: context.tr('accountUpdateSucess'));
//                             Navigator.pop(context);
//                           }
//                           if (updateState is UpdateAccountFailure) {
//                             UiUtils.showCustomSnackBar(context: context, errorMessage: updateState.errorMessage);
//                             Navigator.pop(context);
//                           }
//                         },
//                         builder: (context, updateState) {
//                           return BlocConsumer<AddAccountCubit, AddAccountState>(
//                             listener: (context, addAccount) {
//                               if (addAccount is AddAccountSuccess) {
//                                 context.read<GetAccountCubit>().addAccountLocally(account: addAccount.account);
//                                 UiUtils.showCustomSnackBar(
//                                   context: context,
//                                   errorMessage: context.tr('accountAddSucess'),
//                                 );
//                                 Navigator.pop(context);
//                               }
//                               if (addAccount is AddAccountFailure) {
//                                 UiUtils.showCustomSnackBar(context: context, errorMessage: addAccount.errorMessage);
//                                 Navigator.pop(context);
//                               }
//                             },
//                             builder: (context, addAccount) {
//                               return CustomRoundedButton(
//                                 onPressed: () {
//                                   final accountId = 'ACCT'.withDateTimeMillisRandom();
//                                   if (_nameController.text.isEmpty) {
//                                     UiUtils.showCustomSnackBar(
//                                       context: context,
//                                       errorMessage: context.tr('accountNameReqKey'),
//                                     );
//                                     return;
//                                   }
//                                   if (_balanceController.text.isEmpty) {
//                                     UiUtils.showCustomSnackBar(context: context, errorMessage: context.tr('balanceReqKey'));
//                                     return;
//                                   }

//                                   if (widget.isEdit!) {
//                                     context.read<UpdateAccountCubit>().updateAccount(
//                                       account: Account(id: widget.account?.id ?? '', name: _nameController.text, amount: double.parse(_balanceController.text)),
//                                     );
//                                   } else {
//                                     context.read<AddAccountCubit>().addAccount(
//                                       account: Account(id: accountId, name: _nameController.text, amount: double.parse(_balanceController.text)),
//                                     );
//                                   }
//                                 },
//                                 isLoading: widget.isEdit! ? updateState is UpdateAccountLoading : addAccount is AddAccountLoading,
//                                 // width: 1,
//                                 backgroundColor: Theme.of(context).primaryColor,
//                                 text: widget.isEdit! ? context.tr('update') : context.tr('addKey'),
//                                 borderRadius: BorderRadius.circular(8),

//                                 height: context.isTablet ? context.height * 0.035 : context.height * 0.05,
//                                 textStyle: TextStyle(fontSize: 20.sp(context)),
//                               );
//                             },
//                           );
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
