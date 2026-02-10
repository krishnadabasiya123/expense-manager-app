import 'package:expenseapp/core/app/all_import_file.dart';

class AccountLocalStorage {
  static late Box<Account> box;

  static Future<void> init() async {
    Hive.registerAdapter(AccountAdapter());

    box = await Hive.openBox<Account>(accountBox);

    if (box.isEmpty) {
      await box.add(
        Account(id: '-1', name: 'Cash', amount: 0),
      );
    }
  }

  Future<void> saveAccount(Account account) async {
    box.add(account);
  }

  List<Account> getAccount() {
    final account = box.values.toList();
    return account;
  }

  Future<void> updateAccount(Account account) async {
    final key = box.keys.firstWhere(
      (k) => box.get(k)?.id == account.id,
      orElse: () => null,
    );
    if (key != null) {
      await box.put(key, account);
    }
  }

  Future<void> deleteAccount(Account account) async {
    final key = box.keys.firstWhere(
      (k) => box.get(k)?.id == account.id,
      orElse: () => null,
    );

    if (key != null) {
      await box.delete(key);
    }
  }
}
