import 'package:expenseapp/core/app/all_import_file.dart';

@immutable
sealed class GetSoftDeleteTransactionsState {}

final class GetSoftDeleteTransactionsInitial extends GetSoftDeleteTransactionsState {}

final class GetSoftDeleteTransactionsSuccess extends GetSoftDeleteTransactionsState {
  GetSoftDeleteTransactionsSuccess(this.transactions);
  final List<Transaction> transactions;
}

final class GetSoftDeleteTransactionsFailure extends GetSoftDeleteTransactionsState {
  GetSoftDeleteTransactionsFailure(this.errorMessage);
  final String errorMessage;
}

final class GetSoftDeleteTransactionsLoading extends GetSoftDeleteTransactionsState {}

class GetSoftDeleteTransactionsCubit extends Cubit<GetSoftDeleteTransactionsState> {
  GetSoftDeleteTransactionsCubit() : super(GetSoftDeleteTransactionsInitial());

  TransactionLocalData transactionLocalData = TransactionLocalData();

  Future<void> getSoftDeleteTransactions() async {
    emit(GetSoftDeleteTransactionsLoading());
    Future.delayed(const Duration(seconds: 2), () {
      try {
        final transactions = transactionLocalData.getSoftDeletedTransaction();
        emit(GetSoftDeleteTransactionsSuccess(transactions));
      } catch (e) {
        emit(GetSoftDeleteTransactionsFailure(e.toString()));
      }
    });
  }

  Future<void> updateSoftDeleteTransactionLocally({required Transaction transaction}) async {
    transactionLocalData.deleteTransactionPermanently(transaction: transaction);
    if (state is GetSoftDeleteTransactionsSuccess) {
      final transactions = (state as GetSoftDeleteTransactionsSuccess).transactions..removeWhere((t) => t.id == transaction.id);

      emit(GetSoftDeleteTransactionsSuccess(transactions));
    }
  }

  Future<void> updateSoftDeleteTransactionAfterDeleteCategory({required String categoryId}) async {
    transactionLocalData.softDeleteTransactionDeleteByCategoryId(categoryId: categoryId);
    if (state is GetSoftDeleteTransactionsSuccess) {
      final transactions = (state as GetSoftDeleteTransactionsSuccess).transactions;
      final index = transactions.indexWhere((e) => e.categoryId == categoryId);

      if (index != -1) {
        transactions[index].categoryId = '';
        emit(GetSoftDeleteTransactionsSuccess(transactions));
      }
    }
  }

  Future<void> updateSoftDeleteTransactionAfterDeleteAccount({required String accountId, required String accountFromId, required String accountToId}) async {
    transactionLocalData.softDeleteTransactionDeleteByAccountId(accountId: accountId, accountFromId: accountFromId, accountToId: accountToId);
    if (state is GetSoftDeleteTransactionsSuccess) {
      final transactions = (state as GetSoftDeleteTransactionsSuccess).transactions..removeWhere((t) => t.accountId == accountId || t.accountFromId == accountFromId || t.accountToId == accountToId);
      emit(GetSoftDeleteTransactionsSuccess(transactions));
    }
  }

  Transaction getTransaction({required String partyTransactionId}) {
    if (state is GetSoftDeleteTransactionsSuccess) {
      final transactions = (state as GetSoftDeleteTransactionsSuccess).transactions;

      return transactions.firstWhere((t) => t.partyTransactionId == partyTransactionId);
    }
    return Transaction();
  }

  Future<void> getSoftDeleteTransactionLocally(Transaction transaction) async {
    transactionLocalData.restoreTransaction(transaction);
    if (state is GetSoftDeleteTransactionsSuccess) {
      final transactions = (state as GetSoftDeleteTransactionsSuccess).transactions..removeWhere((t) => t.id == transaction.id);

      emit(GetSoftDeleteTransactionsSuccess(transactions));
    }
  }
}
