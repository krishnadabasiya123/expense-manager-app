import 'package:expenseapp/core/app/all_import_file.dart';
part 'BudgetType.g.dart';

@HiveType(typeId: 15)
enum BudgetType {
  @HiveField(0)
  INCOME,

  @HiveField(1)
  EXPENSE,
}
