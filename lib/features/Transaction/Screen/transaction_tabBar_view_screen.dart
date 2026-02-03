import 'package:expenseapp/commons/widgets/custom_app_bar.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/Transaction/Cubits/add_transaction_cubit.dart';
import 'package:expenseapp/features/Transaction/Cubits/update_trasansaction_cubit.dart';
import 'package:expenseapp/features/Transaction/Screen/add_transaction_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionTabBarViewScreen extends StatefulWidget {
  const TransactionTabBarViewScreen({required this.transactionType, super.key, this.isEdit = false, this.transaction});
  final TransactionType transactionType;
  final bool isEdit;
  final Transaction? transaction;

  @override
  State<TransactionTabBarViewScreen> createState() => _TransactionTabBarViewScreenState();

  static Route<dynamic>? route(RouteSettings routeSettings) {
    final args = routeSettings.arguments as Map<String, dynamic>?;

    final transactionType = args?['transactionType'] as TransactionType? ?? TransactionType.EXPENSE;

    final isEdit = args?['isEdit'] as bool? ?? false;

    final transaction = args?['transaction'] as Transaction?;

    return CupertinoPageRoute(
      builder: (_) => TransactionTabBarViewScreen(transactionType: transactionType, isEdit: isEdit, transaction: transaction),
    );
  }
}

class _TransactionTabBarViewScreenState extends State<TransactionTabBarViewScreen> {
  @override
  void initState() {
    super.initState();
    selectedTab.value = widget.transactionType;
  }

  @override
  void dispose() {
    selectedTab.dispose();
    super.dispose();
  }

  ValueNotifier<TransactionType> selectedTab = ValueNotifier(TransactionType.EXPENSE);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (context.read<AddTransactionCubit>().state is! AddTransactionLoading && context.read<UpdateTrasansactionCubit>().state is! UpdateTrasansactionLoading) {
          Navigator.of(context).pop();
          return;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: QAppBar(
          title: CustomTextView(text: widget.isEdit ? context.tr('editTransactionKey') : context.tr('addTransactionKey'), color: colorScheme.surface, fontSize: 20.sp(context)),
        ),
        body: ValueListenableBuilder(
          valueListenable: selectedTab,
          builder: (context, value, child) {
            return Column(
              children: [
                Container(
                  margin: EdgeInsetsDirectional.only(bottom: 10.sp(context)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  padding: EdgeInsetsDirectional.only(top: context.width * 0.04, start: context.width * 0.05, end: context.width * 0.05),
                  child: Row(
                    children: [
                      segmentItem(context, tab: TransactionType.EXPENSE, text: context.tr('expenseKey')),

                      const SizedBox(width: 7),

                      segmentItem(context, tab: TransactionType.INCOME, text: context.tr('incomeKey')),

                      const SizedBox(width: 7),

                      segmentItem(context, tab: TransactionType.TRANSFER, text: context.tr('transferKey')),
                    ],
                  ),
                ),

                SizedBox(height: context.height * 0.01),
                Expanded(
                  child: AddTransactionScreen(type: selectedTab.value, transaction: widget.transaction, isEdit: widget.isEdit),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget segmentItem(BuildContext context, {required TransactionType tab, required String text}) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = selectedTab.value == tab;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          selectedTab.value = tab;
        },
        child: Container(
          padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.02, vertical: context.height * 0.01),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary : colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: CustomTextView(text: text, fontSize: 15.sp(context), color: isSelected ? colorScheme.surface : Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
