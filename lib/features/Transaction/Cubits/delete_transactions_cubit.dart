
import 'package:expenseapp/core/app/all_import_file.dart';

@immutable
sealed class DeleteTransactionsState {}

final class DeleteTransactionsInitial extends DeleteTransactionsState {}

final class DeleteTransactionsSuccess extends DeleteTransactionsState {
  DeleteTransactionsSuccess(this.transaction);
  final Transaction transaction;
}

final class DeleteTransactionsFailure extends DeleteTransactionsState {
  DeleteTransactionsFailure(this.errorMessage);
  final String errorMessage;
}

final class DeleteTransactionsLoading extends DeleteTransactionsState {}

class DeleteTransactionsCubit extends Cubit<DeleteTransactionsState> {
  DeleteTransactionsCubit() : super(DeleteTransactionsInitial());

  final TransactionLocalData transactionLocalData = TransactionLocalData();

  Future<void> deleteTransaction(Transaction transaction) async {
    emit(DeleteTransactionsLoading());
    Future.delayed(const Duration(seconds: 0), () {
      try {
        // transactionLocalData.deleteTransaction(transactionId);
        //transactionLocalData.deleteTransaction(transaction);
        emit(DeleteTransactionsSuccess(transaction));
      } catch (e) {
        emit(DeleteTransactionsFailure(e.toString()));
      }
    });
  }
}
