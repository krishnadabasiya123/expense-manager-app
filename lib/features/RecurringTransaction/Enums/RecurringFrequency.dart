import 'package:expenseapp/core/app/all_import_file.dart';

part 'RecurringFrequency.g.dart';

@HiveType(typeId: 11)
enum RecurringFrequency {
  @HiveField(1)
  weekly,

  @HiveField(2)
  monthly,

  @HiveField(3)
  yearly,

  @HiveField(4)
  daily,
}
