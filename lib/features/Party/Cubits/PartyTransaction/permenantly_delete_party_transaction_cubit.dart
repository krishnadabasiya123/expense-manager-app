import 'package:bloc/bloc.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:meta/meta.dart';

@immutable
sealed class PermenantlyDeletePartyTransactionState {}

final class PermenantlyDeletePartyTransactionInitial extends PermenantlyDeletePartyTransactionState {}

final class PermenantlyDeletePartyTransactionLoading extends PermenantlyDeletePartyTransactionState {}

final class PermenantlyDeletePartyTransactionSuccess extends PermenantlyDeletePartyTransactionState {
  PermenantlyDeletePartyTransactionSuccess(this.transaction);
  final PartyTransaction transaction;
}

final class PermenantlyDeletePartyTransactionFailure extends PermenantlyDeletePartyTransactionState {
  PermenantlyDeletePartyTransactionFailure(this.errorMessage);
  final String errorMessage;
}

class PermenantlyDeletePartyTransactionCubit extends Cubit<PermenantlyDeletePartyTransactionState> {
  PermenantlyDeletePartyTransactionCubit() : super(PermenantlyDeletePartyTransactionInitial());

  final PartyTransactionLocalData partyTransactionLocalData = PartyTransactionLocalData();

  Future<void> permenantlyDeletePartyTransaction({required PartyTransaction transaction}) async {
    emit(PermenantlyDeletePartyTransactionLoading());
    Future.delayed(const Duration(seconds: 2), () {
      try {
        partyTransactionLocalData.permenantlyDeletePartyTransactionById(partyTransactionId: transaction.id);
        emit(PermenantlyDeletePartyTransactionSuccess(transaction));
      } catch (e) {
        emit(PermenantlyDeletePartyTransactionFailure(e.toString()));
      }
    });
  }
}
