import 'package:hive/hive.dart';
part 'TransactionType.g.dart';

@HiveType(typeId: 1)
enum TransactionType {
  @HiveField(0)
  ALL('all'),
  @HiveField(1)
  EXPENSE('expense'),
  @HiveField(2)
  INCOME('income'),
  @HiveField(3)
  TRANSFER('transfer'),
  @HiveField(4)
  DEBIT('debit'),
  @HiveField(5)
  CREDIT('credit'),
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

  const TransactionType(this.value);

  static TransactionType fromKey(String key) {
    return TransactionType.values.firstWhere(
      (status) => status.value == key,
      orElse: () => TransactionType.NONE,
    );
  }
}
