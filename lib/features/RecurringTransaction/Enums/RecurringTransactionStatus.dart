import 'package:expenseapp/core/app/all_import_file.dart';

part 'RecurringTransactionStatus.g.dart';

@HiveType(typeId: 10)
enum RecurringTransactionStatus {
  @HiveField(0)
  PAID,

  @HiveField(1)
  UPCOMING,

  @HiveField(2)
  CANCELLED,
}
