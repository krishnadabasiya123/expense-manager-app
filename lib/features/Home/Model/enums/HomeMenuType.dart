import 'package:expenseapp/core/app/all_import_file.dart';

part 'HomeMenuType.g.dart';

@HiveType(typeId: 12)
enum HomeMenuType {
  @HiveField(0)
  NULL,

  @HiveField(1)
  HOME_PAGE_BANNER,

  @HiveField(2)
  BUDGETS,

  @HiveField(3)
  UPCOMING_TRANSACTION,

  @HiveField(4)
  GOALS,

  @HiveField(5)
  ACCOUNT_LIST,

  @HiveField(6)
  INCOME_EXPENSE,

  @HiveField(7)
  NET_WORTH,

  @HiveField(8)
  LOANS,

  @HiveField(9)
  GRAPHS,

  @HiveField(10)
  TRANSACTION_LIST,
}
