import 'package:expenseapp/core/app/all_import_file.dart';

part 'PartyTransaction.g.dart';

@HiveType(typeId: 4)
class PartyTransaction extends HiveObject {
  PartyTransaction({
    required this.id,
    this.date,
    this.type,
    this.amount,
    this.description,
    this.category,
    this.isMainTransaction = false,
    this.accountId,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.mainTransactionId,
    this.partyId,
    this.partyName,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  String? date;

  @HiveField(2)
  TransactionType? type;

  @HiveField(4)
  String? category;

  @HiveField(5)
  double? amount;

  @HiveField(6)
  String? description;

  @HiveField(7)
  bool? isMainTransaction;

  @HiveField(8)
  String? accountId;

  @HiveField(9)
  List<ImageData>? image;

  @HiveField(10)
  String? createdAt;

  @HiveField(11)
  String? updatedAt;

  @HiveField(12)
  String? mainTransactionId;

  @HiveField(13)
  String? partyId;

  @HiveField(14)
  String? partyName;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'type': type,
      'category': category,
      'amount': amount,
      'description': description,
      'isMainTransaction': isMainTransaction,
      'accountId': accountId,
      'imageUrl': image,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'mainTransactionId': mainTransactionId,
      'partyId': partyId,
      'partyName': partyName,
    };
  }
}
