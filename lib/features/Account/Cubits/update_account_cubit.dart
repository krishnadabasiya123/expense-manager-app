import 'package:expenseapp/core/app/all_import_file.dart';

@immutable
sealed class UpdateAccountState {}

final class UpdateAccountInitial extends UpdateAccountState {}

final class UpdateAccountSuccess extends UpdateAccountState {
  UpdateAccountSuccess(this.account);
  final Account account;
}

final class UpdateAccountFailure extends UpdateAccountState {
  UpdateAccountFailure(this.errorMessage);
  final String errorMessage;
}

final class UpdateAccountLoading extends UpdateAccountState {}

class UpdateAccountCubit extends Cubit<UpdateAccountState> {
  UpdateAccountCubit() : super(UpdateAccountInitial());

  final AccountLocalStorage accountLocalStorage = AccountLocalStorage();

  Future<void> updateAccount({required Account account}) async {
    emit(UpdateAccountLoading());
    Future.delayed(const Duration(seconds: 5), () async {
      try {
        await accountLocalStorage.updateAccount(account);
        emit(UpdateAccountSuccess(account));
      } catch (e) {
        emit(UpdateAccountFailure(e.toString()));
      }
    });
  }
}
