import 'package:bloc/bloc.dart';
import 'package:expenseapp/features/RecurringTransaction/LocalStorage/recurring_transaction_local_data.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Recurring.dart';
import 'package:meta/meta.dart';

@immutable
sealed class DeleteRecurringTransactionState {}

final class DeleteRecurringTransactionInitial extends DeleteRecurringTransactionState {}

final class DeleteRecurringTransactionLoading extends DeleteRecurringTransactionState {}

final class DeleteRecurringTransactionSuccess extends DeleteRecurringTransactionState {
  DeleteRecurringTransactionSuccess(this.transactionId);
  final String transactionId;
}

final class DeleteRecurringTransactionFailure extends DeleteRecurringTransactionState {
  DeleteRecurringTransactionFailure(this.errorMessage);
  final String errorMessage;
}

class DeleteRecurringTransactionCubit extends Cubit<DeleteRecurringTransactionState> {
  DeleteRecurringTransactionCubit() : super(DeleteRecurringTransactionInitial());

  final RecurringTransactionLocalData recurringTransactionLocalData = RecurringTransactionLocalData();

  Future<void> deleteRecurringTransaction({required String recurringId}) async {
    emit(DeleteRecurringTransactionLoading());
    Future.delayed(const Duration(seconds: 0), () async {
      try {
        emit(DeleteRecurringTransactionSuccess(recurringId));
      } catch (e) {
        emit(DeleteRecurringTransactionFailure(e.toString()));
      }
    });
  }
}
