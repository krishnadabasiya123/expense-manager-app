import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

@immutable
sealed class DeleteBudgetState {}

final class DeleteBudgetInitial extends DeleteBudgetState {}

class DeleteBudgetCubit extends Cubit<DeleteBudgetState> {
  DeleteBudgetCubit() : super(DeleteBudgetInitial());
}
