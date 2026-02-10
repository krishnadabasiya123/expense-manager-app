import 'package:bloc/bloc.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:meta/meta.dart';

@immutable
sealed class GetSoftDeletePartyTransactionState {}

final class GetSoftDeletePartyTransactionInitial extends GetSoftDeletePartyTransactionState {}

final class GetSoftDeletePartyTransactionLoading extends GetSoftDeletePartyTransactionState {}

final class GetSoftDeletePartyTransactionSuccess extends GetSoftDeletePartyTransactionState {
  GetSoftDeletePartyTransactionSuccess(this.transactions);
  final List<PartyTransaction> transactions;

  GetSoftDeletePartyTransactionSuccess copyWith({List<PartyTransaction>? transactions}) {
    return GetSoftDeletePartyTransactionSuccess(transactions ?? this.transactions);
  }
}

final class GetSoftDeletePartyTransactionFailure extends GetSoftDeletePartyTransactionState {
  GetSoftDeletePartyTransactionFailure(this.errorMessage);
  final String errorMessage;
}

class GetSoftDeletePartyTransactionCubit extends Cubit<GetSoftDeletePartyTransactionState> {
  GetSoftDeletePartyTransactionCubit() : super(GetSoftDeletePartyTransactionInitial());

  final PartyTransactionLocalData partyTransactionLocalData = PartyTransactionLocalData();

  void getSoftDeletePartyTransaction() {
    emit(GetSoftDeletePartyTransactionLoading());
    try {
      final transactions = partyTransactionLocalData.getSoftDeletedPartytransaction();

      emit(GetSoftDeletePartyTransactionSuccess(transactions));
    } catch (e) {
      emit(GetSoftDeletePartyTransactionFailure(e.toString()));
    }
  }

  Future<void> updateSoftDeletePartyTransactionLocally({required String partyTransaactioId}) async {
    partyTransactionLocalData.permenantlyDeletePartyTransactionById(partyTransactionId: partyTransaactioId);
    if (state is GetSoftDeletePartyTransactionSuccess) {
      final transactions = (state as GetSoftDeletePartyTransactionSuccess).transactions..removeWhere((t) => t.id == partyTransaactioId);

      emit(GetSoftDeletePartyTransactionSuccess(transactions));
    }
  }

  Future<void> updateSoftDeletePartyTransactionAfterDeleteCategory({required String categoryId}) async {
    partyTransactionLocalData.softDeletePartyTransactionByCategoryId(categoryId: categoryId);
    if (state is GetSoftDeletePartyTransactionSuccess) {
      final transactions = (state as GetSoftDeletePartyTransactionSuccess).transactions;
      for (final transaction in transactions) {
        if (transaction.category == categoryId) {
          transaction.category = '';
        }
        emit(GetSoftDeletePartyTransactionSuccess(transactions));
      }
    }
  }

  Future<void> updateSoftDeletePartyTransactionAfterDeleteAccount({required String accountId}) async {
    partyTransactionLocalData.softDeletePartyTransactionDeleteByAccountId(accountId: accountId);
    if (state is GetSoftDeletePartyTransactionSuccess) {
      final transactions = (state as GetSoftDeletePartyTransactionSuccess).transactions..removeWhere((t) => t.accountId == accountId);

      emit(GetSoftDeletePartyTransactionSuccess(transactions));
    }
  }

  PartyTransaction getPartyTransaction({required String transactionId}) {
    if (state is GetSoftDeletePartyTransactionSuccess) {
      final transactions = (state as GetSoftDeletePartyTransactionSuccess).transactions;

      return transactions.firstWhere((t) => t.mainTransactionId == transactionId);
    }
    return PartyTransaction();
  }

  Future<void> getSoftDeletePartyTransactionLocally({required PartyTransaction transaction}) async {
    partyTransactionLocalData.restoreSoftDeletedPartyTransaction(transaction: transaction);
    if (state is GetSoftDeletePartyTransactionSuccess) {
      final transactions = (state as GetSoftDeletePartyTransactionSuccess).transactions..removeWhere((t) => t.id == transaction.id);

      emit(GetSoftDeletePartyTransactionSuccess(transactions));
    }
  }
}
