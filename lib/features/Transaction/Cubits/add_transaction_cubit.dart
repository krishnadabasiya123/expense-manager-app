import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/RecurringTransaction/LocalStorage/recurring_transaction_local_data.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Recurring.dart';

@immutable
sealed class AddTransactionState {}

final class AddTransactionInitial extends AddTransactionState {}

final class AddTransactionSuccess extends AddTransactionState {
  AddTransactionSuccess(this.transaction);
  final Transaction transaction;
}

final class AddTransactionFailure extends AddTransactionState {
  AddTransactionFailure(this.errorMessage);
  final String errorMessage;
}

final class AddTransactionLoading extends AddTransactionState {}

class AddTransactionCubit extends Cubit<AddTransactionState> {
  AddTransactionCubit() : super(AddTransactionInitial());

  final TransactionLocalData transactionLocalData = TransactionLocalData();

  final RecurringTransactionLocalData recurringTransactionLocalData = RecurringTransactionLocalData();

  Future<void> addTransaction(Transaction transaction) async {
    emit(AddTransactionLoading());
    Future.delayed(const Duration(), () {
      try {
        //  transactionLocalData.saveTransaction(transaction);
        emit(AddTransactionSuccess(transaction));
      } catch (e) {
        emit(AddTransactionFailure(e.toString()));
      }
    });
  }

  Future<void> addSoftDeleteTransaction(Transaction transaction) async {
    await transactionLocalData.saveSoftDeletedTransaction(transaction);
  }
}
