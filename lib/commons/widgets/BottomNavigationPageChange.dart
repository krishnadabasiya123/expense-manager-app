import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/Home/Cubits/edit_home_cubit.dart';
import 'package:expenseapp/features/Home/Screen/home_page.dart';
import 'package:expenseapp/features/Profile/Screen/profile_screen.dart';
import 'package:expenseapp/features/RecurringTransaction/Cubit/get_recurring_transaction_cubit.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Enums/RecurringTransactionStatus.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Recurring.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/RecurringTransaction.dart';
import 'package:expenseapp/features/Statistics/Screen/statistics_screen.dart';
import 'package:expenseapp/features/Transaction/Cubits/add_transaction_cubit.dart';
import 'package:expenseapp/features/Transaction/Screen/transaction_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

GlobalKey<_BottomNavigationPageChnageState> bottomNavKey = GlobalKey<_BottomNavigationPageChnageState>();

class BottomNavigationPageChnage extends StatefulWidget {
  const BottomNavigationPageChnage({super.key});

  @override
  State<BottomNavigationPageChnage> createState() => _BottomNavigationPageChnageState();

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(builder: (_) => const BottomNavigationPageChnage());
  }
}

class _BottomNavigationPageChnageState extends State<BottomNavigationPageChnage> {
  final ValueNotifier<int> selectedIndex = ValueNotifier(0);

  final List<Widget> pages = [const HomePage(), const TransactionScreen(), const StatisticsScreen(), const ProfileScreen()];

  @override
  void initState() {
    super.initState();
    selectedIndex.value = 0;
    Future.microtask(() {
      context.read<EditHomeCubit>().loadMenu(UiUtils.homeMenuList);
      context.read<GetTransactionCubit>().fetchTransaction();
      context.read<GetAccountCubit>().getAccount();
      context.read<GetCategoryCubit>().getCategory();
      context.read<GetRecurringTransactionCubit>().fetchRecurringTransaction();
    });
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  @override
  void dispose() {
    selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ValueListenableBuilder(
      valueListenable: selectedIndex,
      builder: (context, value, child) {
        return PopScope(
          canPop: selectedIndex.value == 0,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            if (selectedIndex.value != 0) {
              changeTab(0);
            }
          },
          child: BlocListener<GetRecurringTransactionCubit, GetRecurringTransactionState>(
            listenWhen: (previous, current) {
              return previous is! GetRecurringTransactionSuccess && current is GetRecurringTransactionSuccess;
            },
            listener: (context, state) async {
              if (state is! GetRecurringTransactionSuccess) return;

              final recurringCubit = context.read<GetRecurringTransactionCubit>();

              // 🔒 Prevent re-entry
              if (recurringCubit.isProcessing) return;
              recurringCubit.startProcessing();

              try {
                final dueRecurrings = recurringCubit.getDueRecurringTransactions();

                for (final recurring in dueRecurrings) {
                  log('recurring transaction to be added ${recurring.toJson()}');

                  for (final rt in recurring.recurringTransactions) {
                    // 🛡 Extra safety: skip if already processed
                    if (rt.transactionId.isNotEmpty) continue;

                    final transactionId = 'TR'.withDateTimeMillisRandom();

                    context.read<GetTransactionCubit>().addTransactionsLocally([
                      Transaction(
                        id: transactionId,
                        title: recurring.title,
                        amount: recurring.amount,
                        date: rt.scheduleDate,
                        accountId: recurring.accountId,
                        categoryId: recurring.categoryId,
                        type: recurring.type,
                        recurringId: recurring.recurringId,
                        recurringTransactionId: rt.recurringTransactionId,
                        addFromType: TransactionType.RECURRING,
                      ),
                    ]);

                    await recurringCubit.updateRecurringTransactionByStatus(
                      transaction: recurring,
                      recurringTransaction: rt,
                      status: RecurringTransactionStatus.PAID,
                      transactionId: transactionId,
                    );
                  }
                }
              } catch (e, st) {
                log('Recurring processing failed', error: e, stackTrace: st);
              } finally {
                // ✅ ONLY HERE
                recurringCubit.endProcessing();
              }
            },

            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: IndexedStack(index: value, children: pages),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FloatingActionButton(
                heroTag: null,
                shape: const CircleBorder(),
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.transactionTabBarView);
                },
                child: Icon(Icons.add, size: 30.sp(context), color: colorScheme.surface),
              ),

              bottomNavigationBar: MediaQuery.removePadding(
                removeBottom: true,
                removeLeft: true,
                removeRight: true,
                removeTop: true,
                context: context,
                child: BottomAppBar(
                  color: colorScheme.surface,
                  shape: const CircularNotchedRectangle(),
                  notchMargin: 5,
                  elevation: 15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _bottomItem(Icons.home_outlined, context.tr('homeKey'), 0),
                      _bottomItem(Icons.compare_arrows, context.tr('transactionsKey'), 1),
                      const SizedBox(width: 40),
                      _bottomItem(Icons.stacked_bar_chart, context.tr('statisticsKey'), 2),
                      _bottomItem(Icons.person_outline, context.tr('profileKey'), 3),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _bottomItem(IconData icon, String label, int index) {
    return ValueListenableBuilder(
      valueListenable: selectedIndex,
      builder: (context, value, child) {
        final isSelected = selectedIndex.value == index;
        return GestureDetector(
          onTap: () {
            selectedIndex.value = index;
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.2 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    icon,
                    color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey,
                    size: 22.sp(context),
                  ),
                ),
                const SizedBox(height: 2),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: const TextStyle(),
                  child: CustomTextView(
                    text: label,
                    fontSize: 12.sp(context),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
