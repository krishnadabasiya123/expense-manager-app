// import 'package:expenseapp/core/app/all_import_file.dart';
// import 'package:expenseapp/core/app/all_import_file.dart';
// import 'package:expenseapp/core/app/all_import_file.dart';
// import 'package:expenseapp/features/Home/Cubits/edit_home_cubit.dart';
// import 'package:expenseapp/utils/extensions.dart';
// import 'package:expenseapp/core/app/all_import_file.dart';// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
// import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
// import 'package:scrollable_clean_calendar/utils/enums.dart';
// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:expenseapp/core/app/all_import_file.dart'; // Needed for DateFormat

// class MyAppCalendar extends StatelessWidget {
//   const MyAppCalendar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final focusedDay = DateTime.now();
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsetsDirectional.only(top: 25),
//         child: TableCalendar(
//           focusedDay: focusedDay,
//           firstDay: DateTime.utc(2010),
//           lastDay: DateTime.utc(2030, 12, 31),
        
//           headerStyle: const HeaderStyle(
//             titleCentered: true,
//             formatButtonVisible: false, // Hides the "Month/Week/2 Weeks" button
//             titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             // Custom title builder can also be used for advanced customization
//             // titleTextFormatter: (date, locale) => DateFormat.yMMMM(locale).format(date),
//           ),

//           // Hide the days of the week row
//           daysOfWeekVisible: false,

//           // Set a very small rowHeight to effectively hide the date grid cells
//           rowHeight: 0,

//           // Use builders to return empty widgets for day cells
//           calendarBuilders: CalendarBuilders(
//             // Return an empty container for all day cells (outside, today, selected, etc.)
//             //  outsideDayBuilder: (context, day, focusedDay) => Container(),
//             markerBuilder: (context, day, events) => Container(),
//             dowBuilder: (context, day) => Container(), // If daysOfWeekVisible is true
//             todayBuilder: (context, day, focusedDay) => Container(),
//             // selectedDayBuilder: (context, day, focusedDay) => Container(),
//             prioritizedBuilder: (context, day, focusedDay) => Container(),
//             // disabledDayBuilder: (context, day, focusedDay) => Container(),
//             // defaultDayBuilder: (context, day, focusedDay) => Container(),
//           ),

//           // Disable gestures if you only want a static header view
//           availableGestures: AvailableGestures.none,
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';

// // 1. --- EXTENSION FOR GLOBAL ACCESS ---
// // This allows you to use context.symbol instead of context.watch...state
// extension CurrencyContext on BuildContext {
//   String get symbol => watch<CurrencyCubit>().state;
// }
// // 
// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (context) => CurrencyCubit()),
//         BlocProvider(create: (context) => TransactionCubit()..loadDummyData()),
//         BlocProvider(create: (context) => NavigationCubit()),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           useMaterial3: true,
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
//         ),
//         home: const SplashScreen(),
//       ),
//     );
//   }
// }

// // --- MODELS ---
// class Transaction extends Equatable {

//   const Transaction({required this.id, required this.title, required this.amount});
//   final String id;
//   final String title;
//   final double amount;

//   @override
//   List<Object?> get props => [id, title, amount];
// }

// // --- CUBITS ---

// class CurrencyCubit extends Cubit<String> {
//   CurrencyCubit() : super(r'$');
//   void updateCurrency(String symbol) => emit(symbol);
// }

// class NavigationCubit extends Cubit<int> {
//   NavigationCubit() : super(0);
//   void setTab(int index) => emit(index);
// }

// class TransactionCubit extends Cubit<List<Transaction>> {
//   TransactionCubit() : super([]);

//   void loadDummyData() {
//     emit([const Transaction(id: '1', title: 'Coffee', amount: 4.50), const Transaction(id: '2', title: 'Shopping', amount: 120), const Transaction(id: '3', title: 'Gas', amount: 55.20)]);
//   }

//   void addTransaction(String title, double amount) {
//     final tx = Transaction(id: DateTime.now().toString(), title: title, amount: amount);
//     emit([tx, ...state]);
//   }
// }

// // --- SCREENS ---

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(seconds: 2), () {
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CurrencySelectionScreen(isInitial: true)));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       backgroundColor: Colors.blueAccent,
//       body: Center(
//         child: Text(
//           'TRACKER',
//           style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }

// class CurrencySelectionScreen extends StatelessWidget {
//   const CurrencySelectionScreen({super.key, this.isInitial = false});
//   final bool isInitial;

//   @override
//   Widget build(BuildContext context) {
//     final list = [
//       {'n': 'Dollar', 's': r'$'},
//       {'n': 'Euro', 's': '€'},
//       {'n': 'Rupee', 's': '₹'},
//     ];
//     return Scaffold(
//       appBar: AppBar(title: const Text('Choose Currency')),
//       body: ListView.builder(
//         itemCount: list.length,
//         itemBuilder: (context, i) => ListTile(
//           title: Text(list[i]['n']!),
//           trailing: Text(list[i]['s']!, style: const TextStyle(fontSize: 20)),
//           onTap: () {
//             context.read<CurrencyCubit>().updateCurrency(list[i]['s']!);
//             if (isInitial) {
//               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainNavigationWrapper()));
//             } else {
//               Navigator.pop(context);
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

// // 2. --- MAIN NAVIGATION WRAPPER ---
// class MainNavigationWrapper extends StatelessWidget {
//   const MainNavigationWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<NavigationCubit, int>(
//       builder: (context, activeTab) {
//         return Scaffold(
//           body: IndexedStack(index: activeTab, children: const [HomeView(), HistoryView(), SettingsView()]),
//           bottomNavigationBar: BottomNavigationBar(
//             currentIndex: activeTab,
//             onTap: (i) => context.read<NavigationCubit>().setTab(i),
//             items: const [
//               BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//               BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
//               BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// // --- SUB VIEWS ---

// class HomeView extends StatelessWidget {
//   const HomeView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Dashboard')),
//       body: Column(
//         children: [
//           // TOTAL BALANCE CARD
//           Container(
//             margin: const EdgeInsetsDirectional.all(16),
//             padding: const EdgeInsetsDirectional.all(24),
//             decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(16)),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Total spent:', style: TextStyle(color: Colors.white, fontSize: 18)),
//                 BlocBuilder<TransactionCubit, List<Transaction>>(
//                   builder: (context, list) {
//                     final total = list.fold(0, (sum, item) => sum + item.amount);
//                     // ACCESSING SYMBOL VIA EXTENSION
//                     return Text(
//                       '${context.symbol}${total.toStringAsFixed(2)}',
//                       style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//           const Expanded(child: TransactionListWidget()),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(onPressed: () => _addDialog(context), child: const Icon(Icons.add)),
//     );
//   }

//   void _addDialog(BuildContext context) {
//     final t = TextEditingController();
//     final a = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Add'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: t,
//               decoration: const InputDecoration(hintText: 'Title'),
//             ),
//             TextField(
//               controller: a,
//               decoration: const InputDecoration(hintText: 'Amount'),
//               keyboardType: TextInputType.number,
//             ),
//           ],
//         ),
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               context.read<TransactionCubit>().addTransaction(t.text, double.parse(a.text));
//               Navigator.pop(ctx);
//             },
//             child: const Text('Add'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class HistoryView extends StatelessWidget {
//   const HistoryView({super.key});
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     appBar: AppBar(title: const Text('History')),
//     body: const TransactionListWidget(),
//   );
// }

// class SettingsView extends StatelessWidget {
//   const SettingsView({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Settings')),
//       body: ListTile(
//         title: const Text('Currency'),
//         // ACCESSING SYMBOL VIA EXTENSION
//         trailing: Text(context.symbol, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//         onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CurrencySelectionScreen())),
//       ),
//     );
//   }
// }

// // 3. --- SHARED LIST WIDGET ---
// class TransactionListWidget extends StatelessWidget {
//   const TransactionListWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final transactions = context.watch<TransactionCubit>().state;

//     return ListView.builder(
//       itemCount: transactions.length,
//       itemBuilder: (context, index) {
//         final tx = transactions[index];
//         return ListTile(
//           title: Text(tx.title),
//           // ACCESSING SYMBOL VIA EXTENSION (CLEAN!)
//           trailing: Text(
//             '${context.symbol}${tx.amount.toStringAsFixed(2)}',
//             style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
//           ),
//         );
//       },
//     );
//   }
// }


// extension CurrencyFormatter on double {
//   String get asCurrency => '₹${toStringAsFixed(2)}';
// }



// import 'dart:developer';

// import 'package:expenseapp/core/app/all_import_file.dart';
// import 'package:expenseapp/core/app/all_import_file.dart';
// import 'package:expenseapp/core/app/all_import_file.dart';

// class AccountLocalStorage {
//   //static late Box<Account> box;

//   Box get _box => Hive.box(accountBox);

//   static const String key = 'accounts';
//   static const String boxName = accountBox;

//   static Future<void> init() async {
//     Hive.registerAdapter(AccountAdapter());

//     await Hive.openBox(boxName);

//     //box = await Hive.openBox<Account>(accountBox);
//   }

//   Future<void> saveAccount(Account account) async {
//     _box.put(key, account);
//   }

  

  // List<Account> getAccount() {
  //   final account = _box.get(key, defaultValue: <Account>[]) as List<Account>;
  //   return account;
  // }

//   Future<void> updateAccount(Account account) async {
    
//     final list = getAccount();

//     final index = list.indexWhere((e) => e.id == account.id);
//     log('index $index');

//     if (index != -1) {
//       list[index] = account;
//       await _box.put(key, list); // ← save LIST again
//     }
//   }

//   Future<void> deleteAccount(Account account) async {
   
//     final list = getAccount()..removeWhere((e) => e.id == account.id);

//     await _box.put(key, list);
//   }
// }
