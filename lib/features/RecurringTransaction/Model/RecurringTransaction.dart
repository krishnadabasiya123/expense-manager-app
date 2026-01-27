import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/RecurringTransaction/Enums/RecurringTransactionStatus.dart';

part 'RecurringTransaction.g.dart';

@HiveType(typeId: 9)
class RecurringTransaction extends HiveObject {
  RecurringTransaction({this.recurringTransactionId, this.transactionId, this.recurringId, this.scheduleDate, this.status});

  @HiveField(0)
  String? recurringTransactionId;

  @HiveField(1)
  String? transactionId;

  @HiveField(2)
  String? recurringId;

  @HiveField(3)
  String? scheduleDate;

  @HiveField(4)
  RecurringTransactionStatus? status;

  Map<String, dynamic> toJson() {
    return {'recurringTransactionId': recurringTransactionId, 'transactionId': transactionId, 'recurringId': recurringId, 'scheduleDate': scheduleDate, 'status': status};
  }

  RecurringTransaction copyWith({
    String? recurringTransactionId,
    String? transactionId,
    String? recurringId,
    String? scheduleDate,
    RecurringTransactionStatus? status,
  }) {
    return RecurringTransaction(
      recurringTransactionId: recurringTransactionId ?? this.recurringTransactionId,
      transactionId: transactionId ?? this.transactionId,
      recurringId: recurringId ?? this.recurringId,
      scheduleDate: scheduleDate ?? this.scheduleDate,
      status: status ?? this.status,
    );
  }
}
