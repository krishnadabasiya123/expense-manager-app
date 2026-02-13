import 'package:expenseapp/core/app/all_import_file.dart';

class PartyLocalData {
  static late Box<Party> box;

  static Future<void> init() async {
    Hive
      ..registerAdapter(PartyAdapter())
      ..registerAdapter(PartyTransactionAdapter());
    box = await Hive.openBox<Party>(partyBox);
  }

  Future<void> saveParty(Party party) async {
    await box.add(party);
  }

  List<Party> getParty() {
    final parties = box.values.toList();

    return parties;
  }

  Future<void> updateParty(
    Party party,
  ) async {
    await party.save();
  }

  Future<void> deleteParty(Party party) async {
    await party.delete();
  }

  Future<void> updateAccountIdWhenMoveTransaction({
    required String fromAccountId,
    required String toAccountId,
  }) async {
    for (final key in box.keys) {
      final parent = box.get(key);
      if (parent == null) continue;

      final updatedList = parent.transaction.map((tx) {
        if (tx.accountId == fromAccountId) {
          return tx.copyWith(accountId: toAccountId);
        }
        return tx;
      }).toList();

      final updatedParent = parent.copyWith(
        transaction: updatedList,
      );

      await box.put(key, updatedParent);
    }
  }
}
