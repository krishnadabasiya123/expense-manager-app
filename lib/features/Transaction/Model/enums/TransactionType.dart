//enum TransactionType { INCOME, EXPENSE, TRANSFER, DEBIT, CREDIT }
import 'package:hive/hive.dart';

part 'TransactionType.g.dart';

@HiveType(typeId: 1)
enum TransactionType {
  @HiveField(0)
  ALL,

  @HiveField(1)
  EXPENSE,

  @HiveField(2)
  INCOME,

  @HiveField(3)
  TRANSFER,

  @HiveField(4)
  DEBIT,

  @HiveField(5)
  CREDIT,

  @HiveField(6)
  LOAN,

  @HiveField(7)
  LOAN_INTEREST,

  @HiveField(8)
  RECURRING,

  @HiveField(9)
  NONE,
}
