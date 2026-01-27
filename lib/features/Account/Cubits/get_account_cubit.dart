
import 'package:expenseapp/core/app/all_import_file.dart';


@immutable
sealed class GetAccountState {}

final class GetAccountInitial extends GetAccountState {}

final class GetAccountSuccess extends GetAccountState {
  GetAccountSuccess(this.account);
  final List<Account> account;

  GetAccountSuccess copyWith({List<Account>? account}) {
    return GetAccountSuccess(account ?? this.account);
  }
}

final class GetAccountFailure extends GetAccountState {
  GetAccountFailure(this.errorMessage);
  final String errorMessage;
}

final class GetAccountLoading extends GetAccountState {}

class GetAccountCubit extends Cubit<GetAccountState> {
  GetAccountCubit() : super(GetAccountInitial());

  final AccountLocalStorage accountLocalStorage = AccountLocalStorage();

  Future<void> getAccount() async {
    emit(GetAccountLoading());
    try {
      final account = accountLocalStorage.getAccount();
      final lastAcc = Account(id: 'last', name: '', amount: 0);
      final accountData = [...account, lastAcc];
      emit(GetAccountSuccess(accountData));
    } catch (e) {
      emit(GetAccountFailure(e.toString()));
    }
  }

  Future<void> addAccountLocally({required Account account}) async {
    if (state is GetAccountSuccess) {
      final oldData = (state as GetAccountSuccess).account;
      final newData = <Account>[account, ...oldData];
      emit(GetAccountSuccess(newData));
    }
  }

  Future<void> deleteAccountLocally({required Account account}) async {
    if (state is GetAccountSuccess) {
      final oldData = (state as GetAccountSuccess).account..removeWhere((element) => element.id == account.id);
      emit(GetAccountSuccess(oldData));
    }
  }

  Future<void> updateAccountLocally({required Account account}) async {
    try {
      if (state is GetAccountSuccess) {
        final currentState = state as GetAccountSuccess;
        final updateList = List<Account>.from(currentState.account);
        final index = updateList.indexWhere((element) => element.id == account.id);

        if (index != -1) {
          updateList[index] = account;

          emit(currentState.copyWith(account: updateList));
        }
      }
    } catch (e) {
      emit(GetAccountFailure(e.toString()));
    }
  }

  String getAccountName({required String id}) {
    if (state is GetAccountSuccess) {
      final category = (state as GetAccountSuccess).account;

      final index = category.indexWhere((e) => e.id == id);

      if (index == -1) return '';
      return category[index].name;
    }
    return '';
  }

  List<Map<String, dynamic>> getAccountList() {
    if (state is GetAccountSuccess) {
      final account = (state as GetAccountSuccess).account;

      final list = account.map((acc) {
        return {
          'value': acc.id,
          'label': acc.name,
          'enabled': true,
        };
      }).toList();

      if (list.isNotEmpty) {
        list.removeLast();
      }

      return list;
    }
    return [];
  }

  double getTotalAccountBalance({required TransactionType type, required String? accountId, required double amount}) {
    if (state is GetAccountSuccess) {
      final data = (state as GetAccountSuccess).account;

      final isExpense = type == TransactionType.EXPENSE;

      final totalBalance = data.fold<double>(
        0,
        (sum, item) => item.id == accountId ? sum + (isExpense ? (item.amount - amount) : (item.amount + amount)) : sum,
      );

      emit(GetAccountSuccess(data));

      return totalBalance;
    }
    return 0;
  }
}
