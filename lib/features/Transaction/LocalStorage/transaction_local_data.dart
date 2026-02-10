import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/RecurringTransaction/LocalStorage/recurring_transaction_local_data.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Recurring.dart';

class TransactionLocalData {
  static late Box<Transaction> box;
  static late Box<Transaction> softDeleteBox;

  static Future<void> init() async {
    Hive
      ..registerAdapter(TransactionAdapter())
      ..registerAdapter(TransactionTypeAdapter())
      ..registerAdapter(ImageDataAdapter());
    box = await Hive.openBox<Transaction>(transactionBox);
    softDeleteBox = await Hive.openBox<Transaction>(softDeleteTransactionBox);
  }

  Future<void> saveTransaction(Transaction transaction) async {
    log('saveTransaction ${transaction.toJson()}');
    await box.add(transaction);
  }

  Future<void> saveTransactions(List<Transaction> transactions) async {
    for (final transaction in transactions) {
      await box.add(transaction);
    }
  }

  List<Transaction> getTransaction() {
    final transactions = box.values.toList();
    for (final transaction in transactions) {
      log('transaction ${transaction.toJson()}');
    }
    return transactions;
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final key = box.keys.firstWhere(
      (k) => box.get(k)?.id == transaction.id,
      orElse: () => null,
    );

    if (key != null) {
      await box.put(key, transaction);
    }
  }

  Future<void> deleteTransaction(Transaction transaction) async {
    final key = box.keys.firstWhere(
      (k) => box.get(k)?.id == transaction.id,
      orElse: () => null,
    );

    if (key != null) {
      await box.delete(key);
    }
  }

  Future<void> deleteTransactionsByAccountId({required String? accountId, String? accountFromId, String? accountToId}) async {
    if (accountId != null) {
      final keysToDelete = box.keys
          .where(
            (k) => box.get(k)?.accountId == accountId,
          )
          .toList();

      if (keysToDelete.isNotEmpty) {
        await box.deleteAll(keysToDelete);
      }
    }

    if (accountFromId != null) {
      final keysToDelete = box.keys
          .where(
            (k) => box.get(k)?.accountFromId == accountFromId,
          )
          .toList();

      if (keysToDelete.isNotEmpty) {
        await box.deleteAll(keysToDelete);
      }
    }

    if (accountToId != null) {
      final keysToDelete = box.keys
          .where(
            (k) => box.get(k)?.accountToId == accountToId,
          )
          .toList();

      if (keysToDelete.isNotEmpty) {
        await box.deleteAll(keysToDelete);
      }
    }
  }

  Future<void> saveSoftDeletedTransaction(Transaction transaction) async {
    await softDeleteBox.add(transaction);
  }

  List<Transaction> getSoftDeletedTransaction() {
    return softDeleteBox.values.toList();
  }

  Future<void> deleteTransactionPermanently({required Transaction transaction}) async {
    final key = softDeleteBox.keys.firstWhere(
      (k) => softDeleteBox.get(k)?.id == transaction.id,
      orElse: () => null,
    );

    if (key != null) {
      await softDeleteBox.delete(key);
    }
  }

  Future<void> restoreTransaction(Transaction transaction) async {
    final key = softDeleteBox.keys.firstWhere(
      (k) => softDeleteBox.get(k)?.id == transaction.id,
      orElse: () => null,
    );

    if (key != null) {
      await softDeleteBox.delete(key);
      //   await saveTransaction(transaction);
    }
  }

  // Future<void> updateRecurringDetails({
  //   required Recurring? recurring,
  // }) async {
  //   final key = box.keys.firstWhere(
  //     (k) => box.get(k)?.recurringId == recurring!.recurringId,
  //     orElse: () => null,
  //   );

  //   if (key != null) {
  //     final transaction = box.get(key);

  //     if (transaction != null) {
  //       final updatedTransaction = transaction.copyWith(
  //         title: recurring!.title,
  //         amount: recurring.amount,
  //         accountId: recurring.accountId,
  //         categoryId: recurring.categoryId,
  //       );
  //       await box.put(key, updatedTransaction);
  //     }
  //   }
  // }
  Future<void> updateRecurringDetails({
    required Recurring recurring,
  }) async {
    for (final key in box.keys) {
      final transaction = box.get(key);

      if (transaction?.recurringId == recurring.recurringId) {
        final updatedTransaction = transaction!.copyWith(
          title: recurring.title,
          amount: recurring.amount,
          accountId: recurring.accountId,
          categoryId: recurring.categoryId,
        );

        await box.put(key, updatedTransaction);
      }
    }
  }

  // Future<void> restoreTransaction(Transaction transaction) async {
  //   final key = softDeleteBox.keys.firstWhere(
  //     (k) => softDeleteBox.get(k)?.id == transaction.id,
  //     orElse: () => null,
  //   );

  //   if (key != null) {
  //     final tx = softDeleteBox.get(key);

  //     if (tx != null) {
  //       final restoredTx = tx.copyWith(
  //         id: tx.id,
  //         amount: tx.amount,
  //         title: tx.title,
  //         description: tx.description,
  //         categoryId: tx.categoryId,
  //         date: tx.date,
  //         time: tx.time,
  //         type: tx.type,
  //         recurringId: tx.recurringId,
  //         accountId: tx.accountId,
  //         accountFromId: tx.accountFromId,
  //         accountToId: tx.accountToId,
  //         image: tx.image,
  //         partyId: tx.partyId,
  //         partyTransactionId: tx.partyTransactionId,
  //         addFromType: tx.addFromType,
  //       );

  //       await softDeleteBox.delete(key);
  //       await saveTransaction(restoredTx);
  //     }
  //   }
  // }

  Future<void> softDeleteTransactionDeleteByCategoryId({required String categoryId}) async {
    // softDeleteBox.values.toList();

    // final keysToDelete = softDeleteBox.keys
    //     .where(
    //       (k) => softDeleteBox.get(k)?.categoryId == categoryId,
    //     )
    //     .toList();

    // if (keysToDelete.isNotEmpty) {
    //   await softDeleteBox.deleteAll(keysToDelete);
    // }
    final transaction = softDeleteBox.values.toList();

    for (final transaction in transaction) {
      if (transaction.categoryId == categoryId) {
        transaction.categoryId = '';
      }

      await transaction.save();
    }
  }

  Future<void> softDeleteTransactionDeleteByAccountId({required String accountId, required String accountFromId, required String accountToId}) async {
    softDeleteBox.values.toList();

    final keysToDelete = softDeleteBox.keys
        .where(
          (k) => softDeleteBox.get(k)?.accountId == accountId || softDeleteBox.get(k)?.accountFromId == accountFromId || softDeleteBox.get(k)?.accountToId == accountToId,
        )
        .toList();

    if (keysToDelete.isNotEmpty) {
      await softDeleteBox.deleteAll(keysToDelete);
    }
  }

  Future<void> setNullRecurringTransactionId({required String recurringId}) async {
    for (final key in box.keys) {
      final transaction = box.get(key);

      if (transaction?.recurringId == recurringId) {
        final updatedTransaction = transaction!.copyWith(
          recurringId: '',
          recurringTransactionId: '',
          addFromType: TransactionType.NONE,
        );

        await box.put(key, updatedTransaction);
      }
    }
  }

  Future<void> permanentlyDeleteRecurringTransaction({required String recurringId}) async {
    final keysToDelete = box.keys
        .where(
          (k) => box.get(k)?.recurringId == recurringId,
        )
        .toList();

    if (keysToDelete.isNotEmpty) {
      await box.deleteAll(keysToDelete);
    }
  }

  Future<void> moveTransactions({
    required String fromAccountId,
    required String toAccountId,
  }) async {
    for (final key in box.keys) {
      final transaction = box.get(key);
      if (transaction == null) continue;

      bool modified = false;
      String newAccountId = transaction.accountId;
      String newAccountFromId = transaction.accountFromId;
      String newAccountToId = transaction.accountToId;

      if (transaction.type == TransactionType.TRANSFER) {
         if (transaction.accountFromId == fromAccountId) {
           newAccountFromId = '';
           modified = true;
         }
         if (transaction.accountToId == fromAccountId) {
           newAccountToId = '';
           modified = true;
         }
      } else {
        if (transaction.accountId == fromAccountId) {
          newAccountId = toAccountId;
          modified = true;
        }
        if (transaction.accountFromId == fromAccountId) {
          newAccountFromId = toAccountId;
          modified = true;
        }
        if (transaction.accountToId == fromAccountId) {
          newAccountToId = toAccountId;
          modified = true;
        }
      }

      if (modified) {
        final updatedTransaction = transaction.copyWith(
          accountId: newAccountId,
          accountFromId: newAccountFromId,
          accountToId: newAccountToId,
        );

        await box.put(key, updatedTransaction);
      }
    }
  }
}
