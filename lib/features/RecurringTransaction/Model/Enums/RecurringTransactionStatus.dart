import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:flutter/material.dart';

part 'RecurringTransactionStatus.g.dart';

@HiveType(typeId: 10)
enum RecurringTransactionStatus {
  @HiveField(0)
  PAID(
    'paid',
    Colors.green,
    Icons.check_circle,
  ),

  @HiveField(1)
  UPCOMING('upcoming', Color(0xFF1E3A8A), Icons.upcoming),

  @HiveField(2)
  CANCELLED('cancelled', Colors.red, Icons.block)
  ;

  final String value;
  final Color color;
  final IconData icon;

  const RecurringTransactionStatus(this.value, this.color, this.icon);

  static RecurringTransactionStatus fromKey(String key) {
    return RecurringTransactionStatus.values.firstWhere(
      (status) => status.value == key,
      orElse: () => RecurringTransactionStatus.PAID,
    );
  }
}
