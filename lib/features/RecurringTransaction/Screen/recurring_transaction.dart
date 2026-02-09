import 'dart:ui';

import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/RecurringTransaction/Cubit/get_recurring_transaction_cubit.dart';
import 'package:expenseapp/features/RecurringTransaction/Cubit/update_recurring_transaction_cubit.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Enums/RecurringFrequency.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Enums/RecurringTransactionStatus.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Recurring.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/RecurringTransaction.dart';
import 'package:expenseapp/utils/extensions/localization_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecurringTransactionScreen extends StatefulWidget {
  RecurringTransactionScreen({required this.transaction, super.key});

  Recurring transaction;

  static Route<dynamic>? route(RouteSettings routeSettings) {
    final args = routeSettings.arguments as Map<String, dynamic>?;

    final transaction = args?['transaction'] as Recurring;

    return MaterialPageRoute(
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
    context.read<GetRecurringTransactionCubit>().getRecurringTransactionData(recurringId: widget.transaction.recurringId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QAppBar(
        title: CustomTextView(text: context.tr('transactionlogKey'), fontSize: 20.sp(context), color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: ResponsivePadding(
          topPadding: context.height * 0.01,
          bottomPadding: context.height * 0.03,
          leftPadding: context.width * 0.05,
          rightPadding: context.width * 0.05,
          child: Column(
            children: [
              _SubscriptionSummary(recurring: widget.transaction),
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
            color: Colors.black.withValues(alpha: 0.05),
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
                    text: '${UiUtils.getRecurringFrequencyString(recurring.frequency)} ${context.tr('FrequencyKey')}',
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
  final Recurring recurring;
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
              text: '${recurring.recurringTransactions.length} ${context.tr('totalKey')}',
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
                  final recurringTransactions = context.read<GetRecurringTransactionCubit>().getRecurringTransactionData(recurringId: recurring.recurringId);

                  if (recurringTransactions!.recurringTransactions.isEmpty) {
                    return CustomErrorWidget(
                      errorMessage: context.tr('noDataFound'),
                      errorType: CustomErrorType.noDataFound,
                      onRetry: () {
                        context.read<GetRecurringTransactionCubit>().getRecurringTransactionData(recurringId: recurring.recurringId);
                      },
                    );
                  }
                  return ListView.builder(
                    itemCount: recurringTransactions.recurringTransactions.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final recurringData = recurringTransactions.recurringTransactions;
                      final recurringTransaction = recurringData[index];
                      final status = recurringTransaction.status;
                      final isPaid = status == RecurringTransactionStatus.PAID;
                      final isUpcoming = status == RecurringTransactionStatus.UPCOMING;
                      final isCancelled = status == RecurringTransactionStatus.CANCELLED;

                      final date = UiUtils.parseDate(recurringTransaction.scheduleDate);

                      return Container(
                        margin: const EdgeInsetsDirectional.only(bottom: 12),
                        padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.04, vertical: context.height * 0.02),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border(left: BorderSide(color: status.color, width: 4)),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: status.color.withValues(alpha: 0.1),
                              child: Icon(status.icon, color: status.color),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextView(
                                    text: recurringTransaction.scheduleDate,
                                    fontSize: 14.sp(context),
                                    fontWeight: FontWeight.w600,
                                    softWrap: true,
                                    maxLines: 3,
                                  ),
                                  SizedBox(height: context.height * 0.003),
                                  CustomTextView(
                                    text: context.tr('${status.value}Lbl'),
                                    fontSize: 13.sp(context),
                                    color: colorScheme.surfaceDim,
                                  ),
                                ],
                              ),
                            ),

                            PopupMenuButton(
                              icon: isPaid ? const SizedBox.shrink() : const Icon(Icons.more_vert),
                              itemBuilder: (context) {
                                final items = <PopupMenuEntry<String>>[
                                  if (isCancelled && date.isToday || date.isPast)
                                    _buildPopupMenu(
                                      value: context.tr('paidKey'),
                                      text: context.tr('paidKey'),
                                    ),

                                  if (isUpcoming && !isPaid)
                                    _buildPopupMenu(
                                      value: context.tr('cancelKey'),
                                      text: context.tr('cancelKey'),
                                    ),
                                  if (isCancelled && date.isFuture)
                                    _buildPopupMenu(
                                      value: context.tr('upcomingKey'),
                                      text: context.tr('upcomingKey'),
                                    ),
                                ];

                                return items;
                              },
                              onSelected: (value) async {
                                final status = (value == context.tr('upcomingKey'))
                                    ? RecurringTransactionStatus.UPCOMING
                                    : (value == context.tr('cancelKey'))
                                    ? RecurringTransactionStatus.CANCELLED
                                    : RecurringTransactionStatus.PAID;
                                showChangeStatusDialog(context, transaction: recurring, status: status, recurringTransaction: recurringTransaction);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (state is GetRecurringTransactionFailure) {
                  return CustomErrorWidget(
                    errorMessage: state.message,
                    onRetry: () {
                      context.read<GetRecurringTransactionCubit>().fetchRecurringTransaction();
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
      child: CustomTextView(
        text: text,
        color: color,
      ),
    );
  }
}

Future<void> showChangeStatusDialog(
  BuildContext context, {
  required RecurringTransactionStatus status,
  required Recurring transaction,
  required RecurringTransaction recurringTransaction,
}) async {
  final colorScheme = Theme.of(context).colorScheme;

  context.showAppDialog(
    child: Builder(
      builder: (dialogContext) {
        return Center(
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              if (dialogContext.read<UpdateRecurringTransactionCubit>().state is! UpdateRecurringTransactionLoading) {
                Navigator.of(dialogContext).pop();
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
                        recurringTransaction: state.recurringTransaction!,
                        status: state.status!,
                        transactionId: state.transactionId!,
                      );
                      if (state.status == RecurringTransactionStatus.PAID) {
                        context.read<GetTransactionCubit>().addTransactionLocally(
                          Transaction(
                            id: state.transactionId!,
                            title: state.transaction!.title,
                            amount: state.transaction!.amount,
                            date: state.recurringTransaction!.scheduleDate,
                            accountId: state.transaction!.accountId,
                            categoryId: state.transaction!.categoryId,
                            type: state.transaction!.type,
                            recurringId: state.transaction!.recurringId,
                            recurringTransactionId: state.recurringTransaction!.recurringTransactionId,
                            addFromType: TransactionType.RECURRING,
                          ),
                        );
                      }
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
                          backgroundColor: status.color.withValues(alpha: 0.2),
                          child: Icon(status.icon, color: status.color, size: 28),
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
                          text: 'confirmTransactionKey'.tr(context, namedArgs: {'date': recurringTransaction.scheduleDate, 'title': context.tr('${status.value}Lbl')}),
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
                            final transactionId = 'TR'.withDateTimeMillisRandom();
                            context.read<UpdateRecurringTransactionCubit>().changeRecurringTransactionStatus(
                              recurringTransaction: recurringTransaction,
                              status: status,
                              transaction: transaction,
                              transactionId: status == RecurringTransactionStatus.PAID ? transactionId : recurringTransaction.transactionId,
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
    ),
  );
}
