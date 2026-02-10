import 'package:bloc/bloc.dart';
import 'package:expenseapp/features/Party/LocalStorage/party_local_storage.dart';
import 'package:expenseapp/features/Party/Model/Party.dart';
import 'package:expenseapp/features/Party/Model/PartyTransaction.dart';
import 'package:meta/meta.dart';

@immutable
sealed class UpdatePartyState {}

final class UpdatePartyInitial extends UpdatePartyState {}

final class UpdatePartyLoading extends UpdatePartyState {}

final class UpdatePartySuccess extends UpdatePartyState {
  UpdatePartySuccess(this.party);
  final Party party;
}

final class UpdatePartyFailure extends UpdatePartyState {
  UpdatePartyFailure(this.message);
  final String message;
}

class UpdatePartyCubit extends Cubit<UpdatePartyState> {
  UpdatePartyCubit() : super(UpdatePartyInitial());

  final PartyLocalData partyLocalData = PartyLocalData();

  Future<void> updateParty(
    Party party, {
    String createdAt = '',
    String updatedAt = '',
    String id = '',
    String name = '',
    List<PartyTransaction> transaction = const [],
  }) async {
    emit(UpdatePartyLoading());
    Future.delayed(const Duration(seconds: 0), () async {
      try {
        party
          ..id = id
          ..name = name
          ..createdAt = createdAt
          ..updatedAt = updatedAt
          ..transaction = transaction;
        await partyLocalData.updateParty(party);
        emit(UpdatePartySuccess(party));
      } catch (e) {
        emit(UpdatePartyFailure(e.toString()));
      }
    });
  }
}
