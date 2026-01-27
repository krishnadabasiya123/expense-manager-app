import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/RecurringTransaction/Cubit/get_recurring_transaction_cubit.dart';
import 'package:expenseapp/features/RecurringTransaction/Enums/RecurringFrequency.dart';
import 'package:expenseapp/features/RecurringTransaction/Enums/RecurringTransactionStatus.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Recurring.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/RecurringTransaction.dart';
import 'package:expenseapp/features/RecurringTransaction/Screen/edit_recurring_dialogue.dart';
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
          (e) => e.status == RecurringTransactionStatus.PAID,
        );

    if (allPaid) {
      return context.tr('endedKey');
    }

    final upcoming = transactions.where((e) => e.status == RecurringTransactionStatus.UPCOMING).toList();

    if (upcoming.isEmpty) return null;

    upcoming.sort((a, b) => UiUtils.parseDate(a.scheduleDate!).compareTo(UiUtils.parseDate(b.scheduleDate!)));

    return upcoming.first.scheduleDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
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
              leftPadding: context.width * 0.03,
              rightPadding: context.width * 0.03,
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
                      icon: item.type == TransactionType.EXPENSE ? Icons.arrow_upward : Icons.arrow_downward,
                      iconBg: item.type == TransactionType.EXPENSE ? Colors.red.withValues(alpha: 0.15) : Colors.green.withValues(alpha: 0.15),
                      iconColor: item.type == TransactionType.EXPENSE ? Colors.red : Colors.green,
                      title: item.title,
                      amount: item.amount!.toString(),
                      frequency: item.frequency,
                      start: item.startDate,
                      end: item.endDate,
                      type: item.type,
                      nextPay: getNextPayDate(item.recurringTransactions!),
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
                      color: type == TransactionType.EXPENSE ? Colors.red : Colors.green,
                    ),

                    //Text(amount!, style: const TextStyle(color: Colors.red, fontSize: 12)),
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
                            Navigator.of(context).pushNamed(Routes.editMainRecurringTransaction, arguments: {'recurring': recurring});

                            //showEditRecurringDialogue(context, recurring: recurring);
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

// class _UpcomingTile extends StatelessWidget {
//   const _UpcomingTile({required this.date, this.recurring});
//   final DateTime date;
//   final Recurring? recurring;

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     return _BaseTile(
//       borderColor: colorScheme.primary,
//       icon: Icons.schedule,
//       iconColor: colorScheme.primary,
//       title: date,
//       subtitle: context.tr('upcomingTransactionKey'),
//       trailing: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         crossAxisAlignment: .end,
//         children: [
//           _buildPaidButton(
//             context,
//             onTap: () {
//               showChangeStatusDialog(context, transaction: recurring, isPaid: true);
//             },
//           ),
//           SizedBox(height: context.height * 0.003),
//           _buildCancelButton(
//             context,
//             onTap: () {
//               showChangeStatusDialog(context, transaction: recurring, isCancelled: true);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _PaidTile extends StatelessWidget {
//   const _PaidTile({required this.date, this.recurring});
//   final DateTime date;
//   final Recurring? recurring;

//   @override
//   Widget build(BuildContext context) {
//     return _BaseTile(
//       borderColor: Colors.green,
//       icon: Icons.check_circle,
//       iconColor: Colors.green,
//       title: date,
//       subtitle: context.tr('paidKey'),
//       trailing: (date.isToday || date.isPast)
//           ? _buildCancelButton(
//               context,
//               onTap: () {
//                 showChangeStatusDialog(context, transaction: recurring, isCancelled: true);
//               },
//             )
//           : (date.isFuture)
//           ? Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: .end,
//               children: [
//                 _buildUpcomingButton(
//                   context,
//                   onTap: () {
//                     showChangeStatusDialog(context, transaction: recurring, isUpcoming: true);
//                   },
//                 ),
//                 SizedBox(height: context.height * 0.003),
//                 _buildCancelButton(
//                   context,
//                   onTap: () {
//                     showChangeStatusDialog(context, transaction: recurring, isCancelled: true);
//                   },
//                 ),
//               ],
//             )
//           : const SizedBox(),
//     );
//   }
// }

// class _CancelledTile extends StatelessWidget {
//   const _CancelledTile({required this.date, this.recurring});
//   final DateTime date;
//   final Recurring? recurring;

//   @override
//   Widget build(BuildContext context) {
//     return _BaseTile(
//       borderColor: Colors.red,
//       icon: Icons.block,
//       iconColor: Colors.red,
//       title: date,
//       subtitle: context.tr('cancelledTransactionKey'),
//       trailing: (date.isToday || date.isPast)
//           ? _buildPaidButton(
//               context,
//               onTap: () {
//                 showChangeStatusDialog(context, transaction: recurring, isPaid: true);
//               },
//             )
//           : (date.isFuture)
//           ? Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: .end,

//               children: [
//                 _buildPaidButton(
//                   context,
//                   onTap: () {
//                     showChangeStatusDialog(context, transaction: recurring, isPaid: true);
//                   },
//                 ),
//                 SizedBox(height: context.height * 0.003),
//                 _buildUpcomingButton(
//                   context,
//                   onTap: () {
//                     showChangeStatusDialog(context, transaction: recurring, isUpcoming: true);
//                   },
//                 ),
//               ],
//             )
//           : const SizedBox(),
//     );
//   }
// }

// class _BaseTile extends StatelessWidget {
//   const _BaseTile({
//     required this.borderColor,
//     required this.icon,
//     required this.iconColor,
//     required this.title,
//     required this.subtitle,
//     required this.trailing,
//     this.strike = false,
//   });
//   final Color borderColor;
//   final IconData icon;
//   final Color iconColor;
//   final DateTime title;
//   final String subtitle;
//   final bool strike;
//   final Widget trailing;

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     return Container(
//       margin: const EdgeInsetsDirectional.only(bottom: 12),
//       padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.04, vertical: context.height * 0.02),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border(left: BorderSide(color: borderColor, width: 4)),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundColor: iconColor.withOpacity(0.1),
//             child: Icon(icon, color: iconColor),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CustomTextView(
//                   text: UiUtils.dateFormatter.format(title),
//                   fontSize: 14.sp(context),
//                   fontWeight: FontWeight.w600,
//                 ),
//                 SizedBox(height: context.height * 0.003),
//                 CustomTextView(
//                   text: subtitle,
//                   fontSize: 13.sp(context),
//                   color: colorScheme.surfaceDim,
//                   // subtitle,
//                   // style: const TextStyle(fontSize: 12, color: AppColors.muted),
//                 ),
//               ],
//             ),
//           ),
//           trailing,
//         ],
//       ),
//     );
//   }
// }

// Widget _buildCancelButton(BuildContext context, {required void Function()? onTap}) {
//   return GestureDetector(
//     onTap: onTap,
//     child: Container(
//       padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.02, vertical: context.height * 0.005),
//       decoration: BoxDecoration(
//         color: Colors.red.withValues(alpha: 0.2),
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: CustomTextView(text: context.tr('cancelKey'), fontSize: 10.sp(context), fontWeight: FontWeight.bold, color: Colors.red, letterspacing: 1),
//     ),
//   );
// }

// Widget _buildPaidButton(BuildContext context, {required void Function()? onTap}) {
//   return GestureDetector(
//     onTap: onTap,
//     child: Container(
//       padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.02, vertical: context.height * 0.005),
//       decoration: BoxDecoration(
//         color: Colors.green.withValues(alpha: 0.2),
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: CustomTextView(text: context.tr('paidKey'), fontSize: 10.sp(context), fontWeight: FontWeight.bold, color: Colors.green, letterspacing: 1),
//     ),
//   );
// }

// Widget _buildUpcomingButton(BuildContext context, {required void Function()? onTap}) {
//   final colorScheme = Theme.of(context).colorScheme;
//   return GestureDetector(
//     onTap: onTap,
//     child: Container(
//       padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.02, vertical: context.height * 0.005),
//       decoration: BoxDecoration(
//         color: colorScheme.primary.withValues(alpha: 0.2),
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: CustomTextView(text: context.tr('upcomingKey'), fontSize: 10.sp(context), fontWeight: FontWeight.bold, color: colorScheme.primary, letterspacing: 1),
//     ),
//   );
// }
