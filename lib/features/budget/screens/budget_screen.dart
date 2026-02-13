import 'dart:math' as math;

import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/budget/cubits/delete_budget_cubit.dart';
import 'package:expenseapp/features/budget/cubits/get_budget_cubit.dart';
import 'package:expenseapp/features/budget/models/Budget.dart';
import 'package:expenseapp/features/budget/models/enums/BudgetType.dart';
import 'package:flutter/material.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetBudgetCubit>().getBudget();
  }

  String label = '';
  double left = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QAppBar(
        title: CustomTextView(text: context.tr('budgetKey'), fontSize: 20.sp(context), color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.addBudget);
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.pushNamed(context, Routes.addBudget);
      //   },
      //   child: const Icon(Icons.add),
      // ),
      body: ResponsivePadding(
        topPadding: context.height * 0.01,
        bottomPadding: context.height * 0.01,
        leftPadding: context.width * 0.04,
        rightPadding: context.width * 0.04,
        child: BlocConsumer<GetBudgetCubit, GetBudgetState>(
          listener: (context, state) {
            if (state is GetBudgetSuccess) {}
          },
          builder: (context, state) {
            if (state is GetBudgetSuccess) {
              final budgetList = state.budget;
              if (budgetList.isEmpty) {
                return CustomErrorWidget(
                  errorMessage: context.tr('noDataFound'),
                  errorType: CustomErrorType.noDataFound,
                  onRetry: () {
                    context.read<GetBudgetCubit>().getBudget();
                  },
                );
              }
              return ListView.builder(
                padding: EdgeInsetsDirectional.zero,
                shrinkWrap: true,
                itemCount: budgetList.length,
                itemBuilder: (context, index) {
                  final item = budgetList[index];
                  final result = context.read<GetTransactionCubit>().getTotalBudgetSpent(categoryIds: item.catedoryId, type: item.type, date: item.endDate);

                  final spent = result;

                  final limit = item.amount;
                  //final absSpent = result.abs();

                  if (item.type == TransactionType.INCOME) {
                    if (spent > limit) {
                      // Over saved
                      left = spent - limit;
                      label = context.tr('overSavedKey');
                    } else {
                      // Remaining to reach goal
                      left = limit - spent;
                      label = context.tr('leftKey');
                    }
                  } else if (item.type == TransactionType.EXPENSE) {
                    // EXPENSE
                    if (spent > limit) {
                      // Over spent
                      left = spent - limit;
                      label = context.tr('overSpentKey');
                    } else {
                      // Remaining budget
                      left = limit - spent;
                      label = context.tr('leftKey');
                    }
                  } else {
                    // ALL Type

                    if (spent < 0) {
                      // Income case
                      log('spent in all $spent');

                      left = spent.abs();
                      label = context.tr('overSavedKey');
                    } else if (spent > limit) {
                      // Overspent
                      log('spent in all $spent');
                      log('limit in all $limit');
                      left = spent - limit;
                      log('left in all $left');
                      label = context.tr('overSpentKey');
                    } else {
                      // Normal remaining
                      left = limit - spent;
                      label = context.tr('leftKey');
                    }
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.budgetHistory, arguments: {'item': item});
                    },
                    child: BudgetCard(
                      title: item.budgetName,
                      left: left,
                      spent: result,
                      percent: (spent / item.amount) * 100,
                      limit: item.amount,
                      category: item.catedoryId,
                      type: item.type,
                      budget: item,
                      label: label,
                    ),
                  );
                },
              );
            }
            if (state is GetBudgetFailure) {
              return CustomErrorWidget(
                errorMessage: state.error,
                onRetry: () {
                  context.read<GetBudgetCubit>().getBudget();
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

//original
// class BudgetCard extends StatelessWidget {
//   const BudgetCard({
//     required this.title,
//     required this.left,
//     required this.spent,
//     required this.percent,
//     required this.limit,
//     required this.category,
//     required this.type,
//     required this.budget,
//     required this.label,
//     super.key,
//   });
//   final String title;
//   final double left;
//   final double spent;
//   final double percent;
//   final double limit;
//   final List<String> category;
//   final TransactionType type;
//   final Budget budget;
//   final String label;

//   @override
//   Widget build(BuildContext context) {
//     final parseEndDate = UiUtils.parseDate(budget.endDate);
//     final colorScheme = Theme.of(context).colorScheme;
//     return Container(
//       margin: const EdgeInsetsDirectional.only(bottom: 8),
//       padding: const EdgeInsetsDirectional.all(15),
//       decoration: BoxDecoration(
//         color: colorScheme.primary.withValues(alpha: 0.2),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.white10),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: CustomTextView(text: title, fontSize: 15.sp(context), fontWeight: FontWeight.bold, softWrap: true, maxLines: 3),
//               ),
//               Container(
//                 padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.02, vertical: 2.sp(context)),
//                 decoration: BoxDecoration(
//                   color: colorScheme.primary.withValues(alpha: 0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: CustomTextView(text: '${category.length} ${context.tr('categoryKey')}', fontSize: 12.sp(context), color: Colors.black),
//               ),
//               if (!parseEndDate.isPast)
//                 PopupMenuButton<String>(
//                   padding: EdgeInsetsGeometry.zero,
//                   constraints: BoxConstraints(
//                     maxHeight: context.screenHeight * (context.isMobile ? 0.5 : 0.1),
//                     maxWidth: context.screenWidth * (context.isMobile ? 1.5 : 2.5),
//                   ),
//                   icon: Container(
//                     height: 36,
//                     width: 5,
//                     alignment: Alignment.centerRight,
//                     child: const Icon(
//                       Icons.more_vert,
//                     ),
//                   ),
//                   onSelected: (value) {
//                     if (value == context.tr('editKey')) {
//                       Navigator.pushNamed(context, Routes.addBudget, arguments: {'item': budget, 'isEdit': true});
//                     } else if (value == context.tr('deleteKey')) {
//                       showDeleteAlertDialog(context: context, budget: budget);
//                     }
//                   },
//                   itemBuilder: (context) => [
//                     _popUpMenuBuild(value: context.tr('editKey'), text: context.tr('editKey'), icon: Icons.edit, color: Colors.black, context: context),
//                     _popUpMenuBuild(value: context.tr('deleteKey'), text: context.tr('deleteKey'), icon: Icons.delete, color: context.colorScheme.expenseColor, context: context),
//                   ],
//                 ),
//             ],
//           ),

//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   CustomTextView(
//                     text: '${context.symbol}$left ',
//                     fontSize: 18.sp(context),
//                     fontWeight: FontWeight.bold,
//                   ),
//                   CustomTextView(
//                     text: label,
//                     fontSize: 12.sp(context),
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black.withValues(alpha: 0.5),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   CustomTextView(
//                     text: spent < 0 ? context.tr('savedKey') : context.tr('usedKey'),
//                     color: Colors.black,
//                     fontSize: 12.sp(context),
//                     fontWeight: FontWeight.bold,
//                   ),
//                   CustomTextView(text: '  ${context.symbol}${spent.abs()}', color: Colors.black),
//                 ],
//               ),
//             ],
//           ),

//           SizedBox(height: context.height * 0.009),
//           SizedBox(
//             height: 10,
//             child: ClipRRect(
//               borderRadius: const BorderRadius.all(Radius.circular(10)),
//               child: LinearProgressIndicator(
//                 value: percent / 100,

//                 valueColor: AlwaysStoppedAnimation<Color>(
//                   colorScheme.primary.withValues(alpha: 0.8),
//                 ),
//                 backgroundColor: colorScheme.primary.withValues(alpha: 0.2),
//               ),
//             ),
//           ),

//           SizedBox(height: context.height * 0.009),

//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               CustomTextView(text: '${percent.toInt()}%', fontSize: 12.sp(context), color: Theme.of(context).primaryColor),
//               Row(
//                 children: [
//                   CustomTextView(
//                     text: context.tr('limitKey'),
//                     color: Colors.black,
//                     fontSize: 12.sp(context),
//                     fontWeight: FontWeight.bold,
//                   ),
//                   CustomTextView(text: '  ${context.symbol}$limit', color: Colors.black, fontSize: 12.sp(context)),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

// class BudgetCard extends StatelessWidget {
//   const BudgetCard({
//     required this.title,
//     required this.left,
//     required this.spent,
//     required this.percent,
//     required this.limit,
//     required this.category,
//     required this.type,
//     required this.budget,
//     required this.label,
//     super.key,
//   });

//   final String title;
//   final double left;
//   final double spent;
//   final double percent;
//   final double limit;
//   final List<String> category;
//   final TransactionType type;
//   final Budget budget;
//   final String label;

//   // Helper to determine color based on percentage spent
//   Color _getStatusColor(BuildContext context, double percent) {
//     if (percent >= 90) return context.colorScheme.expenseColor; // Red
//     if (percent >= 70) return Colors.orange;
//     return context.colorScheme.incomeColor; // Green
//   }

//   @override
//   Widget build(BuildContext context) {
//     final parseEndDate = UiUtils.parseDate(budget.endDate);
//     final theme = Theme.of(context);
//     final colorScheme = context.colorScheme;
//     final statusColor = _getStatusColor(context, percent);

//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(24),
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             colorScheme.surface,
//             colorScheme.surface.withValues(alpha: 0.8),
//           ],
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//         border: Border.all(
//           color: colorScheme.primary.withValues(alpha: 0.1),
//         ),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(24),
//         child: Stack(
//           children: [
//             // Subtle accent background decoration
//             Positioned(
//               right: -20,
//               top: -20,
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundColor: statusColor.withValues(alpha: 0.05),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // --- HEADER ---
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             CustomTextView(
//                               text: title,
//                               fontSize: 18.sp(context),
//                               fontWeight: FontWeight.bold,
//                               color: colorScheme.primaryTextColor,
//                             ),
//                             const SizedBox(height: 4),
//                             Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                               decoration: BoxDecoration(
//                                 color: colorScheme.primary.withValues(alpha: 0.1),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: CustomTextView(
//                                 text: '${category.length} ${context.tr('categoryKey')}',
//                                 fontSize: 10.sp(context),
//                                 fontWeight: FontWeight.w600,
//                                 color: colorScheme.primary,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       if (!parseEndDate.isPast) _buildMenu(context),
//                     ],
//                   ),
//                   const SizedBox(height: 20),

//                   // --- MAIN VALUES ---
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       CustomTextView(
//                         text: '${context.symbol}${left.toStringAsFixed(0)}',
//                         fontSize: 26.sp(context),
//                         fontWeight: FontWeight.bold,
//                         color: colorScheme.primaryTextColor,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 4, left: 6),
//                         child: CustomTextView(
//                           text: label,
//                           fontSize: 14.sp(context),
//                           color: colorScheme.primaryTextColor.withValues(alpha: 0.6),
//                         ),
//                       ),
//                       const Spacer(),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           CustomTextView(
//                             text: spent < 0 ? context.tr('savedKey') : context.tr('usedKey'),
//                             fontSize: 12.sp(context),
//                             color: colorScheme.primaryTextColor.withValues(alpha: 0.5),
//                           ),
//                           CustomTextView(
//                             text: '${context.symbol}${spent.abs().toStringAsFixed(0)}',
//                             fontSize: 14.sp(context),
//                             fontWeight: FontWeight.bold,
//                             color: colorScheme.primaryTextColor,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 16),

//                   // --- PROGRESS BAR ---
//                   Stack(
//                     children: [
//                       Container(
//                         height: 12,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: colorScheme.primary.withValues(alpha: 0.05),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       FractionallySizedBox(
//                         widthFactor: (percent / 100).clamp(0.0, 1.0),
//                         child: Container(
//                           height: 12,
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [statusColor.withValues(alpha: 0.6), statusColor],
//                             ),
//                             borderRadius: BorderRadius.circular(10),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: statusColor.withValues(alpha: 0.3),
//                                 blurRadius: 4,
//                                 offset: const Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 12),

//                   // --- FOOTER ---
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.bolt, size: 14, color: statusColor),
//                           CustomTextView(
//                             text: ' ${percent.toInt()}% Spend',
//                             fontSize: 12.sp(context),
//                             fontWeight: FontWeight.bold,
//                             color: statusColor,
//                           ),
//                         ],
//                       ),
//                       RichText(
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                               text: '${context.tr('limitKey')}: ',
//                               style: TextStyle(
//                                 color: colorScheme.primaryTextColor.withValues(alpha: 0.5),
//                                 fontSize: 12.sp(context),
//                               ),
//                             ),
//                             TextSpan(
//                               text: '${context.symbol}$limit',
//                               style: TextStyle(
//                                 color: colorScheme.primaryTextColor,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 12.sp(context),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// class BudgetCard extends StatelessWidget {
//   const BudgetCard({
//     required this.title,
//     required this.left,
//     required this.spent,
//     required this.percent,
//     required this.limit,
//     required this.category,
//     required this.type,
//     required this.budget,
//     required this.label,
//     super.key,
//   });

//   final String title;
//   final double left;
//   final double spent;
//   final double percent;
//   final double limit;
//   final List<String> category;
//   final TransactionType type;
//   final Budget budget;
//   final String label;

//   Color _getStatusColor(BuildContext context, double percent) {
//     if (percent >= 90) return context.colorScheme.expenseColor;
//     if (percent >= 70) return Colors.orange;
//     return context.colorScheme.incomeColor;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final parseEndDate = UiUtils.parseDate(budget.endDate);
//     final colorScheme = context.colorScheme;
//     final statusColor = _getStatusColor(context, percent);

//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(24),
//         color: colorScheme.surface,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//         border: Border.all(
//           color: colorScheme.primary.withValues(alpha: 0.1),
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // --- HEADER ---
//             Row(
//               children: [
//                 Expanded(
//                   child: CustomTextView(
//                     text: title,
//                     fontSize: 16.sp(context),
//                     fontWeight: FontWeight.bold,
//                     color: colorScheme.primaryTextColor,
//                   ),
//                 ),
//                 if (!parseEndDate.isPast) _buildMenu(context),
//               ],
//             ),
//             const SizedBox(height: 12),

//             // --- MAIN VALUES (FIXED OVERFLOW HERE) ---
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 // 1. Left Amount Section - Wrapped in Expanded + FittedBox
//                 Expanded(
//                   flex: 3, // Takes more space
//                   child: FittedBox(
//                     fit: BoxFit.scaleDown, // This shrinks text if too long
//                     alignment: Alignment.bottomLeft,
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         CustomTextView(
//                           text: '${context.symbol}${left.toStringAsFixed(0)}',
//                           fontSize: 28.sp(context),
//                           fontWeight: FontWeight.bold,
//                           color: colorScheme.primaryTextColor,
//                         ),
//                         const SizedBox(width: 4),
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 4),
//                           child: CustomTextView(
//                             text: label,
//                             fontSize: 14.sp(context),
//                             color: colorScheme.primaryTextColor.withValues(alpha: 0.5),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(width: 12), // Minimum gap
//                 // 2. Spent Section - Wrapped in Flexible
//                 Flexible(
//                   flex: 2,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       CustomTextView(
//                         text: spent < 0 ? context.tr('savedKey') : context.tr('usedKey'),
//                         fontSize: 11.sp(context),
//                         color: colorScheme.primaryTextColor.withValues(alpha: 0.5),
//                       ),
//                       FittedBox(
//                         fit: BoxFit.scaleDown,
//                         child: CustomTextView(
//                           text: '${context.symbol}${spent.abs().toStringAsFixed(0)}',
//                           fontSize: 14.sp(context),
//                           fontWeight: FontWeight.bold,
//                           color: colorScheme.primaryTextColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 16),

//             // --- PROGRESS BAR ---
//             Stack(
//               children: [
//                 Container(
//                   height: 10,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: colorScheme.primary.withValues(alpha: 0.1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 FractionallySizedBox(
//                   widthFactor: (percent / 100).clamp(0.0, 1.0),
//                   child: Container(
//                     height: 10,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [statusColor.withValues(alpha: 0.7), statusColor],
//                       ),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 12),

//             // --- FOOTER ---
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 CustomTextView(
//                   text: '${percent.toInt()}%',
//                   fontSize: 12.sp(context),
//                   fontWeight: FontWeight.bold,
//                   color: statusColor,
//                 ),
//                 CustomTextView(
//                   text: '${context.tr('limitKey')}: ${context.symbol}$limit',
//                   fontSize: 12.sp(context),
//                   color: colorScheme.primaryTextColor.withValues(alpha: 0.6),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMenu(BuildContext context) {
//     return PopupMenuButton<String>(
//       padding: EdgeInsets.zero,
//       icon: Icon(Icons.more_horiz, color: context.colorScheme.primaryTextColor),
//       onSelected: (value) {
//         if (value == context.tr('editKey')) {
//           Navigator.pushNamed(context, Routes.addBudget, arguments: {'item': budget, 'isEdit': true});
//         } else if (value == context.tr('deleteKey')) {
//           showDeleteAlertDialog(context: context, budget: budget);
//         }
//       },
//       itemBuilder: (context) => [
//         _popUpMenuBuild(value: context.tr('editKey'), text: context.tr('editKey'), icon: Icons.edit, color: context.colorScheme.primaryTextColor, context: context),
//         _popUpMenuBuild(value: context.tr('deleteKey'), text: context.tr('deleteKey'), icon: Icons.delete, color: context.colorScheme.expenseColor, context: context),
//       ],
//     );
//   }
// }

//original
//   Widget _buildMenu(BuildContext context) {
//     return PopupMenuButton<String>(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       icon: Icon(Icons.more_horiz, color: context.colorScheme.primaryTextColor.withValues(alpha: 0.6)),
//       onSelected: (value) {
//         if (value == context.tr('editKey')) {
//           Navigator.pushNamed(context, Routes.addBudget, arguments: {'item': budget, 'isEdit': true});
//         } else if (value == context.tr('deleteKey')) {
//           showDeleteAlertDialog(context: context, budget: budget);
//         }
//       },
//       itemBuilder: (context) => [
//         _popUpMenuBuild(
//           value: context.tr('editKey'),
//           text: context.tr('editKey'),
//           icon: Icons.edit_outlined,
//           color: context.colorScheme.primaryTextColor,
//           context: context,
//         ),
//         _popUpMenuBuild(
//           value: context.tr('deleteKey'),
//           text: context.tr('deleteKey'),
//           icon: Icons.delete_outline,
//           color: context.colorScheme.expenseColor,
//           context: context,
//         ),
//       ],
//     );
//   }
// }

class BudgetCard extends StatelessWidget {
  const BudgetCard({
    required this.title,
    required this.left,
    required this.spent,
    required this.percent,
    required this.limit,
    required this.category,
    required this.type,
    required this.budget,
    required this.label,
    super.key,
  });

  final String title;
  final double left;
  final double spent;
  final double percent;
  final double limit;
  final List<String> category;
  final TransactionType type;
  final Budget budget;
  final String label;

  // Color _getHealthColor(double percent) {
  //   if (percent >= 90) return Colors.red.withValues(alpha: 0.9);
  //   if (percent >= 70) return Colors.orange;
  //   return Colors.green;
  // }

  @override
  Widget build(BuildContext context) {
    final colorSCheme = Theme.of(context).colorScheme;
    final parseEndDate = UiUtils.parseDate(budget.endDate);
    // final healthColor = _getHealthColor(percent);
    final isPast = parseEndDate.isPast; // Define the condition

    // 1. Store your existing UI in a variable
    final Widget cardContent = Container(
      margin: const EdgeInsetsDirectional.only(bottom: 16),
      padding: const EdgeInsetsDirectional.all(12),
      decoration: BoxDecoration(
        color: colorSCheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorSCheme.primary.withValues(alpha: 0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colorSCheme.primary.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextView(
                      text: title,
                      fontSize: 16.sp(context),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 6),
                    // Category Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorSCheme.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomTextView(
                        text: '${category.length} ${context.tr('categoryKey')}',
                        fontSize: 10.sp(context),
                        fontWeight: FontWeight.bold,
                        color: colorSCheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isPast) _buildPopupMenu(context),
            ],
          ),

          const SizedBox(height: 10),

          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: [
          //     Expanded(
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           CustomTextView(
          //             text: label,
          //             fontSize: 15.sp(context),
          //             color: Colors.grey.shade700,
          //             fontWeight: FontWeight.w600,
          //           ),
          //           CustomTextView(
          //             text: '${context.symbol}${left.toStringAsFixed(0)}',
          //             fontSize: 16.sp(context),
          //             fontWeight: FontWeight.w900,
          //             color: Colors.black,
          //           ),
          //         ],
          //       ),
          //     ),
          //     const SizedBox(width: 12),
          //     Expanded(
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.end,
          //         children: [
          // CustomTextView(
          //   text: spent < 0 ? context.tr('savedKey') : context.tr('usedKey'),
          //   fontSize: 15.sp(context),
          //   color: Colors.grey.shade700,
          //   fontWeight: FontWeight.w600,
          // ),
          //           CustomTextView(
          //             text: '${context.symbol}${spent.abs().toStringAsFixed(0)}',
          //             fontSize: 16.sp(context),
          //             fontWeight: FontWeight.bold,
          //             // color: healthColor,
          //             color: Colors.black,
          //             // softWrap: true,
          //             // overflow: TextOverflow.ellipsis,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          Column(
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  CustomTextView(
                    text: label,
                    fontSize: 15.sp(context),
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(width: context.width * 0.02),
                  CustomTextView(
                    text: spent < 0 ? context.tr('savedKey') : context.tr('usedKey'),
                    fontSize: 15.sp(context),
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: .spaceBetween,
                crossAxisAlignment: .start,
                children: [
                  Expanded(
                    child: CustomTextView(
                      // text: '4353635354353435344343434343434343434334434344334344334',
                      text: '${context.symbol}${left.formatAmt()}',
                      fontSize: 16.sp(context),
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: context.width * 0.02),
                  Expanded(
                    child: CustomTextView(
                      text: '${context.symbol}${spent.abs().formatAmt()}',

                      fontSize: 16.sp(context),
                      fontWeight: FontWeight.bold,
                      // color: healthColor,
                      color: Colors.black,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorSCheme.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                widthFactor: (percent / 100).clamp(0.0, 1.0),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: colorSCheme.primary,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: colorSCheme.primary.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colorSCheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: CustomTextView(
                  text: '${percent.clamp(0, 100).toInt()}%',
                  fontSize: 11.sp(context),
                  fontWeight: FontWeight.bold,
                  color: colorSCheme.primary,
                ),
              ),
              SizedBox(width: context.width * 0.02),
              Expanded(
                child: CustomTextView(
                  text: '${context.tr('limitKey')}: ${context.symbol}${limit.formatAmt()}',
                  fontSize: 12.sp(context),
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (isPast) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Banner(
          location: BannerLocation.topEnd,
          message: context.tr('endedKey').toUpperCase(),
          color: colorSCheme.primary,
          child: cardContent,
        ),
      );
    }
    return cardContent;
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.more_horiz, color: Colors.black, size: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onSelected: (value) {
        if (value == context.tr('editKey')) {
          Navigator.pushNamed(context, Routes.addBudget, arguments: {'item': budget, 'isEdit': true});
        } else if (value == context.tr('deleteKey')) {
          showDeleteAlertDialog(context: context, budget: budget);
        }
      },
      itemBuilder: (context) => [
        _popUpMenuBuild(value: context.tr('editKey'), text: context.tr('editKey'), icon: Icons.edit_rounded, color: Colors.black, context: context),
        _popUpMenuBuild(value: context.tr('deleteKey'), text: context.tr('deleteKey'), icon: Icons.delete_outline_rounded, color: Colors.red, context: context),
      ],
    );
  }
}

PopupMenuItem<String> _popUpMenuBuild({required BuildContext context, required String value, required String text, required IconData icon, required Color color}) {
  return PopupMenuItem(
    value: value,
    child: Row(
      children: [
        Expanded(
          child: CustomTextView(text: text, fontSize: 15.sp(context)),
        ),
        Icon(icon, size: 18.sp(context), color: color),
      ],
    ),
  );
}

void showDeleteAlertDialog({required Budget budget, required BuildContext context}) {
  context.showAppDialog(
    child: BlocProvider(
      create: (context) => DeleteBudgetCubit(),
      child: Builder(
        builder: (dialogueContext) {
          return Center(
            child: PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;
                if (dialogueContext.read<DeleteBudgetCubit>().state is! DeleteBudgetLoading) {
                  Navigator.of(dialogueContext).pop();
                  return;
                }
              },
              child: AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: CustomTextView(
                  text: context.tr('deleteAccountTitleKey'),
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp(context),
                ),
                content: CustomTextView(text: context.tr('budgetDeleteDialogMsg'), maxLines: 3, fontSize: 15.sp(context)),
                actions: [
                  BlocConsumer<DeleteBudgetCubit, DeleteBudgetState>(
                    listener: (context, state) {
                      if (state is DeleteBudgetSuccess) {
                        context.read<GetBudgetCubit>().deleteBudgetLocally(state.budget);
                        Navigator.pop(context);
                      }
                      if (state is DeleteBudgetFailure) {
                        UiUtils.showCustomSnackBar(context: context, errorMessage: state.error);
                        Navigator.pop(context);
                      }
                    },
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: CustomRoundedButton(
                              onPressed: () {
                                if (state is! DeleteBudgetLoading) {
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
                                context.read<DeleteBudgetCubit>().deleteBudget(budget);
                              },
                              isLoading: state is DeleteBudgetLoading,
                              width: 1,
                              backgroundColor: Theme.of(context).primaryColor,
                              text: context.tr('deleteAccountConfirmKey'),
                              borderRadius: BorderRadius.circular(8),
                              height: 45.sp(context),
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
