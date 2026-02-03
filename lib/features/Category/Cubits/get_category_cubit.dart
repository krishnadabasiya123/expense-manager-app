import 'package:expenseapp/core/app/all_import_file.dart';

@immutable
sealed class GetCategoryState {}

final class GetCategoryInitial extends GetCategoryState {}

final class GetCategoryLoading extends GetCategoryState {}

final class GetCategorySuccess extends GetCategoryState {
  GetCategorySuccess(this.category);
  final List<Category> category;

  GetCategorySuccess copyWith({List<Category>? category}) {
    return GetCategorySuccess(category ?? this.category);
  }
}

final class GetCategoryFailure extends GetCategoryState {
  GetCategoryFailure(this.errorMessage);
  final String errorMessage;
}

class GetCategoryCubit extends Cubit<GetCategoryState> {
  GetCategoryCubit() : super(GetCategoryInitial());

  final CategoryLocalStorage categoryLocalStorage = CategoryLocalStorage();

  Future<void> getCategory() async {
    emit(GetCategoryLoading());
    try {
      categoryLocalStorage.initDefaults();
      final category = categoryLocalStorage.getAll();
      emit(GetCategorySuccess(category));
    } catch (e) {
      emit(GetCategoryFailure(e.toString()));
    }
  }

  List<Category> searchCaterory({String? keyword = ''}) {
    if (state is GetCategorySuccess) {
      final category = (state as GetCategorySuccess).category.where((element) => element.name.toLowerCase().contains(keyword!.toLowerCase())).toList();
      return category;
    }
    return [];
  }

  String getCategoryName(String id) {
    if (state is GetCategorySuccess) {
      final category = (state as GetCategorySuccess).category;

      final index = category.indexWhere((e) => e.id == id);
      if (index == -1) return '';

      return category[index].name;
    }
    return '';
  }

  Future<void> addCategoryLocally(List<Category> category) async {
    if (state is GetCategorySuccess) {
      final oldData = (state as GetCategorySuccess).category;
      final newData = <Category>[...oldData, ...category];
      saveAndEmit(newData);
      emit(GetCategorySuccess(newData));
    }
  }

  Future<void> deleteCategoryLocally(Category category) async {
    if (state is GetCategorySuccess) {
      final oldData = (state as GetCategorySuccess).category..removeWhere((element) => element.id == category.id);
      saveAndEmit(oldData);
      emit(GetCategorySuccess(oldData));
    }
  }

  Future<void> updateCategoryLocally(Category category) async {
    if (state is GetCategorySuccess) {
      final currentState = state as GetCategorySuccess;
      final updateList = List<Category>.from(currentState.category);
      final index = updateList.indexWhere((element) => element.id == category.id);

      if (index != -1) {
        updateList[index] = category;
        saveAndEmit(updateList);

        emit(currentState.copyWith(category: updateList));
      }
    }
  }

  void saveAndEmit(List<Category> list) {
    categoryLocalStorage.saveCategory(list);
    emit(GetCategorySuccess(list));
  }

  void reorder(List<Category> updatedList) {
    saveAndEmit(updatedList);
  }

  List<Map<String, dynamic>> getCatgoryList() {
    if (state is GetCategorySuccess) {
      final category = (state as GetCategorySuccess).category;

      final list = category.map((acc) {
        return {
          'value': acc.id,
          'label': acc.name,
          'enabled': true,
        };
      }).toList();

      return list;
    }
    return [];
  }

  List<Map<String, dynamic>> getCatgoryListWithSelected() {
    if (state is GetCategorySuccess) {
      return (state as GetCategorySuccess).category.map((cat) {
        return {
          'id': cat.id,
          'name': cat.name,
          'selected': false,
        };
      }).toList();
    }
    return [];
  }
}
