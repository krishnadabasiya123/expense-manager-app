import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:expenseapp/features/budget/LocalStorage/budget_local_storage.dart';
import 'package:expenseapp/features/budget/models/Budget.dart';
import 'package:meta/meta.dart';

@immutable
sealed class GetBudgetState {}

final class GetBudgetInitial extends GetBudgetState {}

final class GetBudgetLoading extends GetBudgetState {}

final class GetBudgetFailure extends GetBudgetState {
  GetBudgetFailure(this.error);
  final String error;
}

final class GetBudgetSuccess extends GetBudgetState {
  GetBudgetSuccess(this.budget);
  final List<Budget> budget;
}

class GetBudgetCubit extends Cubit<GetBudgetState> {
  GetBudgetCubit() : super(GetBudgetInitial());

  BudgetLocalStorage budgetLocalStorage = BudgetLocalStorage();

  Future<void> getBudget() async {
    emit(GetBudgetLoading());
    Future.delayed(const Duration(), () {
      try {
        final budget = budgetLocalStorage.getBudget();
        emit(GetBudgetSuccess(budget));
      } catch (e) {
        emit(GetBudgetFailure(e.toString()));
      }
    });
  }

  Future<void> addBudgetLocally(Budget budget) async {
    await budgetLocalStorage.saveBudget(budget);
    if (state is GetBudgetSuccess) {
      final currentState = state as GetBudgetSuccess;
      final updatedList = List<Budget>.from(currentState.budget)..insert(currentState.budget.length, budget);
      emit(GetBudgetSuccess(updatedList));
    }
  }

  Future<void> updateBudgetLocally(Budget budget) async {
    await budgetLocalStorage.updateBudget(budget);
    if (state is GetBudgetSuccess) {
      final bugdetList = (state as GetBudgetSuccess).budget;
      final newBudgetList = List<Budget>.from(bugdetList);
      final index = newBudgetList.indexWhere((element) => element.budgetId == budget.budgetId);

      if (index != -1) {
        newBudgetList[index] = budget;
        emit(GetBudgetSuccess(newBudgetList));
      }
    }
  }

  Future<void> deleteBudgetLocally(Budget budget) async {
    await budgetLocalStorage.deleteBudget(budget);
    if (state is GetBudgetSuccess) {
      final oldData = (state as GetBudgetSuccess).budget..removeWhere((element) => element.budgetId == budget.budgetId);
      emit(GetBudgetSuccess(oldData));
    }
  }

  Future<void> deleteCategoryLocallyInBudget({required String categoryId}) async {
    await budgetLocalStorage.deleteCategoryInBudget(categoryId: categoryId);
    if (state is GetBudgetSuccess) {
      final oldData = (state as GetBudgetSuccess).budget;
      final index = oldData.indexWhere((element) => element.catedoryId.contains(categoryId));
      if (index != -1) {
        oldData[index].catedoryId.remove(categoryId);
      }
      emit(GetBudgetSuccess(oldData));
    }
  }

  List<Budget> getBudgetList({
    required int count,
  }) {
    if (state is GetBudgetSuccess) {
      final budgetList = (state as GetBudgetSuccess).budget;
      if (count == 0) return budgetList;
      return budgetList.take(count).toList();
    }
    return [];
  }
}
