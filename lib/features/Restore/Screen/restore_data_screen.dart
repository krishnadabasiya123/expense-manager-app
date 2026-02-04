import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/Restore/Screen/soft_delete_party_transaction_list.dart';
import 'package:expenseapp/features/Restore/Screen/soft_delete_transaction_list.dart';
import 'package:expenseapp/features/Restore/Cubit/get_soft_delete_party_transaction_cubit.dart';
import 'package:expenseapp/features/Restore/Cubit/restore_party_transaction_cubit.dart';
import 'package:expenseapp/features/Restore/Cubit/get_soft_delete_transactions_cubit.dart';
import 'package:expenseapp/features/Restore/Cubit/restore_transaction_cubit.dart';
import 'package:expenseapp/utils/extensions/localization_extensions.dart';
import 'package:flutter/material.dart';

class RestoreDataScreen extends StatefulWidget {
  const RestoreDataScreen({super.key});

  @override
  State<RestoreDataScreen> createState() => _RestoreTransactionScreenState();
}

class _RestoreTransactionScreenState extends State<RestoreDataScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;

  late List<(String, Widget)> tabs = <(String, Widget)>[
    ('Transaction', const SoftDeleteTransactionList()),
    ('Party Transaction', const SoftDeletePartyTransactionList()),
  ];
  @override
  void initState() {
    super.initState();
    context.read<GetSoftDeleteTransactionsCubit>().getSoftDeleteTransactions();
    context.read<GetSoftDeletePartyTransactionCubit>().getSoftDeletePartyTransaction();
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: QAppBar(
        elevation: 0,
        title: CustomTextView(
          text: context.tr('restoreKey'),
          fontSize: 20.sp(context),
          color: colorScheme.surface,
        ),
        bottom: TabBar(
          indicatorColor: colorScheme.primary,

          dividerColor: Colors.transparent,
          isScrollable: true,
          controller: tabController,
          tabs: tabs
              .map(
                (tab) => Tab(
                  text: context.tr(tab.$1),
                ),
              )
              .toList(),
        ),
      ),

      body: ResponsivePadding(
        topPadding: context.height * 0.01,
        bottomPadding: context.height * 0.01,
        leftPadding: context.width * 0.05,
        rightPadding: context.width * 0.05,
        child: TabBarView(controller: tabController, children: tabs.map((e) => e.$2).toList()),
      ),
    );
  }
}
