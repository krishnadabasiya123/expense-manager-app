import 'package:expenseapp/commons/widgets/custom_app_bar.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final result = context.read<GetTransactionCubit>().getMinMaxDate();
    final minDate = result.minDate;
    final maxDate = result.maxDate;
    final allTransactions = (context.read<GetTransactionCubit>().state as GetTransactionSuccess).transactions;

    if (!_isInitialized) {
      _focusedDay = minDate;
      _isInitialized = true;
    }

    if (_focusedDay.isBefore(minDate)) {
      _focusedDay = minDate;
    } else if (_focusedDay.isAfter(maxDate)) {
      _focusedDay = maxDate;
    }

    return Scaffold(
      appBar: QAppBar(
        title: CustomTextView(text: context.tr('calenderKey'), fontSize: 20.sp(context), color: colorScheme.surface),
      ),
      body: ResponsivePadding(
        leftPadding: context.width * 0.05,
        rightPadding: context.width * 0.05,
        topPadding: context.height * 0.01,
        bottomPadding: context.height * 0.01,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            TableCalendar(
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  fontSize: 14.sp(context),
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                weekendStyle: TextStyle(
                  fontSize: 14.sp(context),
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              headerStyle: HeaderStyle(
                headerPadding: EdgeInsets.zero,
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp(context)),
              ),
              focusedDay: _focusedDay,
              firstDay: minDate,
              lastDay: maxDate,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },

              calendarStyle: const CalendarStyle(
                selectedTextStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),

                todayTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
              calendarBuilders: CalendarBuilders(
                selectedBuilder: (context, day, focusedDay) {
                  final hasExp = context.read<GetTransactionCubit>().hasExpense(day, allTransactions);
                  final hasInc = context.read<GetTransactionCubit>().hasIncome(day, allTransactions);

                  return _dayContainer(
                    day: day,
                    color: (!hasExp && !hasInc) ? colorScheme.lightGreyColor.withValues(alpha: .2) : colorScheme.primary.withValues(alpha: 0.2),
                    borderColor: (!hasExp && !hasInc) ? colorScheme.lightGreyColor : colorScheme.primary,
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },

                todayBuilder: (context, day, focusedDay) {
                  final hasExp = context.read<GetTransactionCubit>().hasExpense(day, allTransactions);

                  final hasInc = context.read<GetTransactionCubit>().hasIncome(day, allTransactions);

                  return _dayContainer(
                    day: day,
                    //  color: (!hasExp && !hasInc) ? colorScheme.lightGreyColor.withValues(alpha: .2) : colorScheme.primary.withValues(alpha: 0.2),
                    borderColor: (!hasExp && !hasInc) ? colorScheme.lightGreyColor : colorScheme.primary,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },

                defaultBuilder: (context, day, focusedDay) {
                  final hasExp = context.read<GetTransactionCubit>().hasExpense(day, allTransactions);
                  final hasInc = context.read<GetTransactionCubit>().hasIncome(day, allTransactions);

                  if (!hasExp && !hasInc) return null;

                  return _dayContainer(
                    day: day,
                    borderColor: (!hasExp && !hasInc) ? colorScheme.lightGreyColor : colorScheme.primary,
                    textStyle: const TextStyle(
                      color: Colors.black,
                    ),
                  );
                },

                markerBuilder: (context, day, events) {
                  final hasExp = context.read<GetTransactionCubit>().hasExpense(day, allTransactions);
                  final hasInc = context.read<GetTransactionCubit>().hasIncome(day, allTransactions);

                  if (!hasExp && !hasInc) return const SizedBox.shrink();

                  return Positioned(
                    bottom: 4,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (hasExp) _dot(Colors.red),
                        if (hasInc) _dot(context.colorScheme.incomeColor),
                      ],
                    ),
                  );
                },
              ),

              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  context.read<GetTransactionCubit>().getTransactionByDate(focusedDay: focusedDay);
                });
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
                //_focusedDay = focusedDay;
              },
            ),
            SizedBox(height: context.height * 0.02),

            CustomTextView(text: UiUtils.covertInBuiltDate(_selectedDay ?? _focusedDay, context), fontSize: 16.sp(context), fontWeight: FontWeight.bold),

            SizedBox(height: context.height * 0.01),

            BlocBuilder<GetTransactionCubit, GetTransactionState>(
              builder: (context, state) {
                if (state is GetTransactionSuccess) {
                  final transactions = context.read<GetTransactionCubit>().getTransactionByDate(focusedDay: _selectedDay ?? _focusedDay);
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final item = transactions[index];

                      final type = item.type;
                      final subtitle = item.title;
                      final categoryName = context.read<GetCategoryCubit>().getCategoryName(item.categoryId);
                      final accountName = context.read<GetAccountCubit>().getAccountName(id: item.accountId);
                      final accountFromName = context.read<GetAccountCubit>().getAccountName(id: item.accountFromId);
                      final accountToName = context.read<GetAccountCubit>().getAccountName(id: item.accountToId);
                      final amount = item.amount;
                      final isIncome = type == TransactionType.INCOME;
                      return Container(
                        margin: EdgeInsetsDirectional.only(bottom: context.height * 0.01),
                        padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.02, vertical: context.height * 0.0001),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
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
                                  color: type == TransactionType.EXPENSE
                                      ? Colors.red.shade100
                                      : type == TransactionType.INCOME
                                      ? context.colorScheme.incomeColor
                                      : Colors.blue.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  type == TransactionType.EXPENSE
                                      ? Icons.arrow_upward
                                      : type == TransactionType.INCOME
                                      ? Icons.arrow_downward
                                      : Icons.transform_outlined,

                                  color: type == TransactionType.EXPENSE
                                      ? Colors.red
                                      : type == TransactionType.INCOME
                                      ? context.colorScheme.incomeColor
                                      : type == TransactionType.TRANSFER
                                      ? Colors.blue
                                      : Colors.blue,

                                  size: 20.sp(context),
                                ),
                              ),

                              SizedBox(width: context.width * 0.03),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: .center,
                                  children: [
                                    if (categoryName.isNotEmpty && (type == TransactionType.EXPENSE || type == TransactionType.INCOME)) ...[
                                      CustomTextView(
                                        text: categoryName,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: context.isTablet ? 18.sp(context) : 15.sp(context),
                                        maxLines: 2,
                                      ),
                                    ] else ...[
                                      if (type == TransactionType.TRANSFER) ...[
                                        CustomTextView(
                                          text: '$accountFromName → $accountToName',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: context.isTablet ? 18.sp(context) : 15.sp(context),
                                          maxLines: 2,
                                        ),
                                      ],
                                    ],
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
                                        color: isIncome
                                            ? context.colorScheme.incomeColor
                                            : type == TransactionType.TRANSFER
                                            ? Colors.blue
                                            : Colors.red,
                                      ),
                                    ],
                                  ),

                                  if (type != TransactionType.TRANSFER) CustomTextView(text: accountName, fontSize: 14.sp(context), color: Colors.grey.shade600),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return const CustomCircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _dayContainer({
  required DateTime day,
  required Color borderColor,
  required TextStyle textStyle,
  Color? color,
}) {
  return Center(
    child: Container(
      margin: const EdgeInsetsDirectional.only(end: 5, start: 5, top: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Text(
        '${day.day}',
        style: textStyle,
      ),
    ),
  );
}

Widget _dot(Color color) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 2),
    width: 6,
    height: 6,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
    ),
  );
}
