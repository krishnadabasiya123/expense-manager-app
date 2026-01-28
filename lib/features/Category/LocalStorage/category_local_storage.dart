import 'package:expenseapp/core/app/all_import_file.dart';

class CategoryLocalStorage {
  Box get _box => Hive.box('categoryBox');

  static const String key = 'categories';
  static const String boxName = 'categoryBox';

  static Future<void> init() async {
    Hive.registerAdapter(CategoryAdapter());
    await Hive.openBox(boxName);
  }

  void saveCategory(List<Category> categories) {
    _box.put(key, categories);
  }

  List<Category> getAll() {
    return List<Category>.from(_box.get(key, defaultValue: <Category>[]) as List<dynamic>);
  }

  String getNextId() {
    final catgoryId = 'C'.withDateTimeMillisRandom();
    return catgoryId;
  }

  void initDefaults() {
    if (!_box.containsKey(key)) {
      saveCategory([Category(id: getNextId(), name: 'General', isDefault: true), Category(id: getNextId(), name: 'Study', isDefault: true), Category(id: getNextId(), name: 'Work', isDefault: true)]);
    }
  }

  Future<void> updateCategory(Category updated) async {
    final list = getAll();

    final index = list.indexWhere((e) => e.id == updated.id);

    if (index != -1) {
      list[index] = updated;
      await _box.put(key, list);
    }
  }

  Future<void> deleteCategory(Category category) async {
    final list = getAll()..removeWhere((e) => e.id == category.id);

    await _box.put(key, list);
  }
}
