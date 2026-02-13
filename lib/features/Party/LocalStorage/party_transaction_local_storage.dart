import 'package:expenseapp/core/app/all_import_file.dart';

class PartyTransactionLocalData {
  static late Box<PartyTransaction> box;
  static late Box<Party> partybox;

  static late Box<PartyTransaction> softDeleteBox;
  static late Box<Party> partySoftDeleteBox;

  static Future<void> init() async {
    box = await Hive.openBox<PartyTransaction>(partyTransactionBox);
    partybox = await Hive.openBox<Party>(partyBox);
    softDeleteBox = await Hive.openBox<PartyTransaction>(softDeletePartyTransactionBoxKey);
    partySoftDeleteBox = await Hive.openBox<Party>(softDeletePartyBoxKey);
  }

  Future<void> addPartyTransaction({
    required String partyId,
    required PartyTransaction transaction,
  }) async {
    final party = partybox.values.firstWhere(
      (p) => p.id == partyId,
    )..transaction;

    party.transaction.add(transaction);

    await party.save();
  }

  List<PartyTransaction> getPartyTransaction({required Party party}) {
    final partyData = partybox.values.firstWhere(
      (p) => p.id == party.id,
    );

    return partyData.transaction;
  }

  Future<void> updatePartyTransaction({
    required PartyTransaction transaction,
    String? partyId,
  }) async {
    final party = partybox.values.firstWhere((p) => p.id == partyId);

    final index = party.transaction.indexWhere((e) => e.id == transaction.id) ?? -1;

    if (index == -1) return;

    party.transaction[index] = transaction;

    await party.save();
  }

  Future<void> deletePartyTransaction({
    required String partyId,
    required PartyTransaction transaction,
  }) async {
    final party = partybox.values.firstWhere(
      (p) => p.id == partyId,
    );

    final index = party.transaction.indexWhere((e) => e.id == transaction.id);

    if (index == -1) return;

    party.transaction.removeAt(index);

    await party.save();
  }

  Future<void> saveSoftDeletedPartytransactionById({required PartyTransaction transaction}) async {
    softDeleteBox.add(transaction);
  }

  List<PartyTransaction> getSoftDeletedPartytransaction() {
    return softDeleteBox.values.toList();
  }

  Future<void> permenantlyDeletePartyTransactionById({required String partyTransactionId}) async {
    final key = softDeleteBox.keys.firstWhere(
      (k) => softDeleteBox.get(k)?.id == partyTransactionId,
      orElse: () => null,
    );

    if (key != null) {
      await softDeleteBox.delete(key);
    }
  }

  Future<void> restoreSoftDeletedPartyTransaction({required PartyTransaction transaction}) async {
    final key = softDeleteBox.keys.firstWhere(
      (k) => softDeleteBox.get(k)?.id == transaction.id,
      orElse: () => null,
    );

    if (key != null) {
      await softDeleteBox.delete(key);
      await addPartyTransaction(partyId: transaction.partyId, transaction: transaction);
    }
  }

  Future<void> softDeletePartyTransactionByCategoryId({required String categoryId}) async {
    // softDeleteBox.values.toList();

    // final keysToDelete = softDeleteBox.keys
    //     .where(
    //       (k) => softDeleteBox.get(k)?.category == categoryId,
    //     )
    //     .toList();

    // if (keysToDelete.isNotEmpty) {
    //   await softDeleteBox.deleteAll(keysToDelete);
    // }
    final transaction = softDeleteBox.values.toList();

    for (final transaction in transaction) {
      if (transaction.category == categoryId) {
        transaction.category = '';
      }

      await transaction.save();
    }
  }

  Future<void> softDeletePartyTransactionDeleteByAccountId({required String accountId}) async {
    softDeleteBox.values.toList();

    final keysToDelete = softDeleteBox.keys
        .where(
          (k) => softDeleteBox.get(k)?.accountId == accountId,
        )
        .toList();

    if (keysToDelete.isNotEmpty) {
      await softDeleteBox.deleteAll(keysToDelete);
    }
  }

  // Future<void> deletePartyTransactionByAccountId({
  //   required String accountId,
  // }) async {
  //   final partyList = partybox.values.toList();

  //   for (final party in partyList) {
  //     // Remove transactions with the given accountId
  //     party.transaction?.removeWhere((transaction) => transaction.accountId == accountId);

  //     // Save the updated party back to Hive
  //     await party.save();
  //   }
  // }

  Future<void> updateAccountAndTransactionIdWhenAccountDelete({
    required String accountId,
  }) async {
    final partyList = partybox.values.toList();

    for (final party in partyList) {
      final transactions = party.transaction;

      if (transactions.isNotEmpty) {
        for (final txn in transactions) {
          if (txn.accountId == accountId) {
            txn
              ..accountId = ''
              ..mainTransactionId = ''
              ..isMainTransaction = false;
          }
        }
      }

      // Save updated party
      await party.save();
    }
  }

  
}
