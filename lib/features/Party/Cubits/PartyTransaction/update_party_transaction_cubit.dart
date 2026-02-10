import 'package:expenseapp/core/app/all_import_file.dart';

@immutable
sealed class UpdatePartyTransactionState {}

final class UpdatePartyTransactionInitial extends UpdatePartyTransactionState {}

final class UpdatePartyTransactionLoading extends UpdatePartyTransactionState {}

final class UpdatePartyTransactionSuccess extends UpdatePartyTransactionState {
  UpdatePartyTransactionSuccess(this.transaction);
  final PartyTransaction transaction;
}

final class UpdatePartyTransactionFailure extends UpdatePartyTransactionState {
  UpdatePartyTransactionFailure(this.errorMessage);
  final String errorMessage;
}

class UpdatePartyTransactionCubit extends Cubit<UpdatePartyTransactionState> {
  UpdatePartyTransactionCubit() : super(UpdatePartyTransactionInitial());

  final PartyTransactionLocalData partyTransactionLocalData = PartyTransactionLocalData();

  Future<void> updatePartyTransaction({
    required PartyTransaction transaction,
    String? partyId,
  }) async {
    emit(UpdatePartyTransactionLoading());
    Future.delayed(const Duration(seconds: 0), () async {
      try {
        await partyTransactionLocalData.updatePartyTransaction(transaction: transaction, partyId: partyId);
        emit(UpdatePartyTransactionSuccess(transaction));
      } catch (e) {
        emit(UpdatePartyTransactionFailure(e.toString()));
      }
    });
  }
}
