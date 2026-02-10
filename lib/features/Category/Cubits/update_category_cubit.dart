import 'package:bloc/bloc.dart';
import 'package:expenseapp/core/app/all_import_file.dart';

@immutable
sealed class UpdateCategoryState {}

final class UpdateCategoryInitial extends UpdateCategoryState {}

final class UpdateCategoryLoading extends UpdateCategoryState {}

final class UpdateCategorySuccess extends UpdateCategoryState {
  UpdateCategorySuccess(this.category);
  final Category category;
}

final class UpdateCategoryFailure extends UpdateCategoryState {
  UpdateCategoryFailure(this.errorMessage);
  final String errorMessage;
}

class UpdateCategoryCubit extends Cubit<UpdateCategoryState> {
  UpdateCategoryCubit() : super(UpdateCategoryInitial());

  final CategoryLocalStorage categoryLocalStorage = CategoryLocalStorage();

  Future<void> updateCategory(Category category) async {
    emit(UpdateCategoryLoading());
    Future.delayed(const Duration(seconds: 0), () async {
      try {
        await categoryLocalStorage.updateCategory(category);
        emit(UpdateCategorySuccess(category));
      } catch (e) {
        emit(UpdateCategoryFailure(e.toString()));
      }
    });
  }
}
