import 'package:bloc/bloc.dart';
import 'package:expenseapp/features/Party/LocalStorage/party_local_storage.dart';
import 'package:expenseapp/features/Party/Model/Party.dart';
import 'package:meta/meta.dart';

@immutable
sealed class AddPartyState {}

final class AddPartyInitial extends AddPartyState {}

final class AddPartyLoading extends AddPartyState {}

final class AddPartySuccess extends AddPartyState {
  AddPartySuccess(this.party);
  final Party party;
}

final class AddPartyFailure extends AddPartyState {
  AddPartyFailure(this.message);
  final String message;
}

class AddPartyCubit extends Cubit<AddPartyState> {
  AddPartyCubit() : super(AddPartyInitial());

  final PartyLocalData partyLocalData = PartyLocalData();

  Future<void> addParty(Party party) async {
    emit(AddPartyLoading());
    Future.delayed(const Duration(seconds: 0), () async {
      try {
        await partyLocalData.saveParty(party);
        emit(AddPartySuccess(party));
      } catch (e) {
        emit(AddPartyFailure(e.toString()));
      }
    });
  }
}
