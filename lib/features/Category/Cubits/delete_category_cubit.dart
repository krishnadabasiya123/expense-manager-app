import 'package:expenseapp/core/app/all_import_file.dart';

@immutable
sealed class DeleteCategoryState {}

final class DeleteCategoryInitial extends DeleteCategoryState {}

final class DeleteCategoryLoading extends DeleteCategoryState {}

final class DeleteCategorySuccess extends DeleteCategoryState {
  DeleteCategorySuccess(this.category);
  final Category category;
}

final class DeleteCategoryFailure extends DeleteCategoryState {
  DeleteCategoryFailure(this.errorMessage);
  final String errorMessage;
}

class DeleteCategoryCubit extends Cubit<DeleteCategoryState> {
  DeleteCategoryCubit() : super(DeleteCategoryInitial());

  final CategoryLocalStorage categoryLocalStorage = CategoryLocalStorage();

  Future<void> deleteCategory(Category category) async {
    emit(DeleteCategoryLoading());
    Future.delayed(const Duration(seconds: 0), () async {
      try {
        await categoryLocalStorage.deleteCategory(category);
        emit(DeleteCategorySuccess(category));
      } catch (e) {
        emit(DeleteCategoryFailure(e.toString()));
      }
    });
  }
}
