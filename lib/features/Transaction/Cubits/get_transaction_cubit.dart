import 'dart:math' as math;

import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Recurring.dart';
import 'package:expenseapp/features/budget/models/enums/BudgetType.dart';

@immutable
sealed class GetTransactionState {}

final class GetTransactionInitial extends GetTransactionState {}

final class GetTransactionSuccess extends GetTransactionState {
  GetTransactionSuccess(this.transactions);
  final List<Transaction> transactions;
  //final List<Map<String, dynamic>> transactions;

  GetTransactionSuccess copyWith({List<Transaction>? transactions}) {
    return GetTransactionSuccess(transactions ?? this.transactions);
  }
}

final class GetTransactionLoading extends GetTransactionState {}

final class GetTransactionFailure extends GetTransactionState {
  GetTransactionFailure(this.message);
  final String message;
}

class GetTransactionCubit extends Cubit<GetTransactionState> {
  GetTransactionCubit() : super(GetTransactionInitial());

  final TransactionLocalData transactionLocalData = TransactionLocalData();

  Future<void> fetchTransaction() async {
    emit(GetTransactionLoading());
    try {
      final transactions = TransactionLocalData().getTransaction();

      emit(GetTransactionSuccess(transactions));
    } catch (e) {
      emit(GetTransactionFailure(e.toString()));
    }
  }

  bool hasExpense(DateTime day, List<Transaction> transactions) {
    if (state is GetTransactionSuccess) {
      return transactions.any((tx) {
        final txDate = _parseDate(tx.date);
        return isSameDate(txDate, day) && tx.type == TransactionType.EXPENSE;
      });
    }
    return false;
  }

  bool hasIncome(DateTime day, List<Transaction> transactions) {
    if (state is GetTransactionSuccess) {
      return transactions.any((tx) {
        final txDate = _parseDate(tx.date);
        return isSameDate(txDate, day) && tx.type == TransactionType.INCOME;
      });
    }
    return false;
  }

  Future<void> addTransactionLocallyTest(
    Transaction transaction,
  ) async {
    try {
      final currentState = state;
      if (currentState is GetTransactionSuccess) {
        final updatedList = List<Transaction>.from(currentState.transactions)..insert(0, transaction);

        emit(GetTransactionSuccess(updatedList));
      }
    } catch (e) {}
  }

  Future<void> addTransactionLocally(
    Transaction transaction,
  ) async {
    try {
      await transactionLocalData.saveTransaction(transaction);

      final currentState = state;
      if (currentState is GetTransactionSuccess) {
        final updatedList = List<Transaction>.from(currentState.transactions)..insert(0, transaction);

        emit(GetTransactionSuccess(updatedList));
      }
    } catch (e) {}
  }

  Future<void> addTransactionsLocally(List<Transaction> transactions) async {
    try {
      await transactionLocalData.saveTransactions(transactions);

      if (state is GetTransactionSuccess) {
        final currentState = state as GetTransactionSuccess;
        final oldList = currentState.transactions;
        final updatedList = [...oldList, ...transactions];

        emit(GetTransactionSuccess(updatedList));
      }
    } catch (e) {}
  }

  Future<void> deleteTransacionLocally(Transaction transaction) async {
    try {
      await transactionLocalData.deleteTransaction(transaction);

      final currentState = state;

      if (currentState is GetTransactionSuccess) {
        final oldData = (state as GetTransactionSuccess).transactions..removeWhere((element) => element.id == transaction.id);
        emit(GetTransactionSuccess(oldData));
      }
    } catch (e) {}
  }

  Future<void> updateTransactionLocally(Transaction transaction) async {
    try {
      await transactionLocalData.updateTransaction(transaction);
      final currentState = state;

      if (currentState is GetTransactionSuccess) {
        final currentState = state as GetTransactionSuccess;
        final updateList = List<Transaction>.from(currentState.transactions);
        final index = updateList.indexWhere((element) => element.id == transaction.id);

        if (index != -1) {
          updateList[index] = transaction;
          emit(currentState.copyWith(transactions: updateList));
        }
      }
    } catch (e) {
      emit(GetTransactionFailure(e.toString()));
    }
  }

  Future<void> updateAccountNameLocallyInTransaction({required String accouutId}) async {
    if (state is GetTransactionSuccess) {
      final transactions = (state as GetTransactionSuccess).transactions;
      final index = transactions.indexWhere((p) => p.accountId == accouutId || p.accountFromId == accouutId || p.accountToId == accouutId);
      if (index != -1) {
        transactions[index].accountId = accouutId;
        transactions[index].accountFromId = accouutId;
        transactions[index].accountToId = accouutId;
        emit(GetTransactionSuccess(transactions));
      }
    }
  }

  Future<void> updateCategoryNameLocallyInTransaction({required String categoryId}) async {
    if (state is GetTransactionSuccess) {
      final transactions = (state as GetTransactionSuccess).transactions;
      final index = transactions.indexWhere((p) => p.categoryId == categoryId);
      if (index != -1) {
        transactions[index].categoryId = categoryId;
        emit(GetTransactionSuccess(transactions));
      }
    }
  }

  double getTotalExpense() {
    if (state is GetTransactionSuccess) {
      final transactions = (state as GetTransactionSuccess).transactions;

      try {
        final totalExpense = transactions.fold<double>(
          0,
          (sum, item) => item.type == TransactionType.EXPENSE ? sum + (item.amount) : sum,
        );

        return totalExpense;
      } catch (e) {
        return 0;
      }
    }

    return 0;
  }

  double getTotalExpenseFilterByMonth(DateTime focusedDay) {
    if (state is GetTransactionSuccess) {
      final transactions = (state as GetTransactionSuccess).transactions;

      return transactions
          .where((tx) {
            if (tx.date.isEmpty) return false;

            final txDate = _parseDate(tx.date);

            return txDate.year == focusedDay.year && txDate.month == focusedDay.month && tx.type == TransactionType.EXPENSE;
          })
          // 🔹 sum
          .fold<double>(
            0,
            (sum, tx) => sum + (tx.amount),
          );
    }
    return 0;
  }

  double getTotalIncomeFilterByMonth(DateTime focusedDay) {
    if (state is GetTransactionSuccess) {
      final transactions = (state as GetTransactionSuccess).transactions;

      return transactions
          .where((tx) {
            final txDate = _parseDate(tx.date);

            return txDate.year == focusedDay.year && txDate.month == focusedDay.month && tx.type == TransactionType.INCOME;
          })
          .fold<double>(
            0,
            (sum, tx) => sum + (tx.amount),
          );
    }
    return 0;
  }

  double getTotalIncome() {
    if (state is GetTransactionSuccess) {
      final transactions = (state as GetTransactionSuccess).transactions;

      try {
        final totalIncome = transactions.fold<double>(
          0,
          (sum, item) => item.type == TransactionType.INCOME ? sum + (item.amount) : sum,
        );

        return totalIncome;
      } catch (e) {
        return 0;
      }
    }

    return 0;
  }

  double getTotalBalance() {
    return getTotalIncome() - getTotalExpense();
  }

  List<Map<String, dynamic>> getTransactionByFilterDate({
    required TransactionType selectedTab,
    int count = 0,
    DateTime? date,
    String searchText = '',
  }) {
    final currentState = state;
    if (currentState is! GetTransactionSuccess) return [];

    // Convert to List and start the "Cool" chain
    return currentState.transactions
        .filterByType(selectedTab)
        .filterBySearch(searchText, CategoryLocalStorage().getAll())
        .filterByMonth(date)
        .sortByDate()
        .maybeTake(count)
        .groupByDate(); // Returns the List<Map<String, dynamic>>
  }

  List<Transaction> getTransactionByDate({
    required DateTime focusedDay,
  }) {
    if (state is! GetTransactionSuccess) return [];

    final transactions = (state as GetTransactionSuccess).transactions;

    final data = transactions.where((tx) {
      final txDate = _parseDate(tx.date);
      return isSameDate(txDate, focusedDay);
    }).toList();

    log('filtered data count: ${data.length}');
    return data;
  }

  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<Map<String, dynamic>> getTransactionByAccountId({
    required String? accountId,
  }) {
    if (state is GetTransactionSuccess) {
      final transactions = (state as GetTransactionSuccess).transactions;

      try {
        final grouped = <String, List<Transaction>>{};

        final sortedTransactions = [...transactions];

        final filteredTransactions = sortedTransactions.where((item) => item.accountId == accountId || item.accountFromId == accountId || item.accountToId == accountId).toList()
          ..sort((b, a) => a.date.compareTo(b.date));

        for (final item in filteredTransactions) {
          grouped.putIfAbsent(item.date, () => []);
          grouped[item.date]!.add(item);
        }

        return grouped.entries.map((entry) {
          return {
            'date': entry.key,
            'transactions': entry.value,
          };
        }).toList();
      } catch (e, st) {
        return [];
      }
    }
    return [];
  }

  ({DateTime minDate, DateTime maxDate}) getMinMaxDate() {
    if (state is GetTransactionSuccess) {
      final transactions = (state as GetTransactionSuccess).transactions;

      if (transactions.isEmpty) {
        final now = DateTime.now();
        return (minDate: now, maxDate: now);
      }

      final dates = transactions.where((e) => e.date.isNotEmpty).map((e) => _parseDate(e.date)).toList();

      if (dates.isEmpty) {
        final now = DateTime.now();
        return (minDate: now, maxDate: now);
      }

      dates.sort();

      return (
        minDate: dates.first,
        maxDate: dates.last,
      );
    }

    final now = DateTime.now();
    return (minDate: now, maxDate: now);
  }

  DateTime _parseDate(String date) {
    final parts = date.split('.');
    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
  }

  void setNullCategoryValueInTransaction(String id) {
    if (state is GetTransactionSuccess) {
      final transactions = (state as GetTransactionSuccess).transactions;

      final index = transactions.indexWhere((e) => e.categoryId == id);

      if (index != -1) {
        transactions[index].categoryId = '';
        emit(GetTransactionSuccess(transactions));
      }
    }
  }

  int totalExpenseTransactionCount() {
    if (state is GetTransactionSuccess) {
      final transactions = (state as GetTransactionSuccess).transactions;

      return transactions.fold<int>(
        0,
        (sum, item) => item.type == TransactionType.EXPENSE ? sum + 1 : sum,
      );
    }

    return 0;
  }

  int totalIncomeTransactionCount() {
    if (state is GetTransactionSuccess) {
      final transactions = (state as GetTransactionSuccess).transactions;

      return transactions.fold<int>(
        0,
        (sum, item) => item.type == TransactionType.INCOME ? sum + 1 : sum,
      );
    }

    return 0;
  }

  void deleteTransactionWhenDeleteAccount({required String accountId, required String accountFromId, required String accountToId}) {
    transactionLocalData.deleteTransactionsByAccountId(accountId: accountId, accountFromId: accountFromId, accountToId: accountToId);
    if (state is GetTransactionSuccess) {
      final currentState = state as GetTransactionSuccess;

      final transactions = (state as GetTransactionSuccess).transactions
        ..removeWhere((element) => element.accountFromId == accountFromId || element.accountToId == accountToId || element.accountId == accountId);
      emit(currentState.copyWith(transactions: transactions));
    }
  }

  double getTotalIncomeByAccountId({required String accountId}) {
    if (state is GetTransactionSuccess) {
      final transactions = (state as GetTransactionSuccess).transactions;

      return transactions.fold<double>(0, (sum, item) {
        final amount = item.amount;

        if (item.type == TransactionType.INCOME && item.accountId == accountId) {
          return sum + amount;
        }

        // account to id count in income

        if (item.type == TransactionType.TRANSFER && item.accountToId == accountId) {
          return sum + amount;
        }

        return sum;
      });
    }
    return 0;
  }

  double getTotalExpenseByAccountId({required String accountId}) {
    if (state is GetTransactionSuccess) {
      final transactions = (state as GetTransactionSuccess).transactions;

      return transactions.fold<double>(0, (sum, item) {
        final amount = item.amount;

        if (item.type == TransactionType.EXPENSE && item.accountId == accountId) {
          return sum + amount;
        }

        // account from id count in expense

        if (item.type == TransactionType.TRANSFER && item.accountFromId == accountId) {
          return sum + amount;
        }

        return sum;
      });
    }
    return 0;
  }

  Future<void> updateRecurringDetailsLocallyInTransaction({
    required Recurring recurring,
  }) async {
    transactionLocalData.updateRecurringDetails(
      recurring: recurring,
    );
    if (state is GetTransactionSuccess) {
      final transactions = (state as GetTransactionSuccess).transactions;

      for (final transaction in transactions) {
        if (transaction.recurringId == recurring.recurringId) {
          final index = transactions.indexOf(transaction);
          transactions[index] = transaction.copyWith(title: recurring.title, amount: recurring.amount, accountId: recurring.accountId, categoryId: recurring.categoryId);
        }
      }
      emit(GetTransactionSuccess(transactions));
    }
  }

  Future<void> setNullRecurringTransactionId({required String recurringId}) async {
    await transactionLocalData.setNullRecurringTransactionId(recurringId: recurringId);
    if (state is GetTransactionSuccess) {
      final transactions = (state as GetTransactionSuccess).transactions;

      for (final transaction in transactions) {
        if (transaction.recurringId == recurringId) {
          transaction
            ..recurringId = ''
            ..recurringTransactionId = ''
            ..addFromType = TransactionType.NONE;
          emit(GetTransactionSuccess(transactions));
        }
      }
    }
  }

  Future<void> permanentlyDeleteRecurringTransaction({required String recurringId}) async {
    await transactionLocalData.permanentlyDeleteRecurringTransaction(recurringId: recurringId);
    if (state is GetTransactionSuccess) {
      final transactions = (state as GetTransactionSuccess).transactions..removeWhere((element) => element.recurringId == recurringId);
      emit(GetTransactionSuccess(transactions));
    }
  }

  List<double> getMonthlyExpenseAmountsOnly() {
    if (state is GetTransactionSuccess) {
      final transactions = (state as GetTransactionSuccess).transactions;
      final monthlyAmounts = List<double>.filled(12, 0);
      final currentYear = DateTime.now().year;

      for (final tx in transactions) {
        final txDate = _parseDate(tx.date);
        if (tx.type != TransactionType.EXPENSE) continue;
        if (txDate.year != currentYear) continue;

        final monthIndex = txDate.month - 1;
        monthlyAmounts[monthIndex] += tx.amount;
      }
      log('monthlyAmounts $monthlyAmounts');
      return monthlyAmounts;
    }
    return [];
  }

  List<Map<String, double>> getMonthlyIncomeExpenseOnly() {
    final transactions = (state as GetTransactionSuccess).transactions;
    final currentYear = DateTime.now().year;

    // Jan–Dec with default 0
    final result = List<Map<String, double>>.generate(
      12,
      (_) => {
        'expense': 0.0,
        'income': 0.0,
      },
    );

    for (final tx in transactions) {
      final txDate = _parseDate(tx.date);
      if (txDate.year != currentYear) continue;

      final index = txDate.month - 1;

      if (tx.type == TransactionType.EXPENSE) {
        result[index]['expense'] = result[index]['expense']! + tx.amount;
      } else if (tx.type == TransactionType.INCOME) {
        result[index]['income'] = result[index]['income']! + tx.amount;
      }
    }

    log('result $result');

    return result;
  }

  double getTotalBudgetSpent({required List<String> categoryIds, required TransactionType type, required String date}) {
    double total = 0;
    final parseDate = UiUtils.parseDate(date);
    if (state is GetTransactionSuccess) {
      final transactions = (state as GetTransactionSuccess).transactions;
      for (final tx in transactions) {
        final parseTransactionDate = UiUtils.parseDate(tx.date);
        if (TransactionType.ALL == type && !parseTransactionDate.isAfter(parseDate)) {
          if (categoryIds.contains(tx.categoryId)) {
            if (tx.type == TransactionType.EXPENSE) {
              total += tx.amount;
            } else if (tx.type == TransactionType.INCOME) {
              total -= tx.amount;
            }
          }
        }
        if (categoryIds.contains(tx.categoryId) && tx.type == type && !parseTransactionDate.isAfter(parseDate)) {
          total += tx.amount;
        }
      }
    }
    log('total $total');
    return total;
  }

  List<Map<String, dynamic>> getTransactionByCategoryId({
    required List<String> categoryIds,
    required String date,
    required TransactionType type,
  }) {
    if (state is GetTransactionSuccess) {
      final transactions = (state as GetTransactionSuccess).transactions;
      final parseDate = UiUtils.parseDate(date);

      try {
        final grouped = <String, List<Transaction>>{};

        final sortedTransactions = [...transactions];
        final filteredTransactions =
            sortedTransactions
                .where(
                  (item) => categoryIds.contains(item.categoryId) && (type == TransactionType.ALL || item.type == type) && !UiUtils.parseDate(item.date).isAfter(parseDate),
                )
                .toList()
              ..sort((b, a) => a.date.compareTo(b.date))
              ..removeWhere((element) => !parseDate.isAfter(UiUtils.parseDate(element.date)));

        for (final item in filteredTransactions) {
          grouped.putIfAbsent(item.categoryId, () => []);
          grouped[item.categoryId]!.add(item);
        }

        return grouped.entries.map((entry) {
          return {
            'categoryId': entry.key,
            'total': entry.value.fold<double>(0, (sum, item) => sum + item.amount),
            'transactions': entry.value,
          };
        }).toList();
      } catch (e, st) {
        return [];
      }
    }
    return [];
  }

  int totalTransactionCount({required String account}) {
    if (state is GetTransactionSuccess) {
      final transactions = (state as GetTransactionSuccess).transactions;
      final totalTransaction = transactions.where((element) => element.accountId == account || element.accountFromId == account || element.accountToId == account).toList();
      return totalTransaction.length;
    }

    return 0;
  }
}
