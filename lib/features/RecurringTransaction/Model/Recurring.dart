import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Enums/RecurringTransactionStatus.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/RecurringTransaction.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Enums/RecurringFrequency.dart';

part 'Recurring.g.dart';

@HiveType(typeId: 8)
class Recurring extends HiveObject {
  Recurring({
    this.recurringId = '',
    this.title = '',
    this.frequency = RecurringFrequency.none,
    this.startDate = '',
    this.endDate = '',
    this.amount = 0,
    this.accountId = '',
    this.categoryId = '',
    this.type = TransactionType.NONE,
    this.recurringTransactions = const [],
    this.image = const [],
  });

  @HiveField(0)
  String recurringId;

  @HiveField(1)
  String title;

  @HiveField(2)
  RecurringFrequency frequency;

  @HiveField(3)
  String startDate;

  @HiveField(4)
  String endDate;

  @HiveField(5)
  double amount;

  @HiveField(6)
  String accountId;

  @HiveField(7)
  String categoryId;

  @HiveField(8)
  TransactionType type;

  @HiveField(9)
  List<RecurringTransaction> recurringTransactions;

  @HiveField(10)
  List<ImageData> image;

  Map<String, dynamic> toJson() {
    return {
      'recurringId': recurringId,
      'title': title,
      'frequency': frequency,
      'startDate': startDate,
      'endDate': endDate,
      'amount': amount,
      'accountId': accountId,
      'categoryId': categoryId,
      'type': type,
      'recurringTransactions': recurringTransactions.map((e) => e.toJson()).toList(),
      'image': image,
    };
  }

  Recurring copyWith({
    String? recurringId,
    String? title,
    RecurringFrequency? frequency,
    String? startDate,
    String? endDate,
    double? amount,
    String? accountId,
    String? categoryId,
    TransactionType? type,
    List<ImageData>? image,
    List<RecurringTransaction>? recurringTransactions,
  }) {
    return Recurring(
      recurringId: recurringId ?? this.recurringId,
      title: title ?? this.title,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      amount: amount ?? this.amount,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      type: type ?? this.type,
      recurringTransactions: recurringTransactions ?? this.recurringTransactions,
      image: image ?? this.image,
    );
  }
}

final List<Recurring> recurringList = [
  Recurring(
    recurringId: 'RT_2026-01-24_15-05-45_1769247345183_0JA)49',
    title: 'hy',
    frequency: RecurringFrequency.daily,
    startDate: '24.01.2026',
    endDate: '27.01.2026',
    amount: 80,
    accountId: '-1',
    categoryId: 'C_2026-01-19_14-14-17_1768812257209_YBALM7',
    type: TransactionType.EXPENSE,
    recurringTransactions: [
      RecurringTransaction(
        recurringTransactionId: 'RT_2026-01-24_15-05-45_1769247345247_2/XCPR',
        transactionId: 'TR_2026-01-24_15-05-45_1769247345247_BRFLXC',
        recurringId: 'RT_2026-01-24_15-05-45_1769247345183_0JA)49',
        scheduleDate: '24.01.2026',
        status: RecurringTransactionStatus.UPCOMING,
      ),
      RecurringTransaction(
        recurringTransactionId: 'RT_2026-01-24_15-05-45_1769247345248_408OA8',
        transactionId: 'TR_2026-01-24_15-05-45_1769247345248_^5XR54',
        recurringId: 'RT_2026-01-24_15-05-45_1769247345183_0JA)49',
        scheduleDate: '25.01.2026',
      ),
      RecurringTransaction(
        recurringTransactionId: 'RT_2026-01-24_15-05-45_1769247345248_*LULT/',
        transactionId: 'TR_2026-01-24_15-05-45_1769247345248_FUIR9%',
        recurringId: 'RT_2026-01-24_15-05-45_1769247345183_0JA)49',
        scheduleDate: '26.01.2026',
      ),
      RecurringTransaction(
        recurringTransactionId: 'RT_2026-01-24_15-05-45_1769247345248_M6UNWA',
        transactionId: 'TR_2026-01-24_15-05-45_1769247345248_(FDCLV',
        recurringId: 'RT_2026-01-24_15-05-45_1769247345183_0JA)49',
        scheduleDate: '27.01.2026',
      ),
    ],
  ),
];

// <!DOCTYPE html>
// <html class="light" lang="en"><head>
// <meta charset="utf-8"/>
// <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
// <title>Subscription History - Editable Future Transactions</title>
// <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
// <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
// <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@300;400;500;600;700&amp;display=swap" rel="stylesheet"/>
// <script id="tailwind-config">
//         tailwind.config = {
//             darkMode: "class",
//             theme: {
//                 extend: {
//                     colors: {
//                         "primary": "#2b5b88",
//                         "background-light": "#f9fafb",
//                         "background-dark": "#171f2b",
//                         "success-muted": "#e6f4ea",
//                         "success-icon": "#078838",
//                         "info-muted": "#eef2ff",
//                         "info-icon": "#2b5b88",
//                         "error-muted": "#fef2f2",
//                         "error-icon": "#dc2626",
//                         "cancel-muted": "#f3f4f6",
//                         "ios-blue": "#007AFF"
//                     },
//                     fontFamily: {
//                         "display": ["Manrope", "sans-serif"]
//                     },
//                     borderRadius: {
//                         "DEFAULT": "0.25rem",
//                         "lg": "0.5rem",
//                         "xl": "0.75rem",
//                         "full": "9999px"
//                     },
//                 },
//             },
//         }
//     </script>
// <style type="text/tailwindcss">
//         .soft-shadow {
//             box-shadow: 0 4px 20px -2px rgba(0, 0, 0, 0.05);
//         }
//         body {
//             -webkit-font-smoothing: antialiased;
//             -moz-osx-font-smoothing: grayscale;
//             min-height: 100dvh;
//         }
//         .strike-through {
//             text-decoration: line-through;
//             text-decoration-thickness: 1.5px;
//         }
//         .action-sheet-overlay {
//             background-color: rgba(0, 0, 0, 0.4);
//         }
//     </style>
// <style>
//     body {
//       min-height: max(884px, 100dvh);
//     }
//   </style>
//   </head>
// <body class="bg-background-light dark:bg-background-dark font-display text-[#121416] dark:text-white transition-colors duration-300">
// <div class="relative flex h-auto min-h-screen w-full flex-col max-w-[480px] mx-auto bg-background-light dark:bg-background-dark overflow-x-hidden">
// <header class="sticky top-0 z-10 flex items-center bg-white/80 dark:bg-background-dark/90 backdrop-blur-md p-4 justify-between border-b border-gray-100 dark:border-gray-800">
// <div class="flex size-10 shrink-0 items-center justify-center cursor-pointer hover:bg-gray-100 dark:hover:bg-gray-800 rounded-full transition-colors">
// <span class="material-symbols-outlined text-primary dark:text-blue-400">arrow_back_ios_new</span>
// </div>
// <h2 class="text-[#121416] dark:text-white text-lg font-bold leading-tight tracking-tight flex-1 text-center">Daily Expense (hy)</h2>
// <div class="flex size-10 items-center justify-center cursor-pointer hover:bg-gray-100 dark:hover:bg-gray-800 rounded-full transition-colors">
// <span class="material-symbols-outlined text-[#121416] dark:text-white">more_horiz</span>
// </div>
// </header>
// <main class="flex flex-col gap-6 p-4">
// <div class="p-0.5 rounded-xl bg-gradient-to-br from-primary/20 to-transparent">
// <div class="flex flex-col items-stretch justify-start rounded-xl soft-shadow bg-white dark:bg-gray-900 p-5 gap-4">
// <div class="flex justify-between items-start">
// <div class="flex flex-col gap-1">
// <p class="text-[#6a7681] dark:text-gray-400 text-sm font-medium uppercase tracking-wider">Subscription Summary</p>
// <h1 class="text-[#121416] dark:text-white text-4xl font-extrabold tracking-tight">$80.00</h1>
// </div>
// <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-primary/10 text-primary">
// <span class="material-symbols-outlined text-3xl">event_repeat</span>
// </div>
// </div>
// <div class="h-px bg-gray-100 dark:bg-gray-800 w-full"></div>
// <div class="flex items-center justify-between">
// <div class="flex flex-col gap-1">
// <p class="text-[#6a7681] dark:text-gray-400 text-xs font-semibold uppercase tracking-wide">Daily Frequency</p>
// <p class="text-[#121416] dark:text-white text-sm font-medium leading-normal">24.01.2026 - 29.01.2026</p>
// </div>
// <button class="flex min-w-[120px] cursor-pointer items-center justify-center overflow-hidden rounded-lg h-10 px-4 bg-primary text-white text-sm font-bold shadow-md shadow-primary/20 active:scale-95 transition-all">
// <span>Manage</span>
// </button>
// </div>
// </div>
// </div>
// <div class="flex flex-col gap-4">
// <div class="flex items-center justify-between px-1">
// <h3 class="text-[#121416] dark:text-white text-xl font-bold tracking-tight">Payment Log</h3>
// <span class="text-xs font-bold text-primary dark:text-blue-400 bg-primary/10 dark:bg-primary/20 px-2 py-1 rounded">6 TOTAL</span>
// </div>
// <div class="flex flex-col gap-3">
// <div class="flex items-center gap-4 bg-white dark:bg-gray-900 p-4 rounded-xl soft-shadow border-l-4 border-primary justify-between">
// <div class="flex items-center gap-4">
// <div class="text-primary flex items-center justify-center rounded-lg bg-info-muted dark:bg-primary/20 shrink-0 size-10">
// <span class="material-symbols-outlined text-[20px] font-bold">schedule</span>
// </div>
// <div class="flex flex-col justify-center">
// <p class="text-[#121416] dark:text-white text-base font-semibold leading-none mb-1.5">29.01.2026</p>
// <p class="text-[#6a7681] dark:text-gray-400 text-[11px] font-light tracking-wider leading-none uppercase">Upcoming Payment</p>
// </div>
// </div>
// <button class="flex items-center gap-1 px-3 py-2 bg-primary/10 hover:bg-primary/20 text-primary dark:text-blue-400 rounded-lg transition-colors active:scale-95">
// <span class="text-[12px] font-bold uppercase tracking-tight">Actions</span>
// <span class="material-symbols-outlined text-[18px]">expand_more</span>
// </button>
// </div>
// <div class="flex items-center gap-4 bg-white/60 dark:bg-gray-900/40 p-4 rounded-xl soft-shadow border-l-4 border-gray-300 dark:border-gray-700 justify-between">
// <div class="flex items-center gap-4">
// <div class="text-gray-400 flex items-center justify-center rounded-lg bg-gray-100 dark:bg-gray-800 shrink-0 size-10">
// <span class="material-symbols-outlined text-[20px] font-bold">block</span>
// </div>
// <div class="flex flex-col justify-center">
// <div class="flex items-center gap-3 mb-1.5">
// <p class="text-[#6a7681] dark:text-gray-400 text-base font-semibold leading-none strike-through">28.01.2026</p>
// </div>
// <p class="text-[#6a7681] dark:text-gray-500 text-[11px] font-light tracking-wider leading-none uppercase">Payment Cancelled</p>
// </div>
// </div>
// <button class="flex items-center gap-1 px-3 py-2 bg-primary/10 hover:bg-primary/20 text-primary dark:text-blue-400 rounded-lg transition-colors active:scale-95">
// <span class="text-[12px] font-bold uppercase tracking-tight">Actions</span>
// <span class="material-symbols-outlined text-[18px]">expand_more</span>
// </button>
// </div>
// <div class="flex items-center gap-4 bg-white dark:bg-gray-900 p-4 rounded-xl soft-shadow border-l-4 border-success-icon justify-between">
// <div class="flex items-center gap-4">
// <div class="text-success-icon flex items-center justify-center rounded-lg bg-success-muted dark:bg-success-icon/20 shrink-0 size-10">
// <span class="material-symbols-outlined text-[20px] font-bold">check_circle</span>
// </div>
// <div class="flex flex-col justify-center">
// <p class="text-[#121416] dark:text-white text-base font-semibold leading-none mb-1.5">27.01.2026</p>
// <p class="text-[#6a7681] dark:text-gray-400 text-[11px] font-light tracking-wider leading-none uppercase">Paid</p>
// </div>
// </div>
// <div class="shrink-0">
// <div class="flex px-3 py-1 rounded-full bg-success-muted dark:bg-success-icon/20 items-center justify-center">
// <span class="text-success-icon text-[10px] font-extrabold uppercase tracking-widest">Completed</span>
// </div>
// </div>
// </div>
// <div class="flex items-center gap-4 bg-white dark:bg-gray-900 p-4 rounded-xl soft-shadow border-l-4 border-success-icon justify-between">
// <div class="flex items-center gap-4">
// <div class="text-success-icon flex items-center justify-center rounded-lg bg-success-muted dark:bg-success-icon/20 shrink-0 size-10">
// <span class="material-symbols-outlined text-[20px] font-bold">check_circle</span>
// </div>
// <div class="flex flex-col justify-center">
// <p class="text-[#121416] dark:text-white text-base font-semibold leading-none mb-1.5">26.01.2026</p>
// <p class="text-[#6a7681] dark:text-gray-400 text-[11px] font-light tracking-wider leading-none uppercase">Paid</p>
// </div>
// </div>
// <div class="shrink-0">
// <div class="flex px-3 py-1 rounded-full bg-success-muted dark:bg-success-icon/20 items-center justify-center">
// <span class="text-success-icon text-[10px] font-extrabold uppercase tracking-widest">Completed</span>
// </div>
// </div>
// </div>
// <div class="flex items-center gap-4 bg-white/60 dark:bg-gray-900/40 p-4 rounded-xl soft-shadow border-l-4 border-gray-300 dark:border-gray-700 justify-between">
// <div class="flex items-center gap-4">
// <div class="text-gray-400 flex items-center justify-center rounded-lg bg-gray-100 dark:bg-gray-800 shrink-0 size-10">
// <span class="material-symbols-outlined text-[20px] font-bold">block</span>
// </div>
// <div class="flex flex-col justify-center">
// <div class="flex items-center gap-3 mb-1.5">
// <p class="text-[#6a7681] dark:text-gray-400 text-base font-semibold leading-none strike-through">25.01.2026</p>
// </div>
// <p class="text-[#6a7681] dark:text-gray-500 text-[11px] font-light tracking-wider leading-none uppercase">Payment Cancelled</p>
// </div>
// </div>
// <button class="flex items-center gap-1 px-3 py-2 bg-primary/10 hover:bg-primary/20 text-primary dark:text-blue-400 rounded-lg transition-colors active:scale-95">
// <span class="text-[12px] font-bold uppercase tracking-tight">Actions</span>
// <span class="material-symbols-outlined text-[18px]">expand_more</span>
// </button>
// </div>
// </div>
// </div>
// </main>
// <footer class="mt-auto p-4 pb-10">
// <button class="w-full h-14 bg-primary text-white font-bold rounded-xl flex items-center justify-center gap-2 shadow-lg shadow-primary/25 hover:brightness-110 active:scale-[0.98] transition-all">
// <span class="material-symbols-outlined">download</span>
// <span>Export Transaction History</span>
// </button>
// </footer>
// <div class="fixed inset-0 z-50 flex flex-col justify-end p-2 sm:p-4 action-sheet-overlay">
// <div class="w-full max-w-[448px] mx-auto flex flex-col gap-2">
// <div class="bg-white/90 dark:bg-[#1c1c1e]/90 backdrop-blur-xl rounded-2xl overflow-hidden shadow-2xl">
// <div class="p-4 text-center border-b border-gray-200 dark:border-gray-800">
// <p class="text-xs font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-widest">Manage Future Transaction</p>
// </div>
// <button class="w-full py-4 px-4 text-center text-[20px] text-ios-blue font-medium active:bg-gray-200 dark:active:bg-gray-700/50 transition-colors border-b border-gray-200 dark:border-gray-800">
//                         View Details
//                     </button>
// <button class="w-full py-4 px-4 text-center text-[20px] text-ios-blue font-medium active:bg-gray-200 dark:active:bg-gray-700/50 transition-colors">
//                         Re-activate Payment
//                     </button>
// </div>
// <button class="w-full py-4 px-4 bg-white dark:bg-[#1c1c1e] text-[20px] text-ios-blue font-bold rounded-2xl shadow-xl active:bg-gray-100 dark:active:bg-gray-800 transition-colors mb-2">
//                     Close
//                 </button>
// </div>
// </div>
// </div>

// </body></html>
