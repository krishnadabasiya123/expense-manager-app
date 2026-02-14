import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Enums/RecurringTransactionStatus.dart';
import 'package:expenseapp/features/RecurringTransaction/LocalStorage/recurring_transaction_local_data.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Recurring.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/RecurringTransaction.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
sealed class UpdateRecurringTransactionState {}

final class UpdateRecurringTransactionInitial extends UpdateRecurringTransactionState {}

final class UpdateRecurringTransactionLoading extends UpdateRecurringTransactionState {}


final class UpdateRecurringTransactionSuccess extends UpdateRecurringTransactionState {
  UpdateRecurringTransactionSuccess({
    this.transaction,
    this.status,
    this.recurringTransaction,
    this.transactionId,
  });
  final Recurring? transaction;
  final RecurringTransactionStatus? status;
  final RecurringTransaction? recurringTransaction;
  final String? transactionId;

  UpdateRecurringTransactionSuccess copyWith({
    Recurring? transaction,
    RecurringTransactionStatus? status,
    RecurringTransaction? recurringTransaction,
    String? transactionId,
  }) {
    return UpdateRecurringTransactionSuccess(
      transaction: transaction ?? this.transaction,
      status: status ?? this.status,
      recurringTransaction: recurringTransaction ?? this.recurringTransaction,
      transactionId: transactionId ?? this.transactionId,
    );
  }
}

final class UpdateRecurringTransactionFailure extends UpdateRecurringTransactionState {
  UpdateRecurringTransactionFailure(this.errorMessage);
  final String errorMessage;
}

class UpdateRecurringTransactionCubit extends Cubit<UpdateRecurringTransactionState> {
  UpdateRecurringTransactionCubit() : super(UpdateRecurringTransactionInitial());

  RecurringTransactionLocalData recurringTransactionLocalData = RecurringTransactionLocalData();

  Future<void> changeRecurringTransactionStatus({
    required Recurring transaction,
    required RecurringTransactionStatus status,
    required RecurringTransaction recurringTransaction,
    required String transactionId,
  }) async {
    emit(UpdateRecurringTransactionLoading());
    Future.delayed(const Duration(seconds: 0), () {
      try {
        //recurringTransactionLocalData.updateRecurringTransactionByStatus(recurring: transaction, status: status, recurringTransactionId: recurringTransactionId, transactionId: transactionId);
        emit(
          UpdateRecurringTransactionSuccess(
            transaction: transaction,
            status: status,
            recurringTransaction: recurringTransaction,
            transactionId: transactionId,
          ),
        );
      } catch (e) {
        emit(UpdateRecurringTransactionFailure(e.toString()));
      }
    });
  }

  Future<void> updateRecurringTransaction({required String recurringId, required String title, required double amount, required String endDate, String? accountId, String? categoryId , List<ImageData>? image}) async {
    emit(UpdateRecurringTransactionLoading());
    Future.delayed(const Duration(seconds: 0), () async {
      try {
        final recurringTransaction = await recurringTransactionLocalData.updateRecurringTitleAmtDate(
          recurring: recurringId,
          title: title,
          amount: amount,
          endDate: endDate,
          accountId: accountId,
          categoryId: categoryId,
          image : image,
        );
        emit(UpdateRecurringTransactionSuccess(transaction: recurringTransaction));
      } catch (e) {
        emit(UpdateRecurringTransactionFailure(e.toString()));
      }
    });
  }
}
