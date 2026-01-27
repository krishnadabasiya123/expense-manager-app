import 'package:hive_flutter/adapters.dart';

part 'Account.g.dart';

@HiveType(typeId: 2)
class Account extends HiveObject {
  Account({required this.id, required this.name, required this.amount});

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double amount;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
    };
  }
}
