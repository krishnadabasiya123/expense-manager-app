import 'package:bloc/bloc.dart';
import 'package:expenseapp/features/Party/LocalStorage/party_local_storage.dart';
import 'package:expenseapp/features/Party/Model/Party.dart';
import 'package:meta/meta.dart';

@immutable
sealed class DeletePartyState {}

final class DeletePartyInitial extends DeletePartyState {}

final class DeletePartyLoading extends DeletePartyState {}

final class DeletePartySuccess extends DeletePartyState {
  DeletePartySuccess(this.party);
  final Party party;
}

final class DeletePartyFailure extends DeletePartyState {
  DeletePartyFailure(this.message);
  final String message;
}

class DeletePartyCubit extends Cubit<DeletePartyState> {
  DeletePartyCubit() : super(DeletePartyInitial());

  final PartyLocalData partyLocalData = PartyLocalData();

  Future<void> deleteParty(Party party) async {
    emit(DeletePartyLoading());
    Future.delayed(const Duration(seconds: 0), () async {
      try {
        partyLocalData.deleteParty(party);
        emit(DeletePartySuccess(party));
      } catch (e) {
        emit(DeletePartyFailure(e.toString()));
      }
    });
  }
}
