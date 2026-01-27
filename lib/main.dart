import 'package:flutter/material.dart';
import 'package:expenseapp/core/app/app.dart';

void main() async {
  runApp(await initializeApp());
}

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
//         color = Colors.green;
//       case AppDialogType.error:
//         icon = Icons.error;
//         color = Colors.red;
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
