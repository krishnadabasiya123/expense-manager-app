import 'package:expenseapp/core/app/all_import_file.dart';

@immutable
sealed class DeleteAccountState {}

final class DeleteAccountInitial extends DeleteAccountState {}

final class DeleteAccountSuccess extends DeleteAccountState {
  DeleteAccountSuccess(this.account);
  final Account account;
}

final class DeleteAccountFailure extends DeleteAccountState {
  DeleteAccountFailure(this.errorMessage);
  final String errorMessage;
}

final class DeleteAccountLoading extends DeleteAccountState {}

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit() : super(DeleteAccountInitial());

  final AccountLocalStorage accountLocalStorage = AccountLocalStorage();

  Future<void> deleteAccount({required Account account}) async {
    emit(DeleteAccountLoading());
    Future.delayed(const Duration(seconds: 5), () async {
      try {
        // accountLocalStorage.deleteAccount(account);
        emit(DeleteAccountSuccess(account));
      } catch (e) {
        emit(DeleteAccountFailure(e.toString()));
      }
    });
  }
}
