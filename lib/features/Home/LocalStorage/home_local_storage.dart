import 'dart:convert';

import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/Home/Model/HomeMenuItem.dart';
import 'package:expenseapp/features/Home/Model/enums/HomeMenuType.dart';


class HomeLocalStorage {
  static late Box<List<String>> box;
  static Future<void> init() async {
    Hive
      ..registerAdapter(HomeMenuItemAdapter())
      ..registerAdapter(HomeMenuTypeAdapter());
    box = await Hive.openBox<List<String>>(homeBox);
  }

  Future<void> saveHomeMenu(List<HomeMenuItem> list) async {
    // final prefs = await SharedPreferences.getInstance();

    final jsonList = list.map((item) => jsonEncode(item.toJson())).toList();

    await box.put('home_menu', jsonList);

    //await prefs.setStringList('home_menu', jsonList);
  }

  Future<List<HomeMenuItem>> loadHomeMenu(List<HomeMenuItem> defaultList) async {
    // final prefs = await SharedPreferences.getInstance();
    // final saved = prefs.getStringList('home_menu');
    final saved = box.get('home_menu');

    if (saved == null) return defaultList;

    return saved.map((e) => HomeMenuItem.fromJson(jsonDecode(e) as Map<String, dynamic>)).toList();
  }
}
