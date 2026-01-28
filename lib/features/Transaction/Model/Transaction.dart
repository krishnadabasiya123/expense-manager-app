import 'package:expenseapp/core/app/all_import_file.dart';

part 'Transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  Transaction({
    this.id = '',
    this.date = '',
    this.title = '',
    this.type = TransactionType.NONE,
    this.amount = 0,
    this.description = '',
    this.categoryId = '',
    this.time = '',
    this.accountId = '',
    this.recurringId = '',
    this.accountFromId = '',
    this.accountToId = '',
    this.image = const [],
    this.partyId = '',
    this.partyTransactionId = '',
    this.addFromType = TransactionType.NONE,
    this.recurringTransactionId = '',
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  String date;

  @HiveField(2)
  String time;

  @HiveField(3)
  String title;

  @HiveField(4)
  TransactionType type;

  @HiveField(5)
  double amount;

  @HiveField(6)
  String description;

  @HiveField(7)
  String categoryId;

  @HiveField(8)
  String accountId;

  @HiveField(9)
  String recurringId;

  @HiveField(10)
  String accountFromId;

  @HiveField(11)
  String accountToId;

  @HiveField(12)
  List<ImageData> image;

  @HiveField(13)
  String partyId;

  @HiveField(14)
  String partyTransactionId;

  @HiveField(15)
  TransactionType addFromType;

  @HiveField(16)
  String recurringTransactionId;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'title': title,
      'type': type,
      'amount': amount,
      'description': description,
      'categoryId': categoryId,
      'time': time,
      'accountId': accountId,
      'recurringId': recurringId,
      'accountFromId': accountFromId,
      'accountToId': accountToId,
      'image': image,
      'partyId': partyId,
      'partyTransactionId': partyTransactionId,
      'addFromType': addFromType,
      'recurringTransactionId': recurringTransactionId,
    };
  }

  Transaction copyWith({
    String? id,
    String? date,
    String? time,
    String? title,
    TransactionType? type,
    double? amount,
    String? description,
    String? categoryId,
    String? accountId,
    String? recurringId,
    String? accountFromId,
    String? accountToId,
    List<ImageData>? image,
    String? partyId,
    String? partyTransactionId,
    TransactionType? addFromType,
    String? recurringTransactionId,
  }) {
    return Transaction(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      title: title ?? this.title,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      recurringId: recurringId ?? this.recurringId,
      accountFromId: accountFromId ?? this.accountFromId,
      accountToId: accountToId ?? this.accountToId,
      image: image ?? this.image,
      partyId: partyId ?? this.partyId,
      partyTransactionId: partyTransactionId ?? this.partyTransactionId,
      addFromType: addFromType ?? this.addFromType,
      recurringTransactionId: recurringTransactionId ?? this.recurringTransactionId,
    );
  }
}

extension TransactionFiltering on List<Transaction> {
  // Filter by Type
  List<Transaction> filterByType(TransactionType? type) {
    if (type == TransactionType.NONE || type == TransactionType.ALL) return this;
    return where((t) => t.type == type).toList();
  }

  // Filter by Search
  List<Transaction> filterBySearch(String query, List<Category> categories) {
    if (query.isEmpty) return this;
    final map = {for (final c in categories) c.id: c.name.toLowerCase()};
    return where((t) => (map[t.categoryId] ?? '').contains(query.toLowerCase())).toList();
  }

  // Filter by Month/Year
  List<Transaction> filterByMonth(DateTime? date) {
    if (date == null) return this;
    return where((t) {
      final txDate = DateFormat('dd.MM.yyyy').parse(t.date);
      return txDate.month == date.month && txDate.year == date.year;
    }).toList();
  }

  // Sort Descending
  List<Transaction> sortByDate() {
    // We create a copy so we don't mutate the original list
    return [...this]..sort((a, b) {
      return b.date.split('.').reversed.join().compareTo(a.date.split('.').reversed.join());
    });
  }

  // Take count

  // Group into List<Map>
  List<Map<String, dynamic>> groupByDate() {
    final grouped = <String, List<Transaction>>{};
    for (final t in this) {
      grouped.putIfAbsent(t.date, () => []).add(t);
    }
    return grouped.entries
        .map(
          (e) => {
            'date': e.key,
            'transactions': e.value,
          },
        )
        .toList();
  }

  List<Transaction> maybeTake(int count) {
    if (count == 0) return this;
    return take(count).toList();
  }
}
