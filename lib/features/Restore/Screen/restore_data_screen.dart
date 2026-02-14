import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/Restore/Screen/soft_delete_party_transaction_list.dart';
import 'package:expenseapp/features/Restore/Screen/soft_delete_transaction_list.dart';
import 'package:expenseapp/features/Restore/Cubit/get_soft_delete_party_transaction_cubit.dart';
import 'package:expenseapp/features/Restore/Cubit/restore_party_transaction_cubit.dart';
import 'package:expenseapp/features/Restore/Cubit/get_soft_delete_transactions_cubit.dart';
import 'package:expenseapp/features/Restore/Cubit/restore_transaction_cubit.dart';
import 'package:expenseapp/utils/extensions/localization_extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      // appBar: QAppBar(
      //   // onTapBackButton: _onTapBackButton,
      // title: CustomTextView(
      //   text: context.tr('restoreKey'),
      //   fontSize: 20.sp(context),
      //   color: colorScheme.surface,
      // ),
      //   // bottom: TabBar(
      //   //   tabAlignment: TabAlignment.fill,

      //   //   //indicatorColor: colorScheme.primary,
      //   //   dividerColor: Colors.transparent,
      //   //   //isScrollable: true,
      //   //   controller: tabController,
      //   //   tabs: tabs
      //   //       .map(
      //   //         (tab) => Tab(
      //   //           text: context.tr(tab.$1),
      //   //         ),
      //   //       )
      //   //       .toList(),
      //   // ),
      // bottom: TabBar(
      //   controller: tabController,
      //   tabAlignment: TabAlignment.fill,
      //   dividerColor: Colors.transparent,
      //   indicator: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(25),
      //     boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      //   ),

      //   labelStyle: TextStyle(fontSize: 15.sp(context), fontWeight: FontWeight.w600),

      //   labelColor: Colors.black,
      //   unselectedLabelColor: Colors.grey[600],
      //   indicatorColor: Colors.transparent,
      //   tabs: tabs
      //       .map(
      //         (tab) => Tab(
      //           text: context.tr(tab.$1),
      //         ),
      //       )
      //       .toList(),
      // ),
      // ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: CustomTextView(
          text: context.tr('restoreKey'),
          fontSize: 20.sp(context),
          color: colorScheme.surface,
        ),
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunito(
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp(context),
          ),
        ),
        iconTheme: IconThemeData(color: colorScheme.surface),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            padding: EdgeInsets.all(4.sp(context)),
            margin: EdgeInsetsDirectional.symmetric(
              horizontal: context.width * UiUtils.hzMarginPct,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
            ),
            child: TabBar(
              controller: tabController,
              tabAlignment: TabAlignment.fill,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              labelStyle: TextStyle(fontSize: 15.sp(context)),
              indicator: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),

              unselectedLabelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelStyle: TextStyle(fontSize: 15.sp(context)),

              tabs: tabs
                  .map(
                    (tab) => Tab(
                      height: 40.sp(context),
                      text: context.tr(tab.$1),
                    ),
                  )
                  .toList(),
            ),
          ),
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
