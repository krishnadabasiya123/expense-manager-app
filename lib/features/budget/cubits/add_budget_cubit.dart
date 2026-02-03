import 'package:bloc/bloc.dart';
import 'package:expenseapp/features/budget/LocalStorage/budget_local_storage.dart';
import 'package:expenseapp/features/budget/models/Budget.dart';
import 'package:meta/meta.dart';

@immutable
sealed class AddBudgetState {}

final class AddBudgetInitial extends AddBudgetState {}

final class AddBudgetLoading extends AddBudgetState {}

final class AddBudgetFailure extends AddBudgetState {
  AddBudgetFailure(this.error);
  final String error;
}

final class AddBudgetSuccess extends AddBudgetState {
  AddBudgetSuccess(this.budget);
  final Budget budget;
}

class AddBudgetCubit extends Cubit<AddBudgetState> {
  AddBudgetCubit() : super(AddBudgetInitial());

  Future<void> addBudget(Budget budget) async {
    emit(AddBudgetLoading());
    Future.delayed(const Duration(seconds: 5), () {
      try {
        emit(AddBudgetSuccess(budget));
      } catch (e) {
        emit(AddBudgetFailure(e.toString()));
      }
    });
  }
}
