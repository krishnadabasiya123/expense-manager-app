import 'package:expenseapp/core/app/all_import_file.dart';

@immutable
sealed class DeletePartyTransactionState {}

final class DeletePartyTransactionInitial extends DeletePartyTransactionState {}

final class DeletePartyTransactionSuccess extends DeletePartyTransactionState {
  DeletePartyTransactionSuccess(this.transaction);
  final PartyTransaction transaction;
}

final class DeletePartyTransactionFailure extends DeletePartyTransactionState {
  DeletePartyTransactionFailure(this.errorMessage);
  final String errorMessage;
}

final class DeletePartyTransactionLoading extends DeletePartyTransactionState {}

class DeletePartyTransactionCubit extends Cubit<DeletePartyTransactionState> {
  DeletePartyTransactionCubit() : super(DeletePartyTransactionInitial());

  final PartyTransactionLocalData partyTransactionLocalData = PartyTransactionLocalData();

  Future<void> deletePartyTransaction({
    required PartyTransaction transaction,
    required String partyId,
  }) async {
    emit(DeletePartyTransactionLoading());
    Future.delayed(const Duration(seconds: 0), () async {
      try {
        partyTransactionLocalData.deletePartyTransaction(transaction: transaction, partyId: partyId);
        emit(DeletePartyTransactionSuccess(transaction));
      } catch (e) {
        emit(DeletePartyTransactionFailure(e.toString()));
      }
    });
  }
}
