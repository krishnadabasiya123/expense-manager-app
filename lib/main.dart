import 'package:expenseapp/core/app/app.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(await initializeApp());
}

// class FintechApp extends StatelessWidget {
//   const FintechApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Receipt Gallery',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         brightness: Brightness.light,
//         primaryColor: const Color(0xFF0D7FF2),
//         scaffoldBackgroundColor: const Color(0xFFF5F7F8),
//         textTheme: GoogleFonts.manropeTextTheme(),
//       ),
//       darkTheme: ThemeData(
//         brightness: Brightness.dark,
//         primaryColor: const Color(0xFF0D7FF2),
//         scaffoldBackgroundColor: const Color(0xFF101922),
//         textTheme: GoogleFonts.manropeTextTheme(ThemeData.dark().textTheme),
//       ),
//       home: const ReceiptGalleryPage(),
//     );
//   }
// }

// class ReceiptGalleryPage extends StatefulWidget {
//   const ReceiptGalleryPage({super.key});

//   @override
//   State<ReceiptGalleryPage> createState() => _ReceiptGalleryPageState();
// }

// class _ReceiptGalleryPageState extends State<ReceiptGalleryPage> {
//   int _currentIndex = 1; // "Bills" tab active

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildHeader(context, isDark),
//             Expanded(
//               child: _buildReceiptGrid(context, isDark),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         backgroundColor: const Color(0xFF0D7FF2),
//         shape: const CircleBorder(),
//         elevation: 4,
//         child: const Icon(Icons.add_a_photo, color: Colors.white, size: 28),
//       ),
//       bottomNavigationBar: _buildBottomNav(context, isDark),
//     );
//   }

//   Widget _buildHeader(BuildContext context, bool isDark) {
//     return Column(
//       children: [
//         // Top App Bar
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.arrow_back),
//                     onPressed: () {},
//                   ),
//                   const Text(
//                     'Receipt Gallery',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//               IconButton(
//                 icon: const Icon(Icons.more_vert),
//                 onPressed: () {},
//               ),
//             ],
//           ),
//         ),
//         // Search Bar
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: TextField(
//             decoration: InputDecoration(
//               hintText: 'Search by merchant or category...',
//               hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
//               prefixIcon: const Icon(Icons.search, color: Colors.grey),
//               filled: true,
//               fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide.none,
//               ),
//               contentPadding: const EdgeInsets.symmetric(),
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),

//         // Filter Chips
//         const SizedBox(height: 8),
//       ],
//     );
//   }

//   Widget _filterChip(BuildContext context, String label, bool isActive, IconData? icon) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     return Container(
//       margin: const EdgeInsets.only(right: 8),
//       child: Chip(
//         avatar: icon != null ? Icon(icon, size: 16, color: isActive ? Colors.white : Colors.grey) : null,
//         label: Text(label),
//         labelStyle: TextStyle(
//           color: isActive ? Colors.white : (isDark ? Colors.grey[300] : Colors.grey[700]),
//           fontSize: 13,
//           fontWeight: FontWeight.w500,
//         ),
//         backgroundColor: isActive ? const Color(0xFF0D7FF2) : (isDark ? const Color(0xFF1E293B) : Colors.white),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//           side: isActive ? BorderSide.none : BorderSide(color: Colors.grey.withOpacity(0.2)),
//         ),
//       ),
//     );
//   }

//   Widget _buildReceiptGrid(BuildContext context, bool isDark) {
//     final receipts = <Map<String, dynamic>>[
//       {'amount': '124.50', 'merchant': 'Grocery Store', 'date': 'Oct 24, 2023', 'color': Colors.green},
//       {'amount': '12.80', 'merchant': 'Starbucks', 'date': 'Oct 23, 2023', 'color': Colors.orange},
//       {'amount': '65.00', 'merchant': 'Shell Station', 'date': 'Oct 22, 2023', 'color': Colors.blue},
//       {'amount': '89.99', 'merchant': 'Internet Bill', 'date': 'Oct 20, 2023', 'color': Colors.purple},
//       {'amount': '210.00', 'merchant': 'Zara Fashion', 'date': 'Oct 18, 2023', 'color': Colors.pink},
//       {'amount': '450.25', 'merchant': 'Hilton Hotels', 'date': 'Oct 15, 2023', 'color': Colors.blueAccent},
//     ];

//     return GridView.builder(
//       padding: const EdgeInsets.all(16),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: 0.75, // 3/4 aspect ratio as in HTML
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//       ),
//       itemCount: receipts.length,
//       itemBuilder: (context, index) {
//         final item = receipts[index];
//         return Container(
//           decoration: BoxDecoration(
//             color: isDark ? const Color(0xFF1E293B) : Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 5,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Image Placeholder (Simulating the 3:4 background image)
//               Expanded(
//                 child: Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//                     image: const DecorationImage(
//                       image: NetworkImage('https://via.placeholder.com/300x400'),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ),
//               // Content
//               Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           '\$${item['amount']}',
//                           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                         ),
//                         Container(
//                           width: 8,
//                           height: 8,
//                           decoration: BoxDecoration(color: item['color'] as Color, shape: BoxShape.circle),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       item['merchant'] as String,
//                       style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       item['date'] as String,
//                       style: const TextStyle(fontSize: 10, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildBottomNav(BuildContext context, bool isDark) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2))),
//       ),
//       child: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) => setState(() => _currentIndex = index),
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
//         selectedItemColor: const Color(0xFF0D7FF2),
//         unselectedItemColor: Colors.grey,
//         selectedFontSize: 10,
//         unselectedFontSize: 10,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Bills'),
//           BottomNavigationBarItem(icon: Icon(Icons.pie_chart_outline), label: 'Stats'),
//           BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Profile'),
//         ],
//       ),
//     );
//   }
// }

// void main() async {
//   runApp(await initializeApp());
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';

// // ==========================================
// // 1. App Initialization Cubit (The Orchestrator)
// // ==========================================
// abstract class AppInitState extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

// class AppInitInitial extends AppInitState {}
// class AppInitLoading extends AppInitState {}
// class AppInitSuccess extends AppInitState {}
// class AppInitFailure extends AppInitState {
//   final String error;
//   AppInitFailure(this.error);
//   @override
//   List<Object?> get props => [error];
// }

// class AppInitCubit extends Cubit<AppInitState> {
//   AppInitCubit() : super(AppInitInitial());

//   Future<void> initializeAppData({
//     required GetCategoryCubit categoryCubit,
//     required GetProductCubit productCubit,
//     required GetCartItemCubit cartCubit,
//   }) async {
//     emit(AppInitLoading());

//     try {
//       // Future.wait triggers all API calls in parallel.
//       // If ANY of these throw an exception, it goes to the catch block.
//       await Future.wait([
//         categoryCubit.fetchCategories(),
//         productCubit.fetchProducts(),
//         cartCubit.fetchCart(),
//       ]);

//       emit(AppInitSuccess());
//     } catch (e) {
//       // You can log the error 'e' here
//       emit(AppInitFailure("Unable to sync data. Please check your internet."));
//     }
//   }
// }

// // ==========================================
// // 2. Feature Cubits (Mocks)
// // ==========================================

// class GetCategoryCubit extends Cubit<String> {
//   GetCategoryCubit() : super("Initial");
//   Future<void> fetchCategories() async {
//     await Future.delayed(const Duration(seconds: 1));
//     // To test error logic, you could throw Exception();
//     emit("Categories Loaded");
//   }
// }

// class GetProductCubit extends Cubit<String> {
//   GetProductCubit() : super("Initial");
//   Future<void> fetchProducts() async {
//     await Future.delayed(const Duration(seconds: 2));
//     emit("Products Loaded");
//   }
// }

// class GetCartItemCubit extends Cubit<String> {
//   GetCartItemCubit() : super("Initial");
//   Future<void> fetchCart() async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     emit("Cart Loaded");
//   }
// }

// // ==========================================
// // 3. UI - Splash Screen (With Error Handling)
// // ==========================================
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   void _loadData() {
//     // Start the orchestrator logic
//     context.read<AppInitCubit>().initializeAppData(
//           categoryCubit: context.read<GetCategoryCubit>(),
//           productCubit: context.read<GetProductCubit>(),
//           cartCubit: context.read<GetCartItemCubit>(),
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: BlocConsumer<AppInitCubit, AppInitState>(
//         listener: (context, state) {
//           if (state is AppInitSuccess) {
//             // Success: Move to Home
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(builder: (_) => const HomeScreen()),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is AppInitFailure) {
//             // FAILURE: Show error icon and Retry Button
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(30.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.cloud_off, size: 80, color: Colors.redAccent),
//                     const SizedBox(height: 20),
//                     Text(
//                       state.error,
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                     ),
//                     const SizedBox(height: 30),
//                     ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//                         backgroundColor: Colors.blueAccent,
//                         foregroundColor: Colors.white,
//                       ),
//                       onPressed: _loadData, // Trigger reload
//                       icon: const Icon(Icons.refresh),
//                       label: const Text("TRY AGAIN"),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }

//           // LOADING: Show branding and spinner
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const FlutterLogo(size: 100),
//                 const SizedBox(height: 40),
//                 const CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   "Preparing your store...",
//                   style: TextStyle(color: Colors.grey.shade600, letterSpacing: 1.2),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// // ==========================================
// // 4. UI - Home Screen
// // ==========================================
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Omkar Sale")),
//       body: const Center(
//         child: Text("Welcome! All data is synchronized."),
//       ),
//     );
//   }
// }

// // ==========================================
// // 5. Main Setup
// // ==========================================
// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         // Features
//         BlocProvider(create: (_) => GetCategoryCubit()),
//         BlocProvider(create: (_) => GetProductCubit()),
//         BlocProvider(create: (_) => GetCartItemCubit()),
//         // Orchestrator
//         BlocProvider(create: (_) => AppInitCubit()),
//       ],
//       child: MaterialApp(
//         title: 'Flutter Init Demo',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
//         home: const SplashScreen(),
//       ),
//     );
//   }
// }

// main.dart (complete app)
// import 'package:expenseapp/core/app/all_import_file.dart';
// import 'package:expenseapp/features/Transaction/LocalStorage/transaction_local_data.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:workmanager/workmanager.dart';

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     // Background task logic to fetch data from an API
//     print('Fetching data in the background');

//     final response = Transaction(
//       id: 'TR'.withDateTimeMillisRandom(),
//       title: 'test',
//       amount: 100,
//       date: DateTime.now().toString(),
//       recurringId: '1',
//       type: TransactionType.EXPENSE,
//       categoryId: '1',
//       accountId: '1',
//     );

//     print('Data fetched in the background $response');

//     return Future.value(true);
//   });
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   Workmanager().initialize(callbackDispatcher);
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   String data = 'No data available';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Workmanager Example App'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text('Fetched Data:'),
//             const SizedBox(height: 20),
//             Text(data, style: const TextStyle(fontSize: 18)),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Trigger background task manually
//           // Workmanager().executeTask((task, inputData) {
//           //   print('Manually triggering background task');
//           //   return Future.value(true);
//           // });
//         },
//         child: const Icon(Icons.refresh),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();

//     // Fetch initial data when the app starts
//     fetchData();
//   }

//   // Function to fetch data from the API
//   Future<void> fetchData() async {
//     final response = Transaction(
//       id: 'TR'.withDateTimeMillisRandom(),
//       title: 'test',
//       amount: 100,
//       date: DateTime.now().toString(),
//       recurringId: '1',
//       type: TransactionType.EXPENSE,
//       categoryId: '1',
//       accountId: '1',
//     );

//     final fetchedData = response;
//     setState(() {
//       data = fetchedData.toJson().toString();
//     });
//   }
// }

// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:workmanager/workmanager.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// Future<void> initNotifications() async {
//   const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

//   const initSettings = InitializationSettings(android: androidSettings);

//   await flutterLocalNotificationsPlugin.initialize(initSettings);

//   await requestNotificationPermission();
//   await createNotificationChannel();
// }

// Future<void> requestNotificationPermission() async {
//   final isGranted = (await Permission.notification.status).isGranted;

//   if (!isGranted) await Permission.notification.request();
// }

// Future<void> createNotificationChannel() async {
//   const channel = AndroidNotificationChannel(
//     'expense_channel',
//     'Expense Notifications',
//     description: 'Daily expense reminder',
//     importance: Importance.max,
//   );

//   await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
// }

// Future<void> notificationSend() async {
//   log('Notification Send');

//   await flutterLocalNotificationsPlugin.show(
//     0,
//     'Expense Manager',
//     'Please check all your expenses for today!',
//     const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'expense_channel',
//         'Expense Notifications',
//         channelDescription: 'Daily expense reminder',
//         importance: Importance.max,
//         priority: Priority.high,
//       ),
//     ),
//   );
// }

// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// /// ---------------- APP ----------------

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'App Dialog Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
//       ),
//       home: const HomeScreen(),
//     );
//   }
// }

// /// ---------------- HOME SCREEN ----------------

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Dialog Demo')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             _btn(
//               context,
//               'Info Dialog',
//               () => context.showAppDialog(
//                 title: 'Info',
//                 message: 'This is info dialog',
//                 confirmText: 'OK',
//               ),
//             ),
//             _btn(
//               context,
//               'Success Dialog',
//               () => context.showSuccess('Data saved successfully'),
//             ),
//             _btn(
//               context,
//               'Error Dialog',
//               () => context.showError('Something went wrong'),
//             ),
//             _btn(
//               context,
//               'Confirm Dialog',
//               () => context.showAppDialog(
//                 type: AppDialogType.confirm,
//                 title: 'Delete',
//                 message: 'Are you sure?',
//                 cancelText: 'Cancel',
//                 confirmText: 'Delete',
//                 onConfirm: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Deleted')),
//                   );
//                 },
//               ),
//             ),
//             _btn(
//               context,
//               'Loading Dialog',
//               () async {
//                 context.showLoading(message: 'Loading...');
//                 await Future.delayed(const Duration(seconds: 2));
//                 Navigator.pop(context);
//               },
//             ),
//             _btn(
//               context,
//               'Custom Widget Dialog',
//               () => context.showAppDialog(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Text(
//                       'Custom Content',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     const TextField(
//                       decoration: InputDecoration(
//                         labelText: 'Enter name',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text('Submit'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _btn(BuildContext context, String title, VoidCallback onTap) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: SizedBox(
//         width: double.infinity,
//         child: ElevatedButton(
//           onPressed: onTap,
//           child: Text(title),
//         ),
//       ),
//     );
//   }
// }

// /// ---------------- ENUM ----------------

// enum AppDialogType { info, success, error, warning, confirm, loading }

// /// ---------------- EXTENSION ----------------

// extension AppDialogExt on BuildContext {
//   Future<T?> showAppDialog<T>({
//     AppDialogType type = AppDialogType.info,
//     String? title,
//     String? message,
//     String? confirmText,
//     String? cancelText,
//     VoidCallback? onConfirm,
//     VoidCallback? onCancel,
//     bool barrierDismissible = true,
//     bool isLoading = false,
//     Widget? child,
//   }) {
//     return showGeneralDialog<T>(
//       context: this,
//       barrierDismissible: barrierDismissible,
//       barrierLabel: '',
//       barrierColor: Colors.black54,
//       transitionDuration: const Duration(milliseconds: 300),
//       pageBuilder: (ctx, _, __) {
//         return AppDialog(
//           type: type,
//           title: title,
//           message: message,
//           confirmText: confirmText,
//           cancelText: cancelText,
//           isLoading: isLoading,
//           child: child,
//           onConfirm: () {
//             Navigator.pop(ctx);
//             onConfirm?.call();
//           },
//           onCancel: () {
//             Navigator.pop(ctx);
//             onCancel?.call();
//           },
//         );
//       },
//       transitionBuilder: (context, animation, secondaryAnimation, child) {
//         return Transform.scale(
//           scale: Curves.easeOutBack.transform(animation.value),
//           child: Opacity(opacity: animation.value, child: child),
//         );
//       },
//     );
//   }

//   Future<void> showSuccess(String message) {
//     return showAppDialog(
//       type: AppDialogType.success,
//       title: 'Success',
//       message: message,
//       confirmText: 'OK',
//     );
//   }

//   Future<void> showError(String message) {
//     return showAppDialog(
//       type: AppDialogType.error,
//       title: 'Error',
//       message: message,
//       confirmText: 'Close',
//     );
//   }

//   Future<void> showLoading({String? message}) {
//     return showAppDialog(
//       type: AppDialogType.loading,
//       isLoading: true,
//       message: message ?? 'Please wait...',
//       barrierDismissible: false,
//     );
//   }
// }

// /// ---------------- DIALOG ----------------

// class AppDialog extends StatelessWidget {
//   const AppDialog({
//     required this.type,
//     super.key,
//     this.title,
//     this.message,
//     this.confirmText,
//     this.cancelText,
//     this.onConfirm,
//     this.onCancel,
//     this.isLoading = false,
//     this.child,
//   });

//   final AppDialogType type;
//   final String? title;
//   final String? message;
//   final String? confirmText;
//   final String? cancelText;
//   final VoidCallback? onConfirm;
//   final VoidCallback? onCancel;
//   final bool isLoading;
//   final Widget? child;

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: isLoading
//             ? Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const CircularProgressIndicator(),
//                   const SizedBox(height: 16),
//                   if (message != null) Text(message!),
//                 ],
//               )
//             : child ??
//                   Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       _icon(context),
//                       if (title != null) ...[
//                         const SizedBox(height: 8),
//                         Text(
//                           title!,
//                           style: const TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                       if (message != null) ...[
//                         const SizedBox(height: 8),
//                         Text(message!, textAlign: TextAlign.center),
//                       ],
//                       const SizedBox(height: 20),
//                       Row(
//                         children: [
//                           if (cancelText != null)
//                             Expanded(
//                               child: TextButton(
//                                 onPressed: onCancel,
//                                 child: Text(cancelText!),
//                               ),
//                             ),
//                           if (confirmText != null)
//                             Expanded(
//                               child: ElevatedButton(
//                                 onPressed: onConfirm,
//                                 child: Text(confirmText!),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ],
//                   ),
//       ),
//     );
//   }

//   Widget _icon(BuildContext context) {
//     IconData icon;
//     Color color;

//     switch (type) {
//       case AppDialogType.success:
//         icon = Icons.check_circle;
//         color = context.colorScheme.incomeColor;
//       case AppDialogType.error:
//         icon = Icons.error;
//         color = context.colorScheme.expenseColor;
//       case AppDialogType.confirm:
//         icon = Icons.help;
//         color = Colors.blue;
//       default:
//         icon = Icons.info;
//         color = Colors.blue;
//     }

//     return Icon(icon, size: 48, color: color);
//   }
// }
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// /* ===========================
//    APP ROOT
// =========================== */

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Budget Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const BudgetListScreen(),
//     );
//   }
// }

// /* ===========================
//    MODELS
// =========================== */

// enum TransactionType { income, expense }

// class BudgetTransaction {
//   BudgetTransaction({
//     required this.amount,
//     required this.type,
//   });
//   final double amount;
//   final TransactionType type;
// }

// class BudgetModel {
//   BudgetModel({
//     required this.title,
//     required this.limit,
//     required this.transactions,
//   });
//   final String title;
//   final double limit;
//   final List<BudgetTransaction> transactions;

//   double get totalExpense => transactions.where((t) => t.type == TransactionType.expense).fold(0, (sum, t) => sum + t.amount);

//   double get totalIncome => transactions.where((t) => t.type == TransactionType.income).fold(0, (sum, t) => sum + t.amount);

//   double get usedAmount {
//     final used = totalExpense - totalIncome;
//     return used > 0 ? used : 0;
//   }

//   double get savedAmount {
//     final saved = totalIncome - totalExpense;
//     return saved > 0 ? saved : 0;
//   }

//   double get remaining => limit - usedAmount;

//   double get progress => (usedAmount / limit).clamp(0.0, 1.0);
// }

// /* ===========================
//    BUDGET LIST SCREEN
// =========================== */

// class BudgetListScreen extends StatefulWidget {
//   const BudgetListScreen({super.key});

//   @override
//   State<BudgetListScreen> createState() => _BudgetListScreenState();
// }

// class _BudgetListScreenState extends State<BudgetListScreen> {
//   final List<BudgetModel> budgets = [
//     BudgetModel(
//       title: 'Study Material',
//       limit: 10000,
//       transactions: [
//         BudgetTransaction(amount: 500, type: TransactionType.income),
//         BudgetTransaction(amount: 400, type: TransactionType.income),
//         BudgetTransaction(amount: 600, type: TransactionType.income),
//         BudgetTransaction(amount: 300, type: TransactionType.income),
//       ],
//     ),
//   ];

//   void addTransaction(
//     BudgetModel budget,
//     double amount,
//     TransactionType type,
//   ) {
//     setState(() {
//       budget.transactions.add(
//         BudgetTransaction(amount: amount, type: type),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Budgets'),
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: budgets.length,
//         itemBuilder: (context, index) {
//           final budget = budgets[index];

//           return Card(
//             margin: const EdgeInsets.only(bottom: 16),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Title
//                   Text(
//                     budget.title,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),

//                   const SizedBox(height: 8),

//                   if (budget.savedAmount > 0) ...[
//                     Text(
//                       'Saved: ₹${budget.savedAmount.toStringAsFixed(0)}',
//                       style: const TextStyle(color: Colors.green),
//                     ),
//                   ] else ...[
//                     Text(
//                       'Used: ₹${budget.usedAmount.toStringAsFixed(0)} / ₹${budget.limit.toStringAsFixed(0)}',
//                     ),
//                   ],

//                   const SizedBox(height: 8),

//                   // Progress bar
//                   LinearProgressIndicator(
//                     value: budget.progress,
//                     minHeight: 8,
//                     backgroundColor: Colors.grey.shade300,
//                   ),

//                   const SizedBox(height: 8),

//                   // Remaining
//                   Text(
//                     'Remaining: ₹${budget.remaining.toStringAsFixed(0)}',
//                     style: TextStyle(
//                       color: budget.remaining < 0 ? Colors.red : Colors.green,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),

//                   const SizedBox(height: 16),

//                   // Buttons
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             addTransaction(
//                               budget,
//                               500,
//                               TransactionType.expense,
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red,
//                           ),
//                           child: const Text('Add Expense ₹500'),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             addTransaction(
//                               budget,
//                               300,
//                               TransactionType.income,
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                           ),
//                           child: const Text('Add Income ₹300'),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         backgroundColor: Colors.grey[100],
//         body: const Center(
//           child: TransactionOverviewCard(),
//         ),
//       ),
//     );
//   }
// }

// class TransactionOverviewCard extends StatelessWidget {
//   const TransactionOverviewCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header Row
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Last records overview',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               Icon(Icons.more_vert, color: Colors.grey[600]),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'LAST 30 DAYS',
//             style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(height: 20),

//           // First Record
//           const TransactionItem(
//             icon: Icons.swap_horiz,
//             iconColor: Colors.lightGreen,
//             title: 'Transfer, withdrawal',
//             amount: '-₹500',
//             amountColor: Colors.red,
//             description: 'Heysvsysbshs shs sgs sgs sgs shs sgs shs sgs shs sgs shs sgs shs s s',
//             date: 'Feb 10',
//             subInfo: '→ ...outside of Wallet',
//           ),

//           const Divider(height: 32),

//           // Second Record
//           const TransactionItem(
//             icon: Icons.restaurant,
//             iconColor: Colors.orange,
//             title: 'Food & Drinks',
//             amount: '₹900,000,000,000.00',
//             amountColor: Colors.teal,
//             description: 'He7eveusbdis dud dud dkd did did dud xjd xjd dhd dud xjd dud dud xjd xkc xjd xjd xjx xkc dud did d zud. D d d',
//             date: 'Feb 10',
//           ),

//           const SizedBox(height: 20),
//           Text(
//             'Show more',
//             style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TransactionItem extends StatelessWidget {
//   const TransactionItem({
//     required this.icon,
//     required this.iconColor,
//     required this.title,
//     required this.amount,
//     required this.amountColor,
//     required this.description,
//     required this.date,
//     super.key,
//     this.subInfo,
//   });
//   final IconData icon;
//   final Color iconColor;
//   final String title;
//   final String amount;
//   final Color amountColor;
//   final String description;
//   final String date;
//   final String? subInfo;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Left Icon
//         CircleAvatar(
//           backgroundColor: iconColor,
//           radius: 20,
//           child: Icon(icon, color: Colors.white),
//         ),
//         const SizedBox(width: 12),

//         // Right side content
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // FIRST ROW: Title and Amount
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       title,
//                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   Text(
//                     amount,
//                     style: TextStyle(fontWeight: FontWeight.bold, color: amountColor, fontSize: 14),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 4),

//               // SECOND ROW: Full Description and Date
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       description,
//                       style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                       // No maxLines here ensures full text is shown
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     date,
//                     style: TextStyle(color: Colors.grey[500], fontSize: 13),
//                   ),
//                 ],
//               ),

//               // OPTIONAL SUB-INFO
//               if (subInfo != null) ...[
//                 const SizedBox(height: 4),
//                 Text(
//                   subInfo!,
//                   style: TextStyle(color: Colors.grey[500], fontSize: 13),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         backgroundColor: Colors.grey[100],
//         body: const Center(
//           child: TransactionOverviewCard(),
//         ),
//       ),
//     );
//   }
// }

// class TransactionOverviewCard extends StatelessWidget {
//   const TransactionOverviewCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       // We use SingleChildScrollView in case the total card becomes taller than the screen
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header Row
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Last records overview',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 Icon(Icons.more_vert, color: Colors.grey[600]),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'LAST 30 DAYS',
//               style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 20),

//             // First Record with HUGE Amount
//             const TransactionItem(
//               icon: Icons.swap_horiz,
//               iconColor: Colors.lightGreen,
//               title: 'Transfer, withdrawal ghkfhgkf fhgkjhfgk. jkfhgkjfh',
//               // Example of extremely large amount string
//               amount: '-₹50086758675868756875687568756875658756785687567856875756758757565676576576576576576576576576576576565765765765765765765765765765765765765765765765765765765765765',
//               amountColor: Colors.red,
//               description: 'Heysvsysbshs shs sgs sgs sgs shs sgs shs sgs shs sgs shs sgs shs s s',
//               date: 'Feb 10',
//               subInfo: '→ ...outside of Wallet',
//             ),

//             const Divider(height: 32),

//             // Second Record
//             const TransactionItem(
//               icon: Icons.restaurant,
//               iconColor: Colors.orange,
//               title: 'Food & Drinks',
//               amount: '₹900,000,000,000.00',
//               amountColor: Colors.teal,
//               description: 'He7eveusbdis dud dud dkd did did dud xjd xjd dhd dud xjd dud dud xjd xkc xjd xjd xjx xkc dud did d zud. D d d',
//               date: 'Feb 10',
//             ),

//             const SizedBox(height: 20),
//             Text(
//               'Show more',
//               style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// extension AmountFormatter on num {
//   String formatAmt({int decimal = 1}) {
//     final isNegative = this < 0;
//     final value = abs();

//     final formatted = NumberFormat.compact().format(value).toUpperCase();

//     return isNegative ? '-$formatted' : formatted;
//   }
// }

// class TransactionItem extends StatelessWidget {
//   const TransactionItem({
//     required this.icon,
//     required this.iconColor,
//     required this.title,
//     required this.amount,
//     required this.amountColor,
//     required this.description,
//     required this.date,
//     super.key,
//     this.subInfo,
//   });

//   final IconData icon;
//   final Color iconColor;
//   final String title;
//   final String amount;
//   final Color amountColor;
//   final String description;
//   final String date;
//   final String? subInfo;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Left Icon (Fixed width)
//         CircleAvatar(
//           backgroundColor: iconColor,
//           radius: 20,
//           child: Icon(icon, color: Colors.white),
//         ),
//         const SizedBox(width: 12),

//         // Right side content (Flexible width)
//         // Expanded(
//         //   child: Column(
//         //     crossAxisAlignment: CrossAxisAlignment.start,
//         //     children: [
//         //       // FIRST ROW: Title and Amount
//         //       Row(
//         //         crossAxisAlignment: CrossAxisAlignment.start,
//         //         children: [
//         //           // We wrap Title in Expanded so it shares space
//         //           Expanded(
//         //             flex: 2, // Gives the title a bit of priority
//         //             child: Text(
//         //               title,
//         //               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),

//         //               // Removed maxLines so it shows full text
//         //             ),
//         //           ),
//         //           const SizedBox(width: 8),
//         //           // WE WRAP AMOUNT IN EXPANDED TOO
//         //           // This forces the long number string to wrap to the next line
//         //           Expanded(
//         //             flex: 3, // Gives amount more space to show long numbers
//         //             child: Text(
//         //               amount,
//         //               textAlign: TextAlign.right, // Keeps amount aligned to the right
//         //               style: TextStyle(
//         //                 fontWeight: FontWeight.bold,
//         //                 color: amountColor,
//         //                 fontSize: 14,
//         //               ),
//         //             ),
//         //           ),
//         //         ],
//         //       ),
//         //       const SizedBox(height: 4),

//         //       // SECOND ROW: Full Description and Date
//         //       Row(
//         //         crossAxisAlignment: CrossAxisAlignment.start,
//         //         children: [
//         //           Expanded(
//         //             child: Text(
//         //               description,
//         //               style: TextStyle(color: Colors.grey[600], fontSize: 14),
//         //             ),
//         //           ),
//         //           const SizedBox(width: 8),
//         //           Text(
//         //             date,
//         //             style: TextStyle(color: Colors.grey[500], fontSize: 13),
//         //           ),
//         //         ],
//         //       ),

//         //       // OPTIONAL SUB-INFO
//         //       if (subInfo != null) ...[
//         //         const SizedBox(height: 4),
//         //         Text(
//         //           subInfo!,
//         //           style: TextStyle(color: Colors.grey[500], fontSize: 13),
//         //         ),
//         //       ],
//         //     ],
//         //   ),
//         // ),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // FIRST ROW: Title and Amount
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // TITLE: Wrapped in Expanded
//                   // It will take all space NOT used by the amount
//                   Expanded(
//                     flex: 3, // Higher flex ensures title gets priority
//                     child: Text(
//                       title,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                       // softWrap is true by default, maxLines is null by default
//                     ),
//                   ),

//                   const SizedBox(width: 8),

//                   // AMOUNT: Wrapped in Flexible
//                   // Flexible allows it to be SMALL if the number is small
//                   Flexible(
//                     flex: 2, // Limits how wide the amount can get before wrapping
//                     child: Text(
//                       amount,
//                       textAlign: TextAlign.right,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: amountColor,
//                         fontSize: 14,
//                       ),
//                       // We don't set maxLines so it can wrap if it's a huge number
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 4),

//               // SECOND ROW: Description and Date
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       description,
//                       style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     date,
//                     style: TextStyle(color: Colors.grey[500], fontSize: 13),
//                   ),
//                 ],
//               ),

//               if (subInfo != null) ...[
//                 const SizedBox(height: 4),
//                 Text(
//                   subInfo!,
//                   style: TextStyle(color: Colors.grey[500], fontSize: 13),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
