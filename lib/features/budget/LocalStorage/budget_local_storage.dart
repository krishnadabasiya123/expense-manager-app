import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/budget/models/Budget.dart';
import 'package:expenseapp/features/budget/models/enums/BudgetPeriod.dart';
import 'package:expenseapp/features/budget/models/enums/BudgetType.dart';

class BudgetLocalStorage {
  static late Box<Budget> box;
  static Future<void> init() async {
    Hive
      ..registerAdapter(BudgetAdapter())
      ..registerAdapter(BudgetPeriodAdapter())
      ..registerAdapter(BudgetTypeAdapter());
    box = await Hive.openBox<Budget>(budgetBox);
  }

  Future<void> saveBudget(Budget budget) async {
    log('saveBudget ${budget.toJson()}');
    box.add(budget);
  }

  List<Budget> getBudget() {
    final budgets = box.values.toList();
    return budgets;
  }

  Future<void> updateBudget(Budget budget) async {
    final key = box.keys.firstWhere(
      (k) => box.get(k)?.budgetId == budget.budgetId,
      orElse: () => null,
    );
    if (key != null) {
      await box.put(key, budget);
    }
  }

  Future<void> deleteBudget(Budget budget) async {
    final key = box.keys.firstWhere(
      (k) => box.get(k)?.budgetId == budget.budgetId,
      orElse: () => null,
    );

    if (key != null) {
      await box.delete(key);
    }
  }
}
