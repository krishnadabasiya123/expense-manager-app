import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'TransactionType.g.dart';

@HiveType(typeId: 1)
enum TransactionType {
  @HiveField(0)
  ALL('all'),
  @HiveField(1)
  EXPENSE('expense', color: Colors.red, icon: Icons.arrow_upward),
  @HiveField(2)
  INCOME('income', color: Colors.green, icon: Icons.arrow_downward),
  @HiveField(3)
  TRANSFER('transfer', color: Colors.blue, icon: Icons.transform_outlined),
  @HiveField(4)
  DEBIT('debit', color: Colors.red, icon: Icons.arrow_upward),
  @HiveField(5)
  CREDIT('credit', color: Colors.green, icon: Icons.arrow_downward),
  @HiveField(6)
  LOAN('loan'),
  @HiveField(7)
  LOAN_INTEREST('loanInterest'),
  @HiveField(8)
  RECURRING('recurring'),
  @HiveField(9)
  NONE('none')
  ;

  final String value;
  final Color? color;
  final IconData? icon;

  const TransactionType(this.value, {this.color, this.icon});

  static TransactionType fromKey(String key) {
    return TransactionType.values.firstWhere(
      (status) => status.value == key,
      orElse: () => TransactionType.NONE,
    );
  }
}
