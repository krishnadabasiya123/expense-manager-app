import 'dart:developer';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:expenseapp/features/Party/LocalStorage/party_local_storage.dart';
import 'package:expenseapp/features/Party/LocalStorage/party_transaction_local_storage.dart';
import 'package:expenseapp/features/Party/Model/Party.dart';
import 'package:expenseapp/features/Party/Model/PartyTransaction.dart';
import 'package:expenseapp/features/Transaction/Model/enums/TransactionType.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

@immutable
sealed class GetPartyState {}

final class GetPartyInitial extends GetPartyState {}

final class GetPartyLoading extends GetPartyState {}

final class GetPartySuccess extends GetPartyState {
  GetPartySuccess(this.party);
  final List<Party> party;

  GetPartySuccess copyWith({List<Party>? party}) {
    return GetPartySuccess(party ?? this.party);
  }
}

final class GetPartyFailure extends GetPartyState {
  GetPartyFailure(this.message);
  final String message;
}

class GetPartyCubit extends Cubit<GetPartyState> {
  GetPartyCubit() : super(GetPartyInitial());

  final PartyLocalData partyLocalData = PartyLocalData();
  final PartyTransactionLocalData partyTransactionLocalData = PartyTransactionLocalData();

  Future<void> getParty() async {
    emit(GetPartyLoading());
    try {
      final party = partyLocalData.getParty();
      emit(GetPartySuccess(party));
    } catch (e) {
      emit(GetPartyFailure(e.toString()));
    }
  }

  List<Party> getPartyBySearchName({String searchText = ''}) {
    if (state is! GetPartySuccess) return [];

    final partyList = (state as GetPartySuccess).party;

    if (searchText == '' || searchText.trim().isEmpty) {
      return partyList;
    }

    final query = searchText.toLowerCase();

    return partyList
        .where(
          (p) => p.name.toLowerCase().contains(query),
        )
        .toList();
  }

  Future<void> addPartyLocally(Party party) async {
    if (state is GetPartySuccess) {
      final oldData = (state as GetPartySuccess).party;
      final newData = [party, ...oldData];
      emit(GetPartySuccess(newData));
    }
  }

  Future<void> deletePartyLocally(Party party) async {
    if (state is GetPartySuccess) {
      final oldData = (state as GetPartySuccess).party..removeWhere((element) => element.id == party.id);

      emit(GetPartySuccess(oldData));
    }
  }

  Future<void> updatePartyLocally(Party party) async {
    try {
      if (state is GetPartySuccess) {
        final currentState = state as GetPartySuccess;
        final updateList = List<Party>.from(currentState.party);
        final index = updateList.indexWhere((element) => element.id == party.id);

        if (index != -1) {
          updateList[index] = party;

          emit(currentState.copyWith(party: updateList));
        }
      }
    } catch (e) {
      emit(GetPartyFailure(e.toString()));
    }
  }

  double totalNetWorth(List<Party> party) {
    if (state is GetPartySuccess) {
      final data = (state as GetPartySuccess).party;

      final totalCredit = data.fold<double>(
        0,
        (sum, item) => item.transaction.fold<double>(
          sum,
          (sum, item) => item.type == TransactionType.CREDIT ? sum + (item.amount) : sum,
        ),
      );

      final totalDebit = data.fold<double>(
        0,
        (sum, item) => item.transaction.fold<double>(
          sum,
          (sum, item) => item.type == TransactionType.DEBIT ? sum + (item.amount) : sum,
        ),
      );

      final totalBalance = totalCredit - totalDebit;

      return totalBalance;
    }
    return 0;
  }

  int totalTransaction(List<Party> party) {
    if (state is GetPartySuccess) {
      final data = (state as GetPartySuccess).party;

      return data.length;
    }
    return 0;
  }

  Party? getPartyById({required String partyId}) {
    if (state is GetPartySuccess) {
      final partyList = (state as GetPartySuccess).party;
      return partyList.firstWhere((p) => p.id == partyId);
    }
    return null;
  }

  List<Map<String, dynamic>> getPartyTransactionByFilterDate({
    String? partyId,
    DateTime? date,
  }) {
    if (state is GetPartySuccess) {
      final party = (state as GetPartySuccess).party;

      final partyTransaction = party.where((p) => p.id == partyId).first.transaction ?? [];

      try {
        final dateFormat = DateFormat('dd.MM.yyyy');

        final filteredTransactions =
            partyTransaction.where((item) {
              if (date != null) {
                final txnDate = dateFormat.parse(item.date);
                return txnDate.month == date.month && txnDate.year == date.year;
              }
              return true;
            }).toList()..sort((b, a) {
              return dateFormat.parse(a.date).compareTo(dateFormat.parse(b.date));
            });

        final grouped = <String, List<PartyTransaction>>{};

        for (final item in filteredTransactions) {
          grouped.putIfAbsent(item.date, () => []);
          grouped[item.date]!.add(item);
        }

        return grouped.entries.map((entry) {
          return {
            'date': entry.key,
            'transactions': entry.value,
          };
        }).toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  Future<void> addPartyTransactionLocally({required PartyTransaction transaction, required String partyId}) async {
    if (state is GetPartySuccess) {
      final partyData = (state as GetPartySuccess).party;
      final index = partyData.indexWhere((p) => p.id == partyId);

      if (index != -1) {
        final newTransactionList = List<PartyTransaction>.from(partyData[index].transaction);

        partyData[index].transaction = newTransactionList;
        emit(GetPartySuccess(partyData));
      }
    }
  }

  Future<void> updatePartyTransactinLocally({required PartyTransaction transaction, required String partyId}) async {
    if (state is GetPartySuccess) {
      final currentState = state as GetPartySuccess;
      final partyData = (state as GetPartySuccess).party;
      final index = partyData.indexWhere((p) => p.id == partyId);
      if (index != -1) {
        final updateList = List<PartyTransaction>.from(currentState.party[index].transaction);
        partyData[index].transaction = updateList;
        emit(GetPartySuccess(partyData));
      }
    }
  }

  Future<void> deletePartyTransactionLocally({required PartyTransaction transaction, required String partyId}) async {
    partyTransactionLocalData.deletePartyTransaction(transaction: transaction, partyId: partyId);

    try {
      final currentState = state;

      if (currentState is GetPartySuccess) {
        final oldData = (state as GetPartySuccess).party..removeWhere((element) => element.id == transaction.id);
        emit(GetPartySuccess(oldData));
      }
    } catch (e) {}
  }

  double getTotalPartyTransactionCredit({required String partyId}) {
    if (state is GetPartySuccess) {
      final partyData = (state as GetPartySuccess).party;
      final index = partyData.indexWhere((p) => p.id == partyId);

      if (index != -1) {
        return partyData[index].transaction.fold<double>(
          0,
          (sum, item) => item.type == TransactionType.CREDIT ? sum + (item.amount) : sum,
        );
      }
    }
    return 0;
  }

  double getTotalPartyTransactionDebit({required String partyId}) {
    if (state is GetPartySuccess) {
      final partyData = (state as GetPartySuccess).party;
      final index = partyData.indexWhere((p) => p.id == partyId);

      if (index != -1) {
        return partyData[index].transaction.fold<double>(
          0,
          (sum, item) => item.type == TransactionType.DEBIT ? sum + (item.amount) : sum,
        );
      }
    }
    return 0;
  }

  double getTotalPartyTransactionBalance({required String partyId}) {
    if (state is GetPartySuccess) {
      final partyData = (state as GetPartySuccess).party;
      final index = partyData.indexWhere((p) => p.id == partyId);

      if (index != -1) {
        return getTotalPartyTransactionCredit(partyId: partyId) - getTotalPartyTransactionDebit(partyId: partyId);
      }
    }
    return 0;
  }

  double getTotalNetBalance({required List<Party> partyId}) {
    if (state is GetPartySuccess) {
      final partyData = (state as GetPartySuccess).party;

      return partyData.fold<double>(
        0,
        (sum, item) => sum + getTotalPartyTransactionBalance(partyId: item.id),
      );
    }
    return 0;
  }

  int getTotalPartyTransactionCount() {
    if (state is GetPartySuccess) {
      final partyData = (state as GetPartySuccess).party;

      return partyData.length;
    }
    return 0;
  }

  void setNullCategoryValueInParty(String id) {
    if (state is GetPartySuccess) {
      final currentState = state as GetPartySuccess;
      final transactions = (state as GetPartySuccess).party;

      for (final party in transactions) {
        for (final transaction in party.transaction) {
          if (transaction.category == id) {
            transaction.category = '';
          }
        }
        emit(currentState.copyWith(party: transactions));
      }
    }
  }

  Future<void> saveSoftDeletedPartytransactionById({required PartyTransaction transaction}) async {
    partyTransactionLocalData.saveSoftDeletedPartytransactionById(transaction: transaction);
  }

  Future<void> deletePartyTransactionWhenDeleteAccount({
    required String accountId,
  }) async {
    await partyTransactionLocalData.updateAccountAndTransactionIdWhenAccountDelete(accountId: accountId);

    final currentState = state;

    if (currentState is GetPartySuccess) {
      final updatedPartyList = currentState.party.map((party) {
        final transactions = party.transaction;

        if (transactions.isNotEmpty) {
          for (final txn in transactions) {
            if (txn.accountId == accountId) {
              txn
                ..accountId = ''
                ..mainTransactionId = ''
                ..isMainTransaction = false;
            }
          }
        }

        return party;
      }).toList();

      emit(currentState.copyWith(party: updatedPartyList));
    }
  }

  Future<void> updateAccountNameLocallyInParty({required String accouutId}) async {
    if (state is GetPartySuccess) {
      final transactions = (state as GetPartySuccess).party;
      for (final transaction in transactions) {
        final partyTransaction = transaction.transaction;
        for (final transaction in partyTransaction) {
          if (transaction.accountId == accouutId) {
            transaction.accountId = accouutId;
          }
          emit(GetPartySuccess(transactions));
        }
      }
    }
  }

  Future<void> updateCategoryNameLocallyInParty({required String categoryId}) async {
    if (state is GetPartySuccess) {
      final transactions = (state as GetPartySuccess).party;
      for (final transaction in transactions) {
        final partyTransaction = transaction.transaction;
        for (final transaction in partyTransaction) {
          if (transaction.category == categoryId) {
            transaction.category = categoryId;
          }
          emit(GetPartySuccess(transactions));
        }
      }
    }
  }
}
