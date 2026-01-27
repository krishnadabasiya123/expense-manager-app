import 'package:expenseapp/core/app/all_import_file.dart';

@immutable
sealed class AddAccountState {}

final class AddAccountInitial extends AddAccountState {}

final class AddAccountSuccess extends AddAccountState {
  AddAccountSuccess(this.account);
  final Account account;
}

final class AddAccountFailure extends AddAccountState {
  AddAccountFailure(this.errorMessage);
  final String errorMessage;
}

final class AddAccountLoading extends AddAccountState {}

class AddAccountCubit extends Cubit<AddAccountState> {
  AddAccountCubit() : super(AddAccountInitial());

  final AccountLocalStorage accountLocalStorage = AccountLocalStorage();

  Future<void> addAccount({required Account account}) async {
    emit(AddAccountLoading());
    Future.delayed(const Duration(seconds: 5), () async {
      try {
        await accountLocalStorage.saveAccount(account);

        emit(AddAccountSuccess(account));
      } catch (e) {
        emit(AddAccountFailure(e.toString()));
      }
    });
  }
}
