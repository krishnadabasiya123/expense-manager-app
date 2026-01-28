import 'package:hive_flutter/adapters.dart';

part 'Account.g.dart';

@HiveType(typeId: 2)
class Account extends HiveObject {
  Account({required this.id, required this.name, required this.amount});

  @HiveField(0)
  String id = '';

  @HiveField(1)
  String name = '';

  @HiveField(2)
  double amount = 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
    };
  }
}
