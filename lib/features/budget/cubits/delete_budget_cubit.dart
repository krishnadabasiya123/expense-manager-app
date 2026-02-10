import 'package:bloc/bloc.dart';
import 'package:expenseapp/features/budget/models/Budget.dart';
import 'package:meta/meta.dart';

@immutable
sealed class DeleteBudgetState {}

final class DeleteBudgetInitial extends DeleteBudgetState {}

final class DeleteBudgetLoading extends DeleteBudgetState {}

final class DeleteBudgetFailure extends DeleteBudgetState {
  DeleteBudgetFailure(this.error);
  final String error;
}

final class DeleteBudgetSuccess extends DeleteBudgetState {
  DeleteBudgetSuccess(this.budget);
  final Budget budget;
}

class DeleteBudgetCubit extends Cubit<DeleteBudgetState> {
  DeleteBudgetCubit() : super(DeleteBudgetInitial());

  Future<void> deleteBudget(Budget budget) async {
    emit(DeleteBudgetLoading());
    Future.delayed(const Duration(seconds: 0), () {
      try {
        emit(DeleteBudgetSuccess(budget));
      } catch (e) {
        emit(DeleteBudgetFailure(e.toString()));
      }
    });
  }
}
