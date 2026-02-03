import 'package:expenseapp/commons/widgets/custom_app_bar.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BudgetHistoryScreen extends StatefulWidget {
  BudgetHistoryScreen({required this.categories, super.key});
  List<String> categories;

  @override
  State<BudgetHistoryScreen> createState() => _BudgetHistoryScreenState();

  static Route<dynamic>? route(RouteSettings routeSettings) {
    final args = routeSettings.arguments as Map<String, dynamic>?;

    final categories = args?['category'] as List<String>;

    return CupertinoPageRoute(
      builder: (_) => BudgetHistoryScreen(categories: categories),
    );
  }
}

class _BudgetHistoryScreenState extends State<BudgetHistoryScreen> {
  List<Map<String, dynamic>> budgetList = [];
  @override
  void initState() {
    super.initState();
    budgetList = context.read<GetTransactionCubit>().getTransactionByCategoryId(categoryIds: widget.categories);
    log('budgetList $budgetList');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: QAppBar(
        title: CustomTextView(text: context.tr('budgetHistoryKey'), fontSize: 20.sp(context), color: Colors.white),
      ),
      body: ResponsivePadding(
        topPadding: context.height * 0.01,
        bottomPadding: context.height * 0.01,
        leftPadding: context.width * 0.04,
        rightPadding: context.width * 0.04,
        child: ListView.builder(
          padding: EdgeInsetsDirectional.zero,
          itemCount: budgetList.length,
          itemBuilder: (context, index) {
            final category = budgetList[index];
            final categoryId = category['categoryId'] as String;
            final categoryName = context.read<GetCategoryCubit>().getCategoryName(categoryId);
            final total = category['total'] as double;
            final transaction = category['transactions'] as List<Transaction>;

            // return Column(
            //   children: [
            //     Padding(
            //       padding: const EdgeInsetsDirectional.only(top: 10, bottom: 10),
            //       child: _sectionTitle(categoryName, total.formatAmt()),
            //     ),
            // ...transaction.map((item) {
            //   final type = item.type;
            //   final subtitle = item.title;
            //   final accountName = context.read<GetAccountCubit>().getAccountName(id: item.accountId);
            //   final amount = item.amount;
            //   final isIncome = type == TransactionType.INCOME;
            //   final isExpense = type == TransactionType.EXPENSE;
            //   final date = UiUtils.parseDate(item.date);

            //   return Container(
            //     margin: (transaction.length > 1) ? EdgeInsetsDirectional.only(bottom: context.height * 0.01) : EdgeInsetsDirectional.zero,
            //     padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.02, vertical: context.height * 0.0001),
            //     decoration: BoxDecoration(
            //       color: colorScheme.surface,
            //       borderRadius: BorderRadius.circular(8),
            //       boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .08), blurRadius: 12, offset: const Offset(0, 6))],
            //     ),
            //     child: Container(
            //       padding: const EdgeInsetsDirectional.all(10),
            //       child: Row(
            //         mainAxisAlignment: .center,

            //         children: [
            //           Container(
            //             height: 30.sp(context),
            //             width: 30.sp(context),
            //             decoration: BoxDecoration(
            //               color: isExpense ? context.colorScheme.expenseColor.withValues(alpha: 0.09) : context.colorScheme.incomeColor.withValues(alpha: 0.09),
            //               shape: BoxShape.circle,
            //             ),
            //             child: Icon(
            //               isExpense ? Icons.arrow_upward : Icons.arrow_downward,

            //               color: isExpense ? context.colorScheme.expenseColor : context.colorScheme.incomeColor,

            //               size: 20.sp(context),
            //             ),
            //           ),

            //           SizedBox(width: context.width * 0.03),

            //           Expanded(
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               mainAxisAlignment: .center,
            //               children: [
            //                 CustomTextView(
            //                   text: UiUtils.covertInBuiltDate(date, context),
            //                   fontWeight: FontWeight.bold,
            //                   color: Colors.black,
            //                   fontSize: context.isTablet ? 18.sp(context) : 15.sp(context),
            //                   maxLines: 2,
            //                 ),

            //                 if (subtitle.isNotEmpty) ...[
            //                   CustomTextView(
            //                     text: subtitle,
            //                     color: Colors.black,
            //                     fontSize: context.isTablet ? 15.sp(context) : 14.sp(context),
            //                   ),
            //                 ],
            //               ],
            //             ),
            //           ),

            //           Column(
            //             crossAxisAlignment: CrossAxisAlignment.end,

            //             children: [
            //               Row(
            //                 children: [
            //                   if (item.recurringId.isNotEmpty) ...[
            //                     Icon(Icons.repeat, color: Colors.black, size: 15.sp(context)),
            //                   ],
            //                   SizedBox(width: context.width * 0.02),
            //                   CustomTextView(
            //                     text: amount.formatAmt(),
            //                     fontWeight: FontWeight.bold,
            //                     color: isIncome ? context.colorScheme.incomeColor : context.colorScheme.expenseColor,
            //                   ),
            //                 ],
            //               ),

            //               CustomTextView(text: accountName, fontSize: 14.sp(context), color: Colors.grey.shade600),
            //             ],
            //           ),
            //         ],
            //       ),
            //     ),
            //   );
            // }),
            //   ],
            // );
            return Padding(
              padding: const EdgeInsetsDirectional.only(top: 8, bottom: 8),
              child: _categorySection(
                title: categoryName,
                total: total.formatAmt(),
                icon: Icons.music_note,
                children: [
                  ...transaction.map((item) {
                    final type = item.type;
                    final subtitle = item.title;
                    final accountName = context.read<GetAccountCubit>().getAccountName(id: item.accountId);
                    final amount = item.amount;
                    final isIncome = type == TransactionType.INCOME;
                    final isExpense = type == TransactionType.EXPENSE;
                    final date = UiUtils.parseDate(item.date);

                    return Container(
                      margin: (transaction.length > 1) ? EdgeInsetsDirectional.only(bottom: context.height * 0.01) : EdgeInsetsDirectional.zero,
                      padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.02, vertical: context.height * 0.0001),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .08), blurRadius: 12, offset: const Offset(0, 6))],
                      ),
                      child: Container(
                        padding: const EdgeInsetsDirectional.all(10),
                        child: Row(
                          mainAxisAlignment: .center,
                          children: [
                            Container(
                              height: 30.sp(context),
                              width: 30.sp(context),
                              decoration: BoxDecoration(
                                color: isExpense ? context.colorScheme.expenseColor.withValues(alpha: 0.09) : context.colorScheme.incomeColor.withValues(alpha: 0.09),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isExpense ? Icons.arrow_upward : Icons.arrow_downward,

                                color: isExpense ? context.colorScheme.expenseColor : context.colorScheme.incomeColor,

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
                                    text: UiUtils.covertInBuiltDate(date, context),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: context.isTablet ? 18.sp(context) : 15.sp(context),
                                    maxLines: 2,
                                  ),

                                  if (subtitle.isNotEmpty) ...[
                                    CustomTextView(
                                      text: subtitle,
                                      color: Colors.black,
                                      fontSize: context.isTablet ? 15.sp(context) : 14.sp(context),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,

                              children: [
                                Row(
                                  children: [
                                    if (item.recurringId.isNotEmpty) ...[
                                      Icon(Icons.repeat, color: Colors.black, size: 15.sp(context)),
                                    ],
                                    SizedBox(width: context.width * 0.02),
                                    CustomTextView(
                                      text: amount.formatAmt(),
                                      fontWeight: FontWeight.bold,
                                      color: isIncome ? context.colorScheme.incomeColor : context.colorScheme.expenseColor,
                                    ),
                                  ],
                                ),

                                CustomTextView(text: accountName, fontSize: 14.sp(context), color: Colors.grey.shade600),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, String amount) {
    return Row(
      children: [
        Expanded(
          child: CustomTextView(
            text: title,
            fontSize: 16.sp(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        CustomTextView(
          text: amount,
          fontSize: 16.sp(context),
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}

Widget _categorySection({
  required String title,
  required String total,
  required IconData icon,
  required List<Widget> children,
}) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(.15),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(title.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            Text(total, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        child: Column(
          children: children,
        ),
      ),
    ],
  );
}

// import 'package:flutter/material.dart';

// class BudgetHistoryPage extends StatefulWidget {
//   const BudgetHistoryPage({super.key});

//   @override
//   State<BudgetHistoryPage> createState() =>
//       _BudgetHistoryPageState();
// }

// class _BudgetHistoryPageState
//     extends State<BudgetHistoryPage> {
//   bool dark = false;

//   @override
//   Widget build(BuildContext context) {
//     final primary = const Color(0xFF1E3A8A);
//     final bgLight = const Color(0xFFF8FAFC);
//     final bgDark = const Color(0xFF0F172A);
//     final surfaceDark = const Color(0xFF1E293B);

//     return Theme(
//       data: dark ? ThemeData.dark() : ThemeData.light(),
//       child: Scaffold(
//         backgroundColor: dark ? bgDark : bgLight,

//         /// DARK TOGGLE
//         floatingActionButton: FloatingActionButton(
//           mini: true,
//           onPressed: () =>
//               setState(() => dark = !dark),
//           child: Icon(
//               dark ? Icons.light_mode : Icons.dark_mode),
//         ),

//         body: Column(
//           children: [
//             /// STATUS BAR
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 16, vertical: 6),
//               child: Row(
//                 mainAxisAlignment:
//                     MainAxisAlignment.spaceBetween,
//                 children: const [
//                   Text("10:43",
//                       style: TextStyle(
//                           fontWeight: FontWeight.w600)),
//                   Row(
//                     children: [
//                       Icon(Icons.signal_cellular_4_bar,
//                           size: 16),
//                       SizedBox(width: 4),
//                       Icon(Icons.wifi, size: 16),
//                       SizedBox(width: 4),
//                       Icon(Icons.battery_full,
//                           size: 16),
//                     ],
//                   )
//                 ],
//               ),
//             ),

//             /// HEADER
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.fromLTRB(
//                   20, 10, 20, 30),
//               decoration: BoxDecoration(
//                 color: primary,
//                 borderRadius:
//                     const BorderRadius.vertical(
//                         bottom:
//                             Radius.circular(32)),
//                 boxShadow: [
//                   BoxShadow(
//                       color:
//                           Colors.black.withOpacity(.2),
//                       blurRadius: 10)
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment:
//                     CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: const [
//                       Icon(Icons.arrow_back,
//                           color: Colors.white),
//                       SizedBox(width: 12),
//                       Text(
//                         "Budget History",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 22,
//                             fontWeight:
//                                 FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),

//                   /// TOTAL SPENT PILL
//                   Container(
//                     padding:
//                         const EdgeInsets.symmetric(
//                             horizontal: 18,
//                             vertical: 10),
//                     decoration: BoxDecoration(
//                       color: Colors.white
//                           .withOpacity(.15),
//                       borderRadius:
//                           BorderRadius.circular(
//                               30),
//                     ),
//                     child: const Row(
//                       mainAxisAlignment:
//                           MainAxisAlignment
//                               .spaceBetween,
//                       children: [
//                         Text("Total Spent",
//                             style: TextStyle(
//                                 color:
//                                     Colors.white70)),
//                         Text("3,090.00",
//                             style: TextStyle(
//                                 color:
//                                     Colors.white,
//                                 fontWeight:
//                                     FontWeight
//                                         .bold)),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),

//             /// CONTENT
//             Expanded(
//               child: ListView(
//                 padding:
//                     const EdgeInsets.all(16),
//                 children: [
//                   _categorySection(
//                     title: "Music",
//                     total: "290",
//                     icon: Icons.music_note,
//                     children: [
//                       _transactionTile(
//                           "Today",
//                           "trst",
//                           "290"),
//                     ],
//                     dark: dark,
//                   ),
//                   const SizedBox(height: 16),
//                   _categorySection(
//                     title: "Entertainment",
//                     total: "2.8K",
//                     icon:
//                         Icons.theater_comedy,
//                     children: [
//                       _transactionTile(
//                           "February 2, 2026",
//                           "hyy",
//                           "250"),
//                       _transactionTile(
//                           "February 2, 2026",
//                           "Movie Night",
//                           "1.75K"),
//                       _transactionTile(
//                           "February 2, 2026",
//                           "Arcade",
//                           "800"),
//                     ],
//                     dark: dark,
//                   ),
//                   const SizedBox(height: 80),
//                 ],
//               ),
//             ),
//           ],
//         ),

//         /// BOTTOM NAV
//         bottomNavigationBar:
//             _bottomNav(primary),
//       ),
//     );
//   }

//   /// CATEGORY SECTION

//   /// TRANSACTION TILE
Widget _transactionTile(String date, String note, String amount) {
  return ListTile(
    leading: CircleAvatar(
      backgroundColor: Colors.red.withOpacity(.15),
      child: const Icon(Icons.north_east, color: Colors.red),
    ),
    title: Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text(note),
    trailing: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          amount,
          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        const Text('Cash', style: TextStyle(fontSize: 11)),
      ],
    ),
  );
}

//   /// BOTTOM NAV BAR
//   Widget _bottomNav(Color primary) {
//     return BottomAppBar(
//       child: SizedBox(
//         height: 70,
//         child: Row(
//           mainAxisAlignment:
//               MainAxisAlignment
//                   .spaceAround,
//           children: [
//             Icon(Icons.home,
//                 color: primary),
//             const Icon(
//                 Icons.receipt_long,
//                 color: Colors.grey),
//             Container(
//               width: 56,
//               height: 56,
//               decoration:
//                   BoxDecoration(
//                 color: primary,
//                 shape:
//                     BoxShape.circle,
//               ),
//               child: const Icon(
//                   Icons.add,
//                   color:
//                       Colors.white),
//             ),
//             const Icon(Icons.analytics,
//                 color: Colors.grey),
//             const Icon(Icons.settings,
//                 color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }
// }
