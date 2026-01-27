import 'package:expenseapp/core/app/all_import_file.dart';

part 'Party.g.dart';

@HiveType(typeId: 7)
class Party extends HiveObject {
  Party({
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    this.name,
    this.transaction,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  List<PartyTransaction>? transaction;

  @HiveField(3)
  String createdAt;

  @HiveField(4)
  String updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'transaction': transaction?.map((t) => t.toJson()).toList() ?? [],
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Party copyWith({
    String? id,
    String? name,
    List<PartyTransaction>? transaction,
    String? createdAt,
    String? updatedAt,
  }) {
    return Party(
      id: id ?? this.id,
      name: name ?? this.name,
      transaction: transaction ?? this.transaction,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
