import 'package:expenseapp/core/app/all_import_file.dart';

@immutable
sealed class RestoreTransactionState {}

final class RestoreTransactionInitial extends RestoreTransactionState {}

final class RestoreTransactionLoading extends RestoreTransactionState {}

final class RestoreTransactionSuccess extends RestoreTransactionState {
  RestoreTransactionSuccess(this.transaction);
  final Transaction transaction;
}

final class RestoreTransactionFailure extends RestoreTransactionState {
  RestoreTransactionFailure(this.errorMessage);
  final String errorMessage;
}

class RestoreTransactionCubit extends Cubit<RestoreTransactionState> {
  RestoreTransactionCubit() : super(RestoreTransactionInitial());

  final TransactionLocalData transactionLocalData = TransactionLocalData();

  Future<void> restoreTransaction(Transaction transaction) async {
    emit(RestoreTransactionLoading());
    Future.delayed(const Duration(seconds: 2), () {
      try {
        transactionLocalData.restoreTransaction(transaction);
        emit(RestoreTransactionSuccess(transaction));
      } catch (e) {
        emit(RestoreTransactionFailure(e.toString()));
      }
    });
  }
}
