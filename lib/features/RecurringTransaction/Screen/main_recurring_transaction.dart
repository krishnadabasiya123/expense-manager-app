import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/RecurringTransaction/Cubit/delete_recurring_transaction_cubit.dart';
import 'package:expenseapp/features/RecurringTransaction/Cubit/get_recurring_transaction_cubit.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Enums/RecurringFrequency.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Enums/RecurringTransactionStatus.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Recurring.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/RecurringTransaction.dart';
import 'package:expenseapp/features/RecurringTransaction/Screen/edit_recurring_screen.dart';
import 'package:expenseapp/features/RecurringTransaction/Widget/delete_recurring_dialogue.dart';
import 'package:flutter/material.dart';

class RecurringTransactionList extends StatefulWidget {
  const RecurringTransactionList({super.key});

  @override
  State<RecurringTransactionList> createState() => _RecurringTransactionListState();
}

class _RecurringTransactionListState extends State<RecurringTransactionList> {
  @override
  void initState() {
    log('initState');
    super.initState();
    // context.read<GetRecurringTransactionCubit>().fetchRecurringTransaction();
  }

  String? getNextPayDate(List<RecurringTransaction> transactions) {
    final allPaid =
        transactions.isNotEmpty &&
        transactions.every(
          (e) => e.status == RecurringTransactionStatus.PAID || e.status == RecurringTransactionStatus.CANCELLED,
        );

    if (allPaid) {
      return context.tr('endedKey');
    }

    final upcoming = transactions.where((e) => e.status == RecurringTransactionStatus.UPCOMING).toList();

    final ifCancel = transactions.where((e) => e.status == RecurringTransactionStatus.CANCELLED).toList();

    if (upcoming.isEmpty) return null;

    upcoming.sort((a, b) => UiUtils.parseDate(a.scheduleDate).compareTo(UiUtils.parseDate(b.scheduleDate)));
    ifCancel.sort((a, b) => UiUtils.parseDate(a.scheduleDate).compareTo(UiUtils.parseDate(b.scheduleDate)));

    if (upcoming.isNotEmpty) {
      return upcoming.first.scheduleDate;
    }

    if (ifCancel.isNotEmpty) {
      return ifCancel.first.scheduleDate;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QAppBar(
        title: CustomTextView(text: context.tr('recurringKey'), fontSize: 20.sp(context), color: Colors.white),
      ),
      body: BlocConsumer<GetRecurringTransactionCubit, GetRecurringTransactionState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GetRecurringTransactionFailure) {
            return CustomErrorWidget(
              errorMessage: context.tr('dataNotFound'),
              onRetry: () {
                context.read<GetRecurringTransactionCubit>().fetchRecurringTransaction();
              },
            );
          }
          if (state is GetRecurringTransactionSuccess) {
            // final transaction = recurringList;

            final transaction = state.transactions;

            if (transaction.isEmpty) {
              return NoDataFoundScreen(title: context.tr('noRecurringDataFound'));
            }
            return ResponsivePadding(
              topPadding: context.height * 0.01,
              bottomPadding: context.width * 0.03,
              leftPadding: context.width * 0.05,
              rightPadding: context.width * 0.05,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: transaction.length,
                itemBuilder: (context, index) {
                  final item = transaction[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.recurringTransaction, arguments: {'transaction': item});
                    },
                    child: RecurringCard(
                      icon: item.type.icon,
                      iconBg: item.type.color!.withValues(alpha: 0.08),
                      iconColor: item.type.color,
                      title: item.title,
                      amount: item.amount.toString(),
                      frequency: item.frequency,
                      start: item.startDate,
                      end: item.endDate,
                      type: item.type,
                      nextPay: getNextPayDate(item.recurringTransactions),
                      recurring: item,
                    ),
                  );
                },
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class RecurringCard extends StatelessWidget {
  RecurringCard({
    this.icon,
    this.iconBg,
    this.iconColor,
    this.title,
    this.amount,
    this.frequency,
    this.start,
    this.nextPay,
    this.end,
    this.type,
    this.recurring,
    super.key,
  });
  IconData? icon;
  Color? iconBg;
  Color? iconColor;
  String? title;
  String? amount;
  RecurringFrequency? frequency;
  String? start;
  String? nextPay;
  String? end;
  TransactionType? type;
  Recurring? recurring;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.all(16),
      margin: EdgeInsetsDirectional.only(bottom: context.height * 0.01),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 40.sp(context),
                width: 40.sp(context),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor),
              ),
              SizedBox(width: context.width * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title!.isNotEmpty) ...[
                      CustomTextView(
                        text: title!,
                        fontSize: 17.sp(context),
                        fontWeight: FontWeight.bold,
                        softWrap: true,
                        maxLines: 3,
                      ),
                    ],
                    // Text(title!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    // const SizedBox(height: 4),
                    SizedBox(height: context.height * 0.002),
                    CustomTextView(
                      text: amount!,
                      fontSize: 14.sp(context),
                      color: type!.color,
                    ),

                    //Text(amount!, style: const TextStyle(color: context.colorScheme.expenseColor, fontSize: 12)),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.03, vertical: context.height * 0.004),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomTextView(text: UiUtils.getRecurringFrequencyString(frequency!), fontSize: 12.sp(context), fontWeight: FontWeight.bold),
                      ),
                      PopupMenuButton(
                        itemBuilder: (context) {
                          final items = <PopupMenuEntry<String>>[
                            _buildPopupMenu(
                              value: context.tr('editKey'),
                              text: context.tr('editKey'),
                            ),
                            _buildPopupMenu(
                              value: context.tr('deleteKey'),
                              text: context.tr('deleteKey'),
                            ),
                          ];
                          return items;
                        },
                        onSelected: (value) async {
                          if (value == context.tr('editKey')) {
                            Navigator.of(context).pushNamed(Routes.editMainRecurringTransaction, arguments: {'recurringId': recurring!.recurringId});
                          }
                          if (value == context.tr('deleteKey')) {
                            showDeleteRecurringDialogue(context, recurringId: recurring!.recurringId);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          //const Divider(height: 24),
          Divider(height: context.height * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _info(context, context.tr('startKey'), start),
              _info(context, context.tr('nextPayKey'), nextPay, highlight: nextPay == context.tr('endedKey')),
              _info(context, context.tr('endsKey'), end, alignEnd: true),
            ],
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenu({required String value, required String text}) {
    return PopupMenuItem(
      value: value,
      child: Text(
        text,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}

Widget _info(BuildContext context, String label, String? value, {bool highlight = false, bool alignEnd = false}) {
  return Column(
    crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    children: [
      CustomTextView(text: label.toUpperCase(), fontSize: 11.sp(context), fontWeight: FontWeight.bold, color: Colors.grey),
      SizedBox(height: context.height * 0.004),
      CustomTextView(
        text: value ?? '',
        fontSize: 12.sp(context),
        color: highlight ? Colors.orange : Colors.black,
        fontWeight: FontWeight.w500,
      ),
    ],
  );
}

// void showDeleteRecurringDialogue(BuildContext context, {required Recurring recurring}) {
//   final isCheck = ValueNotifier<bool>(false);

//   context.showAppDialog(
//     child: BlocProvider(
//       create: (context) => DeleteRecurringTransactionCubit(),
//       child: Builder(
//         builder: (dialogContext) {
//           return ValueListenableBuilder(
//             valueListenable: isCheck,
//             builder: (context, value, child) {
//               return Center(
//                 child: PopScope(
//                   canPop: false,
//                   onPopInvokedWithResult: (didPop, result) {
//                     if (didPop) return;
//                     if (dialogContext.read<DeleteRecurringTransactionCubit>().state is! DeleteRecurringTransactionLoading) {
//                       Navigator.of(dialogContext).pop();
//                       return;
//                     }
//                   },
//                   child: AlertDialog(
//                     actions: [
//                       Center(
//                         child: Container(
//                           child: ValueListenableBuilder(
//                             valueListenable: isCheck,
//                             builder: (context, value, child) {
//                               return Column(
//                                 //   mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   /// Delete Icon
//                                   SizedBox(height: context.height * 0.03),

//                                   /// Title
//                                   // Text(
//                                   //   'Confirm Deletion',
//                                   //   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                                   //     fontWeight: FontWeight.bold,
//                                   //   ),
//                                   // ),
//                                   CustomTextView(text: context.tr('deleteAccountTitleKey'), fontWeight: FontWeight.bold, fontSize: 20.sp(context)),

//                                   SizedBox(height: context.height * 0.01),
//                                   CustomTextView(
//                                     text: context.tr('recurringDialogueMsg'),
//                                     softWrap: true,
//                                     maxLines: 3,
//                                     textAlign: TextAlign.center,
//                                     color: Colors.grey,
//                                   ),

//                                   /// Description
//                                   // Text(
//                                   //   'Deleting this recurring will permanently remove all related transactions from your records.',
//                                   //   textAlign: TextAlign.center,
//                                   //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
//                                   // ),
//                                   SizedBox(height: context.height * 0.02),

//                                   /// Checkbox container
//                                   Container(
//                                     padding: EdgeInsetsDirectional.symmetric(vertical: context.height * 0.01, horizontal: context.width * 0.04),
//                                     decoration: BoxDecoration(
//                                       color: const Color(0xFFF1F5F9),
//                                       borderRadius: BorderRadius.circular(20),
//                                       border: Border.all(
//                                         color: Colors.grey.shade200,
//                                       ),
//                                     ),
//                                     child: Row(
//                                       children: [
//                                         Checkbox(
//                                           value: isCheck.value,
//                                           activeColor: Colors.blue.shade800,
//                                           onChanged: (value) {
//                                             isCheck.value = value!;
//                                           },
//                                         ),
//                                         SizedBox(width: context.width * 0.02),
//                                         Expanded(
//                                           child: CustomTextView(
//                                             text: context.tr('keepAsNormalTransactionKey'),
//                                             fontSize: 15.sp(context),
//                                             color: Colors.black,
//                                             softWrap: true,
//                                             maxLines: 2,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),

//                                   SizedBox(height: context.height * 0.02),

//                                   /// Buttons
//                                   BlocConsumer<DeleteRecurringTransactionCubit, DeleteRecurringTransactionState>(
//                                     listener: (context, state) {
//                                       if (state is DeleteRecurringTransactionSuccess) {
//                                         context.read<GetRecurringTransactionCubit>().deleteRecurringTransactionLocally(recurringId: recurring.recurringId);
//                                         Navigator.pop(context);
//                                         if (isCheck.value) {
//                                           context.read<GetTransactionCubit>().setNullRecurringTransactionId(recurringId: recurring.recurringId);
//                                         } else {
//                                           context.read<GetTransactionCubit>().permanentlyDeleteRecurringTransaction(recurringId: recurring.recurringId);
//                                         }
//                                       }
//                                     },
//                                     builder: (context, state) {
//                                       return Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                         children: [
//                                           Expanded(
//                                             child: ElevatedButton(
//                                               style: ElevatedButton.styleFrom(
//                                                 backgroundColor: Theme.of(context).primaryColor,
//                                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                                                 //  padding: const EdgeInsetsDirectional.symmetric(vertical: 14),
//                                               ),
//                                               onPressed: () {
//                                                 if (state is! DeleteRecurringTransactionLoading) {
//                                                   Navigator.of(context).pop();
//                                                 }
//                                               },

//                                               child: CustomTextView(text: context.tr('deleteAccountCancelKey'), fontSize: 15.sp(context), color: Colors.white, textAlign: TextAlign.center),
//                                             ),
//                                           ),
//                                           const SizedBox(width: 15),
//                                           Expanded(
//                                             child: ElevatedButton(
//                                               style: ElevatedButton.styleFrom(
//                                                 backgroundColor: Theme.of(context).primaryColor,
//                                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                                                 //padding: const EdgeInsetsDirectional.symmetric(vertical: 14),
//                                               ),
//                                               onPressed: state is DeleteRecurringTransactionLoading
//                                                   ? null
//                                                   : () async {
//                                                       await context.read<DeleteRecurringTransactionCubit>().deleteRecurringTransaction(recurring);
//                                                     },
//                                               child: state is DeleteRecurringTransactionLoading
//                                                   ? const CustomCircularProgressIndicator(
//                                                       color: Colors.white,
//                                                     )
//                                                   : CustomTextView(text: context.tr('deleteAccountConfirmKey'), fontSize: 15.sp(context), color: Colors.white, textAlign: TextAlign.center),
//                                             ),
//                                           ),
//                                         ],
//                                       );
//                                     },
//                                   ),
//                                 ],
//                               );
//                             },
//                           ),
//                         ),
//                         // child: AlertDialog(
//                         //   constraints: const BoxConstraints(),
//                         //   //constraints: BoxConstraints(maxHeight: size.height * 0.45, maxWidth: size.width * 0.85),
//                         //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                         //   title: CustomTextView(text: context.tr('deleteAccountTitleKey'), fontWeight: FontWeight.bold, fontSize: 20.sp(context)),
//                         //   content: CustomTextView(text: context.tr('recurringDialogueMsg'), softWrap: true, maxLines: 3),
//                         //   actions: [
//                         //     Row(
//                         //       children: [
//                         //         Checkbox(
//                         //           value: isCheck.value,
//                         //           checkColor: const Color.fromARGB(255, 255, 255, 255),
//                         //           fillColor: WidgetStateProperty.resolveWith((states) {
//                         //             if (states.contains(WidgetState.selected)) {
//                         //               return Colors.black;
//                         //             }
//                         //             return null;
//                         //           }),

//                         //           onChanged: (value) {
//                         //             isCheck.value = value!;
//                         //           },
//                         //         ),
//                         //         CustomTextView(text: context.tr('keepAsNormalTransactionKey'), fontSize: 15.sp(context), color: Colors.black, softWrap: true, maxLines: 3),
//                         //       ],
//                         //     ),
//                         //     BlocConsumer<DeleteRecurringTransactionCubit, DeleteRecurringTransactionState>(
//                         //       listener: (context, state) {
//                         //         if (state is DeleteRecurringTransactionSuccess) {
//                         //           context.read<GetRecurringTransactionCubit>().deleteRecurringTransactionLocally(recurringId: recurring.recurringId);
//                         //           Navigator.pop(context);
//                         //           if (isCheck.value) {
//                         //             context.read<GetTransactionCubit>().setNullRecurringTransactionId(recurringId: recurring.recurringId);
//                         //           } else {
//                         //             context.read<GetTransactionCubit>().permanentlyDeleteRecurringTransaction(recurringId: recurring.recurringId);
//                         //           }
//                         //         }
//                         //       },
//                         //       builder: (context, state) {
//                         //         return Row(
//                         //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         //           children: [
//                         //             Expanded(
//                         //               child: ElevatedButton(
//                         //                 style: ElevatedButton.styleFrom(
//                         //                   backgroundColor: Theme.of(context).primaryColor,
//                         //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                         //                   //  padding: const EdgeInsetsDirectional.symmetric(vertical: 14),
//                         //                 ),
//                         //                 onPressed: () {
//                         //                   if (state is! DeleteRecurringTransactionLoading) {
//                         //                     Navigator.of(context).pop();
//                         //                   }
//                         //                 },

//                         //                 child: CustomTextView(text: context.tr('deleteAccountCancelKey'), fontSize: 15.sp(context), color: Colors.white, textAlign: TextAlign.center),
//                         //               ),
//                         //             ),
//                         //             const SizedBox(width: 15),
//                         //             Expanded(
//                         //               child: ElevatedButton(
//                         //                 style: ElevatedButton.styleFrom(
//                         //                   backgroundColor: Theme.of(context).primaryColor,
//                         //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                         //                   //padding: const EdgeInsetsDirectional.symmetric(vertical: 14),
//                         //                 ),
//                         //                 onPressed: state is DeleteRecurringTransactionLoading
//                         //                     ? null
//                         //                     : () async {
//                         //                         await context.read<DeleteRecurringTransactionCubit>().deleteRecurringTransaction(recurring);
//                         //                       },
//                         //                 child: state is DeleteRecurringTransactionLoading
//                         //                     ? const CustomCircularProgressIndicator(
//                         //                         color: Colors.white,
//                         //                       )
//                         //                     : CustomTextView(text: context.tr('deleteAccountConfirmKey'), fontSize: 15.sp(context), color: Colors.white, textAlign: TextAlign.center),
//                         //               ),
//                         //             ),
//                         //           ],
//                         //         );
//                         //       },
//                         //     ),
//                         //   ],
//                         // ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     ),
//   );
// }
