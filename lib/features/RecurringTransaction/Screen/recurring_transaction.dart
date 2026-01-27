import 'dart:ui';

import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/RecurringTransaction/Cubit/get_recurring_transaction_cubit.dart';
import 'package:expenseapp/features/RecurringTransaction/Cubit/update_recurring_transaction_cubit.dart';
import 'package:expenseapp/features/RecurringTransaction/Enums/RecurringFrequency.dart';
import 'package:expenseapp/features/RecurringTransaction/Enums/RecurringTransactionStatus.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Recurring.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/RecurringTransaction.dart';
import 'package:expenseapp/utils/extensions/localization_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecurringTransactionScreen extends StatefulWidget {
  RecurringTransactionScreen({super.key, this.transaction});

  Recurring? transaction;

  static Route<dynamic>? route(RouteSettings routeSettings) {
    final args = routeSettings.arguments as Map<String, dynamic>?;

    final transaction = args?['transaction'] as Recurring?;
    // final transaction = Recurring(
    //   recurringId: 'RT_2026-01-24_15-05-45_1769247345183_0JA)49',
    //   title: 'hy',
    //   frequency: RecurringFrequency.daily,
    //   startDate: '20.01.2026',
    //   endDate: '25.01.2026',
    //   amount: 80,
    //   accountId: '-1',
    //   categoryId: 'C_2026-01-19_14-14-17_1768812257209_YBALM7',
    //   type: TransactionType.EXPENSE,
    //   recurringTransactions: [
    //     RecurringTransaction(
    //       recurringTransactionId: 'RT_2026-01-24_15-05-45_1769247345247_2/XCPR1',
    //       transactionId: 'TR_2026-01-24_15-05-45_1769247345247_BRFLXC1',
    //       recurringId: 'RT_2026-01-24_15-05-45_1769247345183_0JA)49',
    //       scheduleDate: '21.01.2026',
    //       status: RecurringTransactionStatus.CANCELLED,
    //     ),
    //     RecurringTransaction(
    //       recurringTransactionId: 'RT_2026-01-24_15-05-45_1769247345247_2/XCPR',
    //       transactionId: 'TR_2026-01-24_15-05-45_1769247345247_BRFLXC',
    //       recurringId: 'RT_2026-01-24_15-05-45_1769247345183_0JA)49',
    //       scheduleDate: '22.01.2026',
    //       status: RecurringTransactionStatus.CANCELLED,
    //     ),
    //     RecurringTransaction(
    //       recurringTransactionId: 'RT_2026-01-24_15-05-45_1769247345248_408OA8',
    //       transactionId: 'TR_2026-01-24_15-05-45_1769247345248_^5XR54',
    //       recurringId: 'RT_2026-01-24_15-05-45_1769247345183_0JA)49',
    //       scheduleDate: '23.01.2026',
    //       status: RecurringTransactionStatus.CANCELLED,
    //     ),
    //     RecurringTransaction(
    //       recurringTransactionId: 'RT_2026-01-24_15-05-45_1769247345248_*LULT/',
    //       transactionId: 'TR_2026-01-24_15-05-45_1769247345248_FUIR9%',
    //       recurringId: 'RT_2026-01-24_15-05-45_1769247345183_0JA)49',
    //       scheduleDate: '24.01.2026',
    //       status: RecurringTransactionStatus.UPCOMING,
    //     ),
    //     RecurringTransaction(
    //       recurringTransactionId: 'RT_2026-01-24_15-05-45_1769247345248_M6UNWA',
    //       transactionId: 'TR_2026-01-24_15-05-45_1769247345248_(FDCLV',
    //       recurringId: 'RT_2026-01-24_15-05-45_1769247345183_0JA)49',
    //       scheduleDate: '25.01.2026',
    //       status: RecurringTransactionStatus.UPCOMING,
    //     ),
    //   ],
    // );

    return CupertinoPageRoute(
      builder: (_) => RecurringTransactionScreen(transaction: transaction),
    );
  }

  @override
  State<RecurringTransactionScreen> createState() => _RecurringTransactionState();
}

class _RecurringTransactionState extends State<RecurringTransactionScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetRecurringTransactionCubit>().getRecurringTransactionData(recurringId: widget.transaction!.recurringId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: CustomTextView(text: context.tr('transactionlogKey'), fontSize: 20.sp(context), color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: ResponsivePadding(
          topPadding: context.height * 0.01,
          bottomPadding: context.height * 0.03,
          leftPadding: context.width * 0.04,
          rightPadding: context.width * 0.04,
          child: Column(
            children: [
              _SubscriptionSummary(recurring: widget.transaction!),
              SizedBox(height: context.height * 0.01),
              _TransactionLog(recurring: widget.transaction),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubscriptionSummary extends StatelessWidget {
  const _SubscriptionSummary({required this.recurring, super.key});
  final Recurring recurring;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsetsDirectional.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextView(
            text: context.tr('amountLbl'),
            fontSize: 14.sp(context),
            color: colorScheme.surfaceDim,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: context.height * 0.01),
          CustomTextView(
            text: '${context.symbol} ${recurring.amount}',
            fontSize: 25.sp(context),
            fontWeight: FontWeight.w900,
          ),
          Divider(height: context.height * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextView(
                    text: '${UiUtils.getRecurringFrequencyString(recurring.frequency!)} ${context.tr('FrequencyKey')}',
                    fontSize: 15.sp(context),
                    color: colorScheme.surfaceDim.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: context.height * 0.01),
                  CustomTextView(
                    text: '${recurring.startDate} - ${recurring.endDate}',
                    fontSize: 14.sp(context),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransactionLog extends StatelessWidget {
  const _TransactionLog({required this.recurring, super.key});
  final Recurring? recurring;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextView(
              text: context.tr('transactionlogKey'),
              fontSize: 18.sp(context),
              fontWeight: FontWeight.bold,
            ),
            CustomTextView(
              text: '${recurring!.recurringTransactions!.length} ${context.tr('totalKey')}',
              fontSize: 12.sp(context),
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        SizedBox(height: context.height * 0.01),

        BlocBuilder<GetRecurringTransactionCubit, GetRecurringTransactionState>(
          builder: (context, state) {
            return BlocBuilder<GetRecurringTransactionCubit, GetRecurringTransactionState>(
              builder: (context, state) {
                if (state is GetRecurringTransactionSuccess) {
                  final recurringTransactions = context.read<GetRecurringTransactionCubit>().getRecurringTransactionData(recurringId: recurring!.recurringId!);

                  if (recurringTransactions!.recurringTransactions!.isEmpty) {
                    return CustomErrorWidget(
                      errorMessage: context.tr('noDataFound'),
                      errorType: CustomErrorType.noDataFound,
                      onRetry: () {
                        //  context.read<GetRecurringTransactionCubit>().getRecurringTransactionData(recurringId: recurring!.recurringId!);
                      },
                    );
                  }
                  return ListView.builder(
                    itemCount: recurringTransactions.recurringTransactions!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final recurringData = recurringTransactions.recurringTransactions;

                      final recurringTransaction = recurringData![index];
                      final isPaid = recurringTransaction.status == RecurringTransactionStatus.PAID;
                      final isUpcoming = recurringTransaction.status == RecurringTransactionStatus.UPCOMING;
                      final isCancelled = recurringTransaction.status == RecurringTransactionStatus.CANCELLED;

                      final borderColor = isPaid
                          ? Colors.green
                          : isCancelled
                          ? Colors.red
                          : colorScheme.primary;

                      final iconColor = isPaid
                          ? Colors.green
                          : isCancelled
                          ? Colors.red
                          : colorScheme.primary;

                      final icon = isPaid
                          ? Icons.check_circle
                          : isCancelled
                          ? Icons.block
                          : Icons.upcoming;

                      final subtitle = isPaid
                          ? context.tr('paidKey')
                          : isCancelled
                          ? context.tr('cancelKey')
                          : context.tr('upcomingKey');

                      log('scheduleDate ${recurringTransaction.scheduleDate}');

                      final date = UiUtils.parseDate(recurringTransaction.scheduleDate ?? '');

                      return Container(
                        margin: const EdgeInsetsDirectional.only(bottom: 12),
                        padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.04, vertical: context.height * 0.02),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border(left: BorderSide(color: borderColor, width: 4)),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: iconColor.withOpacity(0.1),
                              child: Icon(icon, color: iconColor),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextView(
                                    text: recurringTransaction.scheduleDate!,
                                    //text: recurringTransaction.transactionId ?? '',
                                    fontSize: 14.sp(context),
                                    fontWeight: FontWeight.w600,
                                    softWrap: true,
                                    maxLines: 3,
                                  ),
                                  SizedBox(height: context.height * 0.003),
                                  CustomTextView(
                                    text: subtitle,
                                    fontSize: 13.sp(context),
                                    color: colorScheme.surfaceDim,
                                  ),
                                ],
                              ),
                            ),

                            if (isPaid) ...[
                              if (date.isToday || date.isPast) ...[
                                PopupMenuButton(
                                  itemBuilder: (context) {
                                    final items = <PopupMenuEntry<String>>[
                                      _buildPopupMenu(value: context.tr('cancelKey'), text: context.tr('cancelKey'), color: Colors.red),
                                    ];
                                    return items;
                                  },
                                  onSelected: (value) {
                                    showChangeStatusDialog(context, transaction: recurring, isCancelled: true, recurringTransaction: recurringTransaction);
                                  },
                                ),
                              ] else if (date.isFuture) ...[
                                PopupMenuButton(
                                  itemBuilder: (context) {
                                    final items = <PopupMenuEntry<String>>[
                                      _buildPopupMenu(
                                        value: context.tr('cancelKey'),
                                        text: context.tr('cancelKey'),
                                        color: Colors.red,
                                      ),
                                      _buildPopupMenu(value: context.tr('upcomingKey'), text: context.tr('upcomingKey'), color: colorScheme.primary),
                                    ];

                                    return items;
                                  },
                                  onSelected: (value) {
                                    if (value == context.tr('upcomingKey')) {
                                      showChangeStatusDialog(context, transaction: recurring, isUpcoming: true, recurringTransaction: recurringTransaction);
                                    }
                                    if (value == context.tr('cancelKey')) {
                                      showChangeStatusDialog(context, transaction: recurring, isCancelled: true, recurringTransaction: recurringTransaction);
                                    }
                                  },
                                ),
                              ],
                            ],
                            if (isCancelled) ...[
                              if (date.isToday || date.isPast) ...[
                                PopupMenuButton(
                                  itemBuilder: (context) {
                                    final items = <PopupMenuEntry<String>>[
                                      _buildPopupMenu(value: context.tr('paidKey'), text: context.tr('paidKey'), color: Colors.green),
                                    ];

                                    return items;
                                  },
                                  onSelected: (value) {
                                    showChangeStatusDialog(context, transaction: recurring, isPaid: true, recurringTransaction: recurringTransaction);
                                  },
                                ),
                              ] else if (date.isFuture) ...[
                                PopupMenuButton(
                                  itemBuilder: (context) {
                                    final items = <PopupMenuEntry<String>>[
                                      _buildPopupMenu(value: context.tr('paidKey'), text: context.tr('paidKey'), color: Colors.green),
                                      _buildPopupMenu(value: context.tr('upcomingKey'), text: context.tr('upcomingKey'), color: colorScheme.primary),
                                    ];

                                    return items;
                                  },
                                  onSelected: (value) {
                                    if (value == context.tr('paidKey')) {
                                      showChangeStatusDialog(context, transaction: recurring, isPaid: true, recurringTransaction: recurringTransaction);
                                    }
                                    if (value == context.tr('upcomingKey')) {
                                      showChangeStatusDialog(context, transaction: recurring, isUpcoming: true, recurringTransaction: recurringTransaction);
                                    }
                                  },
                                ),
                              ],
                            ],
                            if (isUpcoming) ...[
                              PopupMenuButton(
                                itemBuilder: (context) {
                                  final items = <PopupMenuEntry<String>>[
                                    _buildPopupMenu(value: context.tr('paidKey'), text: context.tr('paidKey'), color: Colors.red),
                                    _buildPopupMenu(value: context.tr('cancelKey'), text: context.tr('cancelKey'), color: colorScheme.primary),
                                  ];

                                  return items;
                                },
                                onSelected: (value) {
                                  if (value == context.tr('paidKey')) {
                                    showChangeStatusDialog(context, transaction: recurring, isPaid: true, recurringTransaction: recurringTransaction);
                                  }
                                  if (value == context.tr('cancelKey')) {
                                    showChangeStatusDialog(context, transaction: recurring, isCancelled: true, recurringTransaction: recurringTransaction);
                                  }
                                },
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  );
                } else if (state is GetRecurringTransactionFailure) {
                  return CustomErrorWidget(
                    errorMessage: state.message,
                    onRetry: () {
                      context.read<GetAccountCubit>().getAccount();
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            );
          },
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupMenu({required String value, required String text, Color? color}) {
    return PopupMenuItem(
      value: value,
      child: Text(
        text,
        style: TextStyle(color: color),
      ),
    );
  }
}

Future<void> showChangeStatusDialog(
  BuildContext context, {
  Recurring? transaction,
  bool isPaid = false,
  bool isUpcoming = false,
  bool isCancelled = false,
  RecurringTransaction? recurringTransaction,
}) async {
  final colorScheme = Theme.of(context).colorScheme;
  final iconBgColor = isPaid
      ? Colors.green.withValues(alpha: 0.2)
      : isCancelled
      ? Colors.red.withValues(alpha: 0.2)
      : colorScheme.primary.withValues(alpha: 0.2);

  final iconColor = isPaid
      ? Colors.green
      : isCancelled
      ? Colors.red
      : colorScheme.primary;

  final icon = isPaid
      ? Icons.check_circle
      : isCancelled
      ? Icons.block
      : Icons.upcoming;

  final title = isPaid
      ? context.tr('paidKey')
      : isCancelled
      ? context.tr('cancelKey')
      : context.tr('upcomingKey');

  final status = isPaid
      ? RecurringTransactionStatus.PAID
      : isUpcoming
      ? RecurringTransactionStatus.UPCOMING
      : RecurringTransactionStatus.CANCELLED;

  await showGeneralDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: .3),
    transitionDuration: const Duration(milliseconds: 300),

    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return Transform.scale(
        scale: Curves.easeOutBack.transform(animation.value),
        child: Opacity(opacity: animation.value, child: child),
      );
    },

    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            if (context.read<UpdateRecurringTransactionCubit>().state is! UpdateRecurringTransactionLoading) {
              Navigator.of(context).pop();
              return;
            }
          },

          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              // contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              content: BlocConsumer<UpdateRecurringTransactionCubit, UpdateRecurringTransactionState>(
                listener: (context, state) {
                  if (state is UpdateRecurringTransactionSuccess) {
                    context.read<GetRecurringTransactionCubit>().updateRecurringTransactionByStatus(
                      transaction: state.transaction!,

                      recurringTransactionId: state.recurringTransactionId!,
                      status: state.status!,
                      transactionId: state.transactionId!,
                    );
                    Navigator.of(context).pop();
                  }
                  if (state is UpdateRecurringTransactionFailure) {
                    UiUtils.showCustomSnackBar(context: context, errorMessage: state.errorMessage);
                  }
                },
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundColor: iconBgColor,
                        child: Icon(icon, color: iconColor, size: 28),
                      ),

                      SizedBox(height: context.height * 0.018),

                      // Title
                      CustomTextView(
                        text: context.tr('confirmStatusKey'),
                        fontSize: 20.sp(context),
                        fontWeight: FontWeight.bold,
                      ),

                      SizedBox(height: context.height * 0.01),

                      CustomTextView(
                        text: 'confirmTransactionKey'.tr(context, namedArgs: {'date': recurringTransaction!.scheduleDate!, 'title': title}),
                        textAlign: TextAlign.center,
                        fontSize: 16.sp(context),
                        color: Colors.black,
                        softWrap: true,
                        maxLines: 3,
                      ),

                      SizedBox(height: context.height * 0.02),
                      CustomRoundedButton(
                        height: context.isTablet ? context.height * 0.04 : context.height * 0.05,
                        backgroundColor: colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                        textStyle: TextStyle(fontSize: 15.sp(context)),
                        text: context.tr('ConfirmKey'),
                        isLoading: state is UpdateRecurringTransactionLoading,
                        onPressed: () {
                          context.read<UpdateRecurringTransactionCubit>().changeRecurringTransactionStatus(
                            recurringTransactionId: recurringTransaction.recurringTransactionId!,
                            status: status,
                            transaction: transaction!,
                            transactionId: recurringTransaction.transactionId ?? '',
                          );
                        },
                      ),

                      SizedBox(height: context.height * 0.01),

                      CustomRoundedButton(
                        height: context.isTablet ? context.height * 0.04 : context.height * 0.05,
                        backgroundColor: colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                        textStyle: TextStyle(fontSize: 15.sp(context)),
                        text: context.tr('cancelKey'),
                        onPressed: () {
                          if (state is! UpdateRecurringTransactionLoading) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
    },
  );
}
