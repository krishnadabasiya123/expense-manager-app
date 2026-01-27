import 'package:expenseapp/core/app/all_import_file.dart';

@immutable
sealed class AddCategoryState {}

final class AddCategoryInitial extends AddCategoryState {}

final class AddCategoryLoading extends AddCategoryState {}

final class AddCategorySuccess extends AddCategoryState {
  AddCategorySuccess(this.category);
  final List<Category> category;
}

final class AddCategoryFailure extends AddCategoryState {
  AddCategoryFailure(this.errorMessage);
  final String errorMessage;
}

class AddCategoryCubit extends Cubit<AddCategoryState> {
  AddCategoryCubit() : super(AddCategoryInitial());

  final CategoryLocalStorage categoryLocalStorage = CategoryLocalStorage();

  Future<void> addCategory(List<Category> category) async {
    emit(AddCategoryLoading());
    Future.delayed(const Duration(seconds: 2), () async {
      try {
        categoryLocalStorage.saveCategory(category);
        emit(AddCategorySuccess(category));
      } catch (e) {
        emit(AddCategoryFailure(e.toString()));
      }
    });
  }
}
