import 'package:bloc/bloc.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:meta/meta.dart';

@immutable
sealed class RestorePartyTransactionState {}

final class RestorePartyTransactionInitial extends RestorePartyTransactionState {}

final class RestorePartyTransactionSuccess extends RestorePartyTransactionState {
  RestorePartyTransactionSuccess(this.transaction);
  final PartyTransaction transaction;
}

final class RestorePartyTransactionFailure extends RestorePartyTransactionState {
  RestorePartyTransactionFailure(this.errorMessage);
  final String errorMessage;
}

final class RestorePartyTransactionLoading extends RestorePartyTransactionState {}

class RestorePartyTransactionCubit extends Cubit<RestorePartyTransactionState> {
  RestorePartyTransactionCubit() : super(RestorePartyTransactionInitial());

  final PartyTransactionLocalData partyTransactionLocalData = PartyTransactionLocalData();

  Future<void> restorePartyTransaction(PartyTransaction transaction) async {
    emit(RestorePartyTransactionLoading());
    Future.delayed(const Duration(seconds: 2), () {
      try {
         partyTransactionLocalData.restoreSoftDeletedPartyTransaction(transaction: transaction);
        emit(RestorePartyTransactionSuccess(transaction));
      } catch (e) {
        emit(RestorePartyTransactionFailure(e.toString()));
      }
    });
  }
}
