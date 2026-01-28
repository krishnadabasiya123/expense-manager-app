import 'package:expenseapp/core/app/all_import_file.dart';

part 'Category.g.dart';

@HiveType(typeId: 6)
class Category extends HiveObject {
  Category({this.id = '', this.name = '', this.isDefault = false});
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  final bool isDefault;

  Category copyWith({String? name}) {
    return Category(id: id, name: name ?? this.name, isDefault: isDefault);
  }
}
