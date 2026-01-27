import 'package:bloc/bloc.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/RecurringTransaction/Enums/RecurringFrequency.dart';
import 'package:expenseapp/features/RecurringTransaction/Enums/RecurringTransactionStatus.dart';
import 'package:expenseapp/features/RecurringTransaction/LocalStorage/recurring_transaction_local_data.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Recurring.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/RecurringTransaction.dart';
import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';

@immutable
sealed class GetRecurringTransactionState {}

final class GetRecurringTransactionInitial extends GetRecurringTransactionState {}

final class GetRecurringTransactionSuccess extends GetRecurringTransactionState {
  GetRecurringTransactionSuccess(this.transactions);
  final List<Recurring> transactions;

  GetRecurringTransactionSuccess copyWith({List<Recurring>? transactions}) {
    return GetRecurringTransactionSuccess(transactions ?? this.transactions);
  }
}

final class GetRecurringTransactionFailure extends GetRecurringTransactionState {
  GetRecurringTransactionFailure(this.message);
  final String message;
}

final class GetRecurringTransactionLoading extends GetRecurringTransactionState {}

class GetRecurringTransactionCubit extends Cubit<GetRecurringTransactionState> {
  GetRecurringTransactionCubit() : super(GetRecurringTransactionInitial());

  final RecurringTransactionLocalData recurringTransactionLocalData = RecurringTransactionLocalData();
  final TransactionLocalData transactionLocalData = TransactionLocalData();

  Future<void> fetchRecurringTransaction() async {
    emit(GetRecurringTransactionLoading());
    try {
      final transactions = recurringTransactionLocalData.getRecurringTransaction();
      emit(GetRecurringTransactionSuccess(transactions));
    } catch (e) {
      emit(GetRecurringTransactionFailure(e.toString()));
    }
  }

  Recurring? getRecurringTransactionData({
    required String recurringId,
  }) {
    if (state is GetRecurringTransactionSuccess) {
      final transactions = (state as GetRecurringTransactionSuccess).transactions;

      final index = transactions.indexWhere((e) => e.recurringId == recurringId);

      if (index != -1) {
        return transactions[index];
      }
    }
    return null;
  }

  DateTime getNextDate(
    DateTime current,
    RecurringFrequency frequency,
  ) {
    switch (frequency) {
      case RecurringFrequency.daily:
        return current.add(const Duration(days: 1));

      case RecurringFrequency.weekly:
        return current.add(const Duration(days: 7));

      case RecurringFrequency.monthly:
        return DateTime(
          current.year,
          current.month + 1,
          current.day,
        );

      case RecurringFrequency.yearly:
        return DateTime(
          current.year + 1,
          current.month,
          current.day,
        );
    }
  }

  // List<RecurringTransaction> generateRecurringTransactions({
  //   required String startDateStr,
  //   required String endDateStr,
  //   required String recurringId,
  //   required RecurringFrequency frequency,
  // }) {
  //   final list = <RecurringTransaction>[];

  //   final startDate = UiUtils.parseDate(startDateStr);
  //   final endDate = UiUtils.parseDate(endDateStr);

  //   var today = DateTime.now();
  //   today = DateTime(today.year, today.month, today.day);

  //   var current = startDate;

  //   // 16 start - 18 end at 19 date condition false

  //   while (!current.isAfter(endDate)) {
  //     final status = (current.isBefore(today) || UiUtils.isSameDay(current, today)) ? RecurringTransactionStatus.PAID : RecurringTransactionStatus.UPCOMING;

  //     list.add(
  //       RecurringTransaction(
  //         recurringTransactionId:  'TR'.withDateTimeMillisRandom() ,
  //         recurringId: recurringId,
  //         scheduleDate: UiUtils.dateFormatter.format(current),
  //         status: status,
  //       ),
  //     );

  //     current = getNextDate(current, frequency);
  //   }
  //   return list;
  // }

  List<RecurringTransaction> generateRecurringTransactions({
    required String startDateStr,
    required String endDateStr,
    required String recurringId,
    required RecurringFrequency frequency,
  }) {
    final list = <RecurringTransaction>[];

    final startDate = UiUtils.parseDate(startDateStr);
    final endDate = UiUtils.parseDate(endDateStr);

    // normalize today (remove time)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    var current = startDate;

    while (!current.isAfter(endDate)) {
      final isToday = UiUtils.isSameDay(current, today);

      final transaction = RecurringTransaction(
        recurringTransactionId: 'RT'.withDateTimeMillisRandom(),
        recurringId: recurringId,
        scheduleDate: UiUtils.dateFormatter.format(current),
        status: (current.isBefore(today) || isToday) ? RecurringTransactionStatus.PAID : RecurringTransactionStatus.UPCOMING,
      );

      list.add(transaction);

      log('ADDED => ${transaction.toJson()}');

      current = getNextDate(current, frequency);
    }

    log('TOTAL GENERATED => ${list.length}');

    return list;
  }

  Future<void> createRecurringTransaction(
    Recurring recuring,
  ) async {
    if (state is GetRecurringTransactionSuccess) {
      final currentState = state as GetRecurringTransactionSuccess;
      final oldList = currentState.transactions;

      final list = generateRecurringTransactions(
        startDateStr: recuring.startDate!,
        endDateStr: recuring.endDate!,
        recurringId: recuring.recurringId!,
        frequency: recuring.frequency!,
      );

      final transaction = Recurring(
        recurringId: recuring.recurringId,
        title: recuring.title,
        frequency: recuring.frequency,
        startDate: recuring.startDate,
        endDate: recuring.endDate,
        amount: recuring.amount,
        accountId: recuring.accountId,
        categoryId: recuring.categoryId,
        type: recuring.type,
        recurringTransactions: list,
      );
      recurringTransactionLocalData.saveRecurringTransaction(transaction);

      final newList = [...oldList, transaction];

      emit(GetRecurringTransactionSuccess(newList));
    }
  }

  void updateRecurringTransaction(Recurring recuring) {
    if (state is GetRecurringTransactionSuccess) {
      final currentState = state as GetRecurringTransactionSuccess;
      final oldList = currentState.transactions;
      final list = generateRecurringTransactions(startDateStr: recuring.startDate!, endDateStr: recuring.endDate!, recurringId: recuring.recurringId!, frequency: recuring.frequency!);

      final transaction = Recurring(
        recurringId: recuring.recurringId,
        title: recuring.title,
        frequency: recuring.frequency,
        startDate: recuring.startDate,
        endDate: recuring.endDate,
        amount: recuring.amount,
        accountId: recuring.accountId,
        categoryId: recuring.categoryId,
        type: recuring.type,
        recurringTransactions: list,
      );
      recurringTransactionLocalData.updateRecurringTransaction(transaction);

      final newList = [...oldList, transaction];

      emit(GetRecurringTransactionSuccess(newList));
    }
  }

  Future<void> updateRecurringTransactionByStatus({
    required Recurring transaction,
    required String recurringTransactionId,
    required RecurringTransactionStatus status,
    required String transactionId,
  }) async {
    recurringTransactionLocalData.updateRecurringTransactionByStatus(recurring: transaction, status: status, recurringTransactionId: recurringTransactionId, transactionId: transactionId);
    if (state is GetRecurringTransactionSuccess) {
      final currentState = state as GetRecurringTransactionSuccess;

      final updatedTransactions = List<Recurring>.from(currentState.transactions);

      final recurringIndex = updatedTransactions.indexWhere((e) => e.recurringId == transaction.recurringId);

      if (recurringIndex == -1) return;

      final recurring = updatedTransactions[recurringIndex];

      final recurringTxIndex = recurring.recurringTransactions?.indexWhere((e) => e.recurringTransactionId == recurringTransactionId);

      if (recurringTxIndex == null || recurringTxIndex == -1) return;

      recurring.recurringTransactions![recurringTxIndex] = recurring.recurringTransactions![recurringTxIndex].copyWith(
        status: status,
        transactionId: transactionId,
      );
      updatedTransactions[recurringIndex] = recurring;

      emit(GetRecurringTransactionSuccess(updatedTransactions));
    }
  }

  Future<List<Recurring>> fetchDueRecurringTransactions() async {
    if (state is! GetRecurringTransactionSuccess) return [];

    final recurrings = (state as GetRecurringTransactionSuccess).transactions;

    // filter recurrings which have due transactions
    final result = recurrings
        .map((recurring) {
          final dueTransactions = (recurring.recurringTransactions ?? []).where((rt) {
            final scheduleDate = UiUtils.dateFormatter.parse(rt.scheduleDate ?? '');
            return (scheduleDate.isToday || scheduleDate.isPast) && rt.status == RecurringTransactionStatus.UPCOMING && rt.transactionId == null;
          }).toList();

          if (dueTransactions.isEmpty) return null;

          return recurring.copyWith(recurringTransactions: dueTransactions);
        })
        .whereType<Recurring>() // remove nulls
        .toList();

    debugPrint('DUE RECURRINGS => ${result.length}');
    for (final recurring in result) {
      debugPrint('Recurring => ${recurring.toJson()}');
    }

    return result;
  }

  // Future<List<Recurring>> fetchDueRecurringTransactions() async {
  //   if (state is GetRecurringTransactionSuccess) {
  //     final recurrings = (state as GetRecurringTransactionSuccess).transactions;

  //     final result = <Recurring>[];

  //     for (final recurring in recurrings) {
  //       final due = <RecurringTransaction>[];

  //       for (final rt in recurring.recurringTransactions!) {
  //         final scheduleDate = UiUtils.dateFormatter.parse(rt.scheduleDate ?? '');

  //         if ((scheduleDate.isToday || scheduleDate.isPast) && rt.status == RecurringTransactionStatus.UPCOMING) {
  //           due.add(rt);
  //           print('rt.status ${rt.toJson()}');
  //         }
  //       }

  //       if (due.isNotEmpty) {
  //         result.add(recurring.copyWith(recurringTransactions: due));
  //       }
  //     }

  //     return result;
  //   }
  //   return [];
  // }

  Future<void> updateRecurringTransactionLocally({
    required Recurring recurringTransaction,
  }) async {
    try {
      final currentState = state;

      if (currentState is GetRecurringTransactionSuccess) {
        final currentState = state as GetRecurringTransactionSuccess;
        final updateList = List<Recurring>.from(currentState.transactions);
        final index = updateList.indexWhere((element) => element.recurringId == recurringTransaction.recurringId);

        if (index != -1) {
          updateList[index] = recurringTransaction;
          emit(currentState.copyWith(transactions: updateList));
        }
      }
    } catch (e) {
      log('updateRecurringTransactionLocally error: $e');
    }
  }

  void setNullCategoryValueInRecurringTransaction(String id) {
    if (state is GetRecurringTransactionSuccess) {
      final transactions = (state as GetRecurringTransactionSuccess).transactions;

      final index = transactions.indexWhere((e) => e.categoryId == id);

      if (index != -1) {
        transactions[index].categoryId = '';
        emit(GetRecurringTransactionSuccess(transactions));
      }
    }
  }

  Future<void> attachTransactionIdToRecurring({
    required String recurringId,
    required String scheduleDate,
    required String transactionId,
    required String recurringTransactionId,
  }) async {
    recurringTransactionLocalData.attachTransactionIdToRecurring(
      recurringId: recurringId,
      scheduleDate: scheduleDate,
      transactionId: transactionId,
      recurringTransactionId: recurringTransactionId,
    );
    if (state is GetRecurringTransactionSuccess) {
      final transactions = (state as GetRecurringTransactionSuccess).transactions;

      final index = transactions.indexWhere((e) => e.recurringId == recurringId);

      if (index != -1) {
        for (final e in transactions[index].recurringTransactions!) {
          if (e.scheduleDate == scheduleDate) {
            e.transactionId = transactionId;
            e.recurringTransactionId = recurringTransactionId;
          }
        }
        emit(GetRecurringTransactionSuccess(transactions));
      }
    }
  }
}
