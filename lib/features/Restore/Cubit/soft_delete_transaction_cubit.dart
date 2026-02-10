import 'package:expenseapp/core/app/all_import_file.dart';

@immutable
sealed class SoftDeleteTransactionState {}

final class SoftDeleteTransactionInitial extends SoftDeleteTransactionState {}

final class SoftDeleteTransactionLoading extends SoftDeleteTransactionState {}

final class SoftDeleteTransactionSuccess extends SoftDeleteTransactionState {
  SoftDeleteTransactionSuccess(this.transaction);
  final Transaction transaction;
}

final class SoftDeleteTransactionFailure extends SoftDeleteTransactionState {
  SoftDeleteTransactionFailure(this.errorMessage);
  final String errorMessage;
}

class SoftDeleteTransactionCubit extends Cubit<SoftDeleteTransactionState> {
  SoftDeleteTransactionCubit() : super(SoftDeleteTransactionInitial());

  final TransactionLocalData transactionLocalData = TransactionLocalData();

  Future<void> softDeleteTransaction(Transaction transaction) async {
    emit(SoftDeleteTransactionLoading());
    Future.delayed(const Duration(seconds: 0), () {
      try {
        transactionLocalData.deleteTransactionPermanently(transaction: transaction);
        emit(SoftDeleteTransactionSuccess(transaction));
      } catch (e) {
        emit(SoftDeleteTransactionFailure(e.toString()));
      }
    });
  }
}
