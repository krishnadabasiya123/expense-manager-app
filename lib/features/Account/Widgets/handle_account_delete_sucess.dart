import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/Restore/Cubit/get_soft_delete_party_transaction_cubit.dart';
import 'package:expenseapp/features/Restore/Cubit/get_soft_delete_transactions_cubit.dart';
import 'package:flutter/material.dart';

void handleAccountDeleteSuccess(BuildContext context, Account account) {
  final accountId = account.id;

  context.read<GetAccountCubit>().deleteAccountLocally(account: account);

  context.read<GetTransactionCubit>()
    ..deleteTransacionLocally(Transaction(id: accountId))
    ..deleteTransactionWhenDeleteAccount(
      accountId: accountId,
      accountFromId: accountId,
      accountToId: accountId,
    );

  context.read<GetSoftDeleteTransactionsCubit>()
      .updateSoftDeleteTransactionAfterDeleteAccount(
    accountId: accountId,
    accountFromId: accountId,
    accountToId: accountId,
  );

  context.read<GetSoftDeletePartyTransactionCubit>()
      .updateSoftDeletePartyTransactionAfterDeleteAccount(
    accountId: accountId,
  );

  context.read<GetPartyCubit>()
      .deletePartyTransactionWhenDeleteAccount(accountId: accountId);

  UiUtils.showCustomSnackBar(
    context: context,
    errorMessage: context.tr('accountDeleteSucess'),
  );

  Navigator.pop(context);
}
