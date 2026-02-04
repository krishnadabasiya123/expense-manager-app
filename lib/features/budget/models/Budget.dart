import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/budget/models/enums/BudgetPeriod.dart';
import 'package:expenseapp/features/budget/models/enums/BudgetType.dart';
part 'Budget.g.dart';

@HiveType(typeId: 14)
class Budget extends HiveObject {
  Budget({
    required this.createdAt,
    required this.updatedAt,
    this.budgetId = '',
    this.budgetName = '',
    this.amount = 0,
    this.catedoryId = const [],
    this.type = TransactionType.INCOME,
    this.period = BudgetPeriod.WEEKLY,
    this.startDate = '',
    this.endDate = '',
    this.alertPercentage = 0,
  });

  @HiveField(0)
  String budgetId;

  @HiveField(1)
  String budgetName;

  @HiveField(2)
  double amount;

  @HiveField(3)
  List<String> catedoryId;

  @HiveField(4)
  TransactionType type;

  @HiveField(5)
  BudgetPeriod period;

  @HiveField(6)
  String startDate;

  @HiveField(7)
  String endDate;

  @HiveField(8)
  int alertPercentage;

  @HiveField(9)
  String createdAt;

  @HiveField(10)
  String updatedAt;

  Budget copyWith({
    String? budgetId,
    String? budgetName,
    double? amount,
    List<String>? catedoryId,
    TransactionType? type,
    String? createdAt,
    String? updatedAt,
    BudgetPeriod? period,
    String? startDate,
    String? endDate,
    int? alertPercentage,
  }) {
    return Budget(
      budgetId: budgetId ?? this.budgetId,
      budgetName: budgetName ?? this.budgetName,
      amount: amount ?? this.amount,
      catedoryId: catedoryId ?? this.catedoryId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      alertPercentage: alertPercentage ?? this.alertPercentage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'budgetId': budgetId,
      'budgetName': budgetName,
      'amount': amount,
      'catedoryId': catedoryId,
      'type': type,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'period': period,
      'startDate': startDate,
      'endDate': endDate,
      'alertPercentage': alertPercentage,
    };
  }
}
