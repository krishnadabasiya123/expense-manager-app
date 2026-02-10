import 'package:bloc/bloc.dart';
import 'package:expenseapp/features/budget/models/Budget.dart';
import 'package:meta/meta.dart';

@immutable
sealed class UpdateBudgetState {}

final class UpdateBudgetInitial extends UpdateBudgetState {}

final class UpdateBudgetLoading extends UpdateBudgetState {}

final class UpdateBudgetFailure extends UpdateBudgetState {
  UpdateBudgetFailure(this.error);
  final String error;
}

final class UpdateBudgetSuccess extends UpdateBudgetState {
  UpdateBudgetSuccess(this.budget);
  final Budget budget;
}

class UpdateBudgetCubit extends Cubit<UpdateBudgetState> {
  UpdateBudgetCubit() : super(UpdateBudgetInitial());

  Future<void> updateBudget(Budget budget) async {
    emit(UpdateBudgetLoading());
    Future.delayed(const Duration(seconds: 0), () {
      try {
        emit(UpdateBudgetSuccess(budget));
      } catch (e) {
        emit(UpdateBudgetFailure(e.toString()));
      }
    });
  }
}
