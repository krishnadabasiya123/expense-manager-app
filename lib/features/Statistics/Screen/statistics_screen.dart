// import 'dart:developer';

// import 'package:expenseapp/core/app/all_import_file.dart';
// import 'package:expenseapp/features/RecurringTransaction/Cubit/get_recurring_transaction_cubit.dart';
// import 'package:expenseapp/features/RecurringTransaction/LocalStorage/recurring_transaction_local_data.dart';
// import 'package:expenseapp/features/RecurringTransaction/Model/Recurring.dart';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/adapters.dart';

// class StatisticsScreen extends StatefulWidget {
//   const StatisticsScreen({super.key});

//   @override
//   State<StatisticsScreen> createState() => _StatisticsScreenState();
// }

// class _StatisticsScreenState extends State<StatisticsScreen> {
//   Future<void> clearMyBox() async {
//     await Hive.deleteFromDisk();
//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   //List<Recurring> transactionList = [];

//   List<Transaction> transactionList = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Theme.of(context).primaryColor,
//         title: const Center(
//           child: Text('Statistics', style: TextStyle(color: Colors.white)),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               setState(() {});
//               clearMyBox();
//             },
//             icon: const Icon(Icons.calendar_month_sharp, color: Colors.white),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               transactionList = TransactionLocalData().getTransaction();
//               for (final transaction in transactionList) {
//                 log('transaction.toJson() ${transaction.toJson()}');
//               }
//             },
//             child: const Text('GetTransactionData'),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/Transaction/Model/enums/TransactionType.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ---------------- ENUM ----------------

class LegendItem extends StatelessWidget {
  const LegendItem({required this.color, required this.label, super.key});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// ---------------- MAIN WIDGET ----------------
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<Transaction> transactions = TransactionLocalData().getTransaction();
  @override
  void initState() {
    super.initState();
    calculateTodaySummary(transactions);
  }

  final dateFormat = DateFormat('dd.MM.yyyy');

  double todayIncome = 0;
  double todayExpense = 0;

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<Transaction> getTodayTransactions(List<Transaction> list) {
    final today = DateTime.now();

    return list.where((tx) {
      if (tx.date == null) return false;
      final txDate = UiUtils.dateFormatter.parse(tx.date!);

      // final txDate = DateTime.parse(tx.date!);
      return isSameDay(txDate, today);
    }).toList();
  }

  double calculateTodayIncome(List<Transaction> list) {
    return list.where((tx) => tx.type == TransactionType.INCOME).fold(0, (sum, tx) => sum + (tx.amount ?? 0));
  }

  double calculateTodayExpense(List<Transaction> list) {
    return list.where((tx) => tx.type == TransactionType.EXPENSE).fold(0, (sum, tx) => sum + (tx.amount ?? 0));
  }

  void calculateTodaySummary(List<Transaction> transactionList) {
    final todayTransactions = getTodayTransactions(transactionList);

    todayIncome = calculateTodayIncome(todayTransactions);
    todayExpense = calculateTodayExpense(todayTransactions);

    debugPrint('Today Income: $todayIncome');
    debugPrint('Today Expense: $todayExpense');
  }

  Widget todayIncomeExpenseBarChart() {
    return SizedBox(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: BarChart(
          BarChartData(
            //alignment: BarChartAlignment.spaceAround,
            maxY: (todayIncome > todayExpense ? todayIncome : todayExpense) + 1500,

            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                    toY: todayIncome,
                    width: 30,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              ),
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                    toY: todayExpense,
                    width: 30,
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.red,
                  ),
                ],
              ),
            ],

            titlesData: FlTitlesData(
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                ),
              ),

              // topTitles: AxisTitles(
              //   sideTitles: SideTitles(
              //     showTitles: true,
              //     getTitlesWidget: (value, meta) {
              //       return const Padding(
              //         padding: EdgeInsets.only(bottom: 8),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             LegendItem(color: Colors.green, label: 'Income'),
              //             SizedBox(width: 16),
              //             LegendItem(color: Colors.red, label: 'Expense'),
              //           ],
              //         ),
              //       );
              //     },
              //   ),
              // ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    switch (value.toInt()) {
                      case 0:
                        return const Text('Income');
                      case 1:
                        return const Text('Expense');
                      default:
                        return const SizedBox();
                    }
                  },
                ),
              ),
            ),

            // titlesData: FlTitlesData(
            //   rightTitles: const AxisTitles(),
            //   leftTitles: AxisTitles(
            //     sideTitles: SideTitles(
            //       showTitles: true, // show left side
            //       interval: 1000,
            //       getTitlesWidget: (value, meta) {
            //         return Text(
            //           value.toInt().toString(),
            //           style: const TextStyle(fontSize: 12),
            //         );
            //       },
            //     ),
            //   ),
            //   bottomTitles: AxisTitles(
            //     sideTitles: SideTitles(
            //       showTitles: true,
            //       getTitlesWidget: (value, meta) {
            //         switch (value.toInt()) {
            //           case 0:
            //             return const Text('Income');
            //           case 1:
            //             return const Text('Expense');
            //           default:
            //             return const SizedBox();
            //         }
            //       },
            //     ),
            //   ),
            //   topTitles: const AxisTitles(),
            // ),
            gridData: const FlGridData(
              //show: false,
              verticalInterval: 5,
            ),
            borderData: FlBorderData(
              border: const Border(
                bottom: BorderSide(),
                left: BorderSide(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> clearMyBox() async {
    await Hive.deleteFromDisk();
    setState(() {});
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Center(
          child: Text('Statistics', style: TextStyle(color: Colors.white)),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
              clearMyBox();
            },
            icon: const Icon(Icons.calendar_month_sharp, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Stack(
            children: [
              const Positioned(
                top: 20,
                left: 50,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LegendItem(color: Colors.green, label: 'Income'),
                      SizedBox(width: 16),
                      LegendItem(color: Colors.red, label: 'Expense'),
                    ],
                  ),
                ),
              ),
              todayIncomeExpenseBarChart(),
              // SummaryTile(
              //   title: 'Today Income',
              //   amount: todayIncome,
              //   color: Colors.green,
              // ),
              // SummaryTile(
              //   title: 'Today Expense',
              //   amount: todayExpense,
              //   color: Colors.red,
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

class SummaryTile extends StatelessWidget {
  const SummaryTile({
    required this.title,
    required this.amount,
    required this.color,
    super.key,
  });
  final String title;
  final double amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(
          '₹ ${amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
