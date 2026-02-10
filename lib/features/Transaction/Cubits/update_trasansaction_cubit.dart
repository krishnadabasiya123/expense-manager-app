import 'package:expenseapp/core/app/all_import_file.dart';

@immutable
sealed class UpdateTrasansactionState {}

final class UpdateTrasansactionInitial extends UpdateTrasansactionState {}

final class UpdateTrasansactionSuccess extends UpdateTrasansactionState {
  UpdateTrasansactionSuccess(this.transaction);
  final Transaction transaction;
}

final class UpdateTrasansactionFailure extends UpdateTrasansactionState {
  UpdateTrasansactionFailure(this.errorMessage);
  final String errorMessage;
}

final class UpdateTrasansactionLoading extends UpdateTrasansactionState {}

class UpdateTrasansactionCubit extends Cubit<UpdateTrasansactionState> {
  UpdateTrasansactionCubit() : super(UpdateTrasansactionInitial());

  final TransactionLocalData transactionLocalData = TransactionLocalData();

  Future<void> updateTransaction(Transaction transaction) async {
    emit(UpdateTrasansactionLoading());
    Future.delayed(const Duration(), () async {
      try {
        emit(UpdateTrasansactionSuccess(transaction));
      } catch (e) {
        emit(UpdateTrasansactionFailure(e.toString()));
      }
    });
  }
}




  // double getTotalIncomeByAccountId({required String accountId}) {
  //   if (state is GetTransactionSuccess) {
  //     final transactions = (state as GetTransactionSuccess).transactions;

  //     final totalIncome = transactions.fold<double>(
  //       0,
  //       (sum, item) => item.type == TransactionType.INCOME && item.accountId == accountId
  //           ? sum + (item.amount ?? 0.0)
  //           : item.type == TransactionType.TRANSFER && item.accountFromId == accountId
  //           ? sum + (item.amount ?? 0.0)
  //           : sum,
  //     );

  //     return totalIncome;
  //   }
  //   return 0;
  // }

  // double getTotalExpenseByAccountId({required String accountId}) {
  //   if (state is GetTransactionSuccess) {
  //     final transactions = (state as GetTransactionSuccess).transactions;

  //     final totalExpense = transactions.fold<double>(
  //       0,
  //       (sum, item) => item.type == TransactionType.EXPENSE && item.accountId == accountId
  //           ? sum + (item.amount ?? 0.0)
  //           : item.type == TransactionType.TRANSFER && item.accountToId == accountId
  //           ? sum + (item.amount ?? 0.0)
  //           : sum,
  //     );

  //     return totalExpense;
  //   }
  //   return 0;
  // }
