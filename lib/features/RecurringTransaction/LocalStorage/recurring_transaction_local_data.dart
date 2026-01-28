import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Recurring.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/RecurringTransaction.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Enums/RecurringFrequency.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Enums/RecurringTransactionStatus.dart';
import 'package:hive/hive.dart';

class RecurringTransactionLocalData {
  static late Box<Recurring> box;

  static Future<void> init() async {
    Hive
      ..registerAdapter(RecurringAdapter())
      ..registerAdapter(RecurringTransactionAdapter())
      ..registerAdapter(RecurringFrequencyAdapter())
      ..registerAdapter(RecurringTransactionStatusAdapter());

    box = await Hive.openBox<Recurring>(reurringBox);
  }

  Future<void> saveRecurringTransaction(Recurring reccuringTransaction) async {
    await box.add(reccuringTransaction);
  }

  List<Recurring> getRecurringTransaction() {
    final transactions = box.values.toList();
    log('data is $transactions');
    for (final transaction in transactions) {
      log('transaction is ${transaction.toJson()}');
    }
    return transactions;
  }

  Future<void> updateRecurringTransaction(Recurring transaction) async {
    final key = box.keys.firstWhere(
      (k) => box.get(k)?.recurringId == transaction.recurringId,
      orElse: () => null,
    );

    if (key != null) {
      await box.put(key, transaction);
    }
  }

  Future<void> updateRecurringTransactionByStatus({
    required Recurring recurring,
    required String recurringTransactionId,
    required RecurringTransactionStatus status,
    required String transactionId,
  }) async {
    final recurringList = box.values.toList();

    for (final recurring in recurringList) {
      final transactions = recurring.recurringTransactions;

      for (final txn in transactions) {
        if (txn.recurringTransactionId == recurringTransactionId) {
          txn
            ..status = status
            ..transactionId = transactionId;
        }
      }

      await recurring.save();
    }
  }

  Future<Recurring?> updateRecurringTitleAmtDate({
    required String recurring,
    required String title,
    required double amount,
    required String endDate,
    String? accountId,
    String? categoryId,
  }) async {
    final key = box.keys.firstWhere((k) => box.get(k)?.recurringId == recurring, orElse: () => null);
    final storedRecurring = box.get(key);
    if (key != null) {
      if (storedRecurring != null) {
        final updatedRecurring = storedRecurring.copyWith(
          title: title,
          amount: amount,
          endDate: endDate,
          accountId: accountId,
          categoryId: categoryId,
        );
        await box.put(key, updatedRecurring);
        log('updated recurring ${updatedRecurring.toJson()}');
        return updatedRecurring;
      }
    }
    return storedRecurring;
  }

  Future<void> attachTransactionIdToRecurring({
    required String recurringId,
    required String scheduleDate,
    required String transactionId,
    required String recurringTransactionId,
  }) async {
    final key = box.keys.firstWhere(
      (k) => box.get(k)?.recurringId == recurringId,
      orElse: () => null,
    );

    if (key == null) return;

    final recurring = box.get(key);
    if (recurring == null) return;

    final index = recurring.recurringTransactions.indexWhere(
      (e) => e.scheduleDate == scheduleDate && e.transactionId == null,
    );

    if (index == -1) return;

    recurring.recurringTransactions[index] = recurring.recurringTransactions[index].copyWith(
      transactionId: transactionId,
      recurringTransactionId: recurringTransactionId,
    );

    await box.put(key, recurring);
  }

  Future<void> deleteRecurringTransaction({required String recurringId}) async {
    final key = box.keys.firstWhere(
      (k) => box.get(k)?.recurringId == recurringId,
      orElse: () => null,
    );

    if (key != null) {
      await box.delete(key);
    }
  }
}
