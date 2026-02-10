
import 'package:expenseapp/core/app/all_import_file.dart';

@immutable
sealed class AddPartyTransactionState {}

final class AddPartyTransactionInitial extends AddPartyTransactionState {}

final class AddPartyTransactionLoading extends AddPartyTransactionState {}

final class AddPartyTransactionSuccess extends AddPartyTransactionState {
  AddPartyTransactionSuccess(this.transaction);
  final PartyTransaction transaction;
}

final class AddPartyTransactionFailure extends AddPartyTransactionState {
  AddPartyTransactionFailure(this.message);
  final String message;
}

class AddPartyTransactionCubit extends Cubit<AddPartyTransactionState> {
  AddPartyTransactionCubit() : super(AddPartyTransactionInitial());

  final PartyTransactionLocalData partyTransactionLocalData = PartyTransactionLocalData();

  Future<void> addPartyTransaction({required String partyId, required PartyTransaction transaction}) async {
    emit(AddPartyTransactionLoading());
    Future.delayed(const Duration(seconds: 0), () async {
      try {
        await partyTransactionLocalData.addPartyTransaction(partyId: partyId, transaction: transaction);
        emit(AddPartyTransactionSuccess(transaction));
      } catch (e) {
        emit(AddPartyTransactionFailure(e.toString()));
      }
    });
  }
}
