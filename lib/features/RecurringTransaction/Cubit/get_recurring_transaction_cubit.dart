import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/RecurringTransaction/LocalStorage/recurring_transaction_local_data.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Enums/RecurringFrequency.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Enums/RecurringTransactionStatus.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Recurring.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/RecurringTransaction.dart';

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
  bool _isProcessing = false;

  bool get isProcessing => _isProcessing;

  void startProcessing() => _isProcessing = true;
  void endProcessing() => _isProcessing = false;

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

      case RecurringFrequency.none:
        return current;
    }
  }

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

      current = getNextDate(current, frequency);
    }

    return list;
  }

  Future<void> createRecurringTransaction(
    Recurring recuring,
  ) async {
    if (state is GetRecurringTransactionSuccess) {
      final currentState = state as GetRecurringTransactionSuccess;
      final oldList = currentState.transactions;

      final list = generateRecurringTransactions(
        startDateStr: recuring.startDate,
        endDateStr: recuring.endDate,
        recurringId: recuring.recurringId,
        frequency: recuring.frequency,
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
      final list = generateRecurringTransactions(startDateStr: recuring.startDate, endDateStr: recuring.endDate, recurringId: recuring.recurringId, frequency: recuring.frequency);

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

      final newList = oldList.map((e) {
        if (e.recurringId == transaction.recurringId) {
          return transaction;
        }
        return e;
      }).toList();

      emit(currentState.copyWith(transactions: newList));
    }
  }

  Future<void> updateRecurringTransactionByStatus({
    required Recurring transaction,
    required RecurringTransaction recurringTransaction,
    required RecurringTransactionStatus status,
    required String transactionId,
  }) async {
    recurringTransactionLocalData.updateRecurringTransactionByStatus(
      recurring: transaction,
      status: status,
      recurringTransactionId: recurringTransaction.recurringTransactionId,
      transactionId: transactionId,
    );
    if (state is GetRecurringTransactionSuccess) {
      final currentState = state as GetRecurringTransactionSuccess;

      final updatedTransactions = List<Recurring>.from(currentState.transactions);

      final recurringIndex = updatedTransactions.indexWhere((e) => e.recurringId == transaction.recurringId);

      if (recurringIndex == -1) return;

      final recurring = updatedTransactions[recurringIndex];

      final recurringTxIndex = recurring.recurringTransactions.indexWhere((e) => e.recurringTransactionId == recurringTransaction.recurringTransactionId);

      if (recurringTxIndex == -1) return;

      recurring.recurringTransactions[recurringTxIndex] = recurring.recurringTransactions[recurringTxIndex].copyWith(
        status: status,
        transactionId: transactionId,
      );
      updatedTransactions[recurringIndex] = recurring;

      emit(GetRecurringTransactionSuccess(updatedTransactions));
    }
  }

  List<Recurring> getDueRecurringTransactions() {
    if (state is GetRecurringTransactionSuccess) {
      final recurrings = (state as GetRecurringTransactionSuccess).transactions;
      final result = <Recurring>[];

      for (final recurring in recurrings) {
        final dueTransactions = <RecurringTransaction>[];

        for (final rt in recurring.recurringTransactions) {
          final scheduleDate = UiUtils.dateFormatter.parse(rt.scheduleDate);

          final shouldCreate = rt.transactionId.isEmpty && rt.status == RecurringTransactionStatus.UPCOMING && (scheduleDate.isToday || scheduleDate.isPast);

          // if (shouldCreate && !dueTransactions.any((e) => e.recurringId == rt.recurringId)) {
          //   dueTransactions.add(rt);
          // }
          if (shouldCreate) {
            dueTransactions.add(rt);
          }
        }

        if (dueTransactions.isNotEmpty) {
          result.add(
            recurring.copyWith(recurringTransactions: dueTransactions),
          );
        }
      }

      return result;
    }
    return [];
  }

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
    } catch (e) {}
  }

  void setNullCategoryValueInRecurringTransaction(String id) {
    if (state is GetRecurringTransactionSuccess) {
      final transactions = (state as GetRecurringTransactionSuccess).transactions;

      for (final transaction in transactions) {
        if (transaction.categoryId == id) {
          transaction.categoryId = '';
        }
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
        for (final e in transactions[index].recurringTransactions) {
          if (e.scheduleDate == scheduleDate) {
            e
              ..transactionId = transactionId
              ..recurringTransactionId = recurringTransactionId;
          }
        }
        emit(GetRecurringTransactionSuccess(transactions));
      }
    }
  }

  Recurring? getRecurringTransactionById({required String recurringId}) {
    if (state is GetRecurringTransactionSuccess) {
      final transactions = (state as GetRecurringTransactionSuccess).transactions;

      final index = transactions.indexWhere((e) => e.recurringId == recurringId);

      if (index != -1) {
        return transactions[index];
      }
    }
    return null;
  }

  Future<void> deleteRecurringTransactionLocally({required String recurringId}) async {
    try {
      await recurringTransactionLocalData.deleteRecurringTransaction(recurringId: recurringId);
      final currentState = state;

      if (currentState is GetRecurringTransactionSuccess) {
        final transactions = (state as GetRecurringTransactionSuccess).transactions;

        final index = transactions.indexWhere((e) => e.recurringId == recurringId);

        if (index != -1) {
          transactions.removeAt(index);
          emit(currentState.copyWith(transactions: transactions));
        }
      }
    } catch (e) {
      log('deleteRecurringTransactionLocally error: $e');
    }
  }

  Future<void> updateAccountNameLocallyInRecurringTransaction({required String accouutId}) async {
    if (state is GetRecurringTransactionSuccess) {
      final transactions = (state as GetRecurringTransactionSuccess).transactions;
      for (final transaction in transactions) {
        if (transaction.accountId == accouutId) {
          transaction.accountId = accouutId;
        }
        emit(GetRecurringTransactionSuccess(transactions));
      }
    }
  }

  Future<void> updateCategoryNameLocallyInRecurringTransaction({required String categoryId}) async {
    if (state is GetRecurringTransactionSuccess) {
      final transactions = (state as GetRecurringTransactionSuccess).transactions;
      for (final transaction in transactions) {
        if (transaction.categoryId == categoryId) {
          transaction.categoryId = categoryId;
        }
        emit(GetRecurringTransactionSuccess(transactions));
      }
    }
  }

  int getTotalRecurringTransactionCount() {
    if (state is GetRecurringTransactionSuccess) {
      final transactions = (state as GetRecurringTransactionSuccess).transactions;
      return transactions.length;
    }
    return 0;
  }

  Future<void> updateAccountIdInRecurringWhenMoveTransaction({required String fromAccountId, required String toAccountId}) async {
    await recurringTransactionLocalData.updateRecurringAccountIdWhenMoveTransaction(fromAccountId: fromAccountId, toAccountId: toAccountId);
    if (state is GetRecurringTransactionSuccess) {
      final transactions = (state as GetRecurringTransactionSuccess).transactions;
      final updatedTransactions = transactions.map((transaction) {
        var newAccountId = transaction.accountId;

        if (transaction.accountId == fromAccountId) {
          log('update account id $fromAccountId to $toAccountId');
          newAccountId = toAccountId;
        }

        return transaction.copyWith(
          accountId: newAccountId,
        );
      }).toList();
      emit(GetRecurringTransactionSuccess(updatedTransactions));
    }
  }
}
