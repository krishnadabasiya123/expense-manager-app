import 'dart:convert';

import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/Home/Model/HomeMenuItem.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveHomeMenu(List<HomeMenuItem> list) async {
  final prefs = await SharedPreferences.getInstance();

  final jsonList = list.map((item) => jsonEncode(item.toJson())).toList();

  await prefs.setStringList('home_menu', jsonList);
}

Future<List<HomeMenuItem>> loadHomeMenu(List<HomeMenuItem> defaultList) async {
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getStringList('home_menu');

  if (saved == null) return defaultList;

  return saved.map((e) => HomeMenuItem.fromJson(jsonDecode(e) as Map<String, dynamic>)).toList();
}
// class HomeLocalStorage {
//   static late Box<dynamic> box;
//   static Future<void> init() async {
//     box = await Hive.openBox<dynamic>(homeBox);
//   }

//   Future<void> saveHomeMenu(List<HomeMenuItem> list) async {
//     // final prefs = await SharedPreferences.getInstance();

//     final jsonList = list.map((item) => jsonEncode(item.toJson())).toList();

//     await box.put('home_menu', jsonList);

//     //await prefs.setStringList('home_menu', jsonList);
//   }

//   Future<List<HomeMenuItem>> loadHomeMenu(List<HomeMenuItem> defaultList) async {
//     // final prefs = await SharedPreferences.getInstance();
//     // final saved = prefs.getStringList('home_menu');
//     final saved = box.get('home_menu');

//     if (saved == null) return defaultList;

//     return saved.map((e) => HomeMenuItem.fromJson(jsonDecode(e) as Map<String, dynamic>)).toList();
//   }
// }
