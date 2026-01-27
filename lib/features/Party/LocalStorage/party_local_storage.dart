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
}
