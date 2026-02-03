import 'package:expenseapp/core/app/all_import_file.dart';
part 'BudgetPeriod.g.dart';

@HiveType(typeId: 16)
enum BudgetPeriod {
  @HiveField(0)
  WEEKLY,

  @HiveField(1)
  MONTHLY,

  @HiveField(2)
  YEARLY,

  @HiveField(3)
  CUSTOM,
}
