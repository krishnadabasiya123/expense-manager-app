import 'package:flutter/material.dart';

enum HomeMenuType { NULL, HOME_PAGE_BANNER, BUDGETS, UPCOMING_TRANSACTION, GOALS, ACCOUNT_LIST, INCOME_EXPENSE, NET_WORTH, LOANS, GRAPHS, TRANSACTION_LIST }

class HomeMenuItem {
  HomeMenuItem({required this.id, required this.iconCode, required this.title, required this.type, this.isOn = false});

  // factory HomeMenuItem.fromJson(Map<String, dynamic> json) {
  //   return HomeMenuItem(id: json['id'] as int, iconCode: json['iconCode'] as int, title: json['title'] as String, isOn: json['isOn'] ?? true, type: HomeMenuType.values[json['type']]);
  // }

  factory HomeMenuItem.fromJson(Map<String, dynamic> json) {
    return HomeMenuItem(
      id: json['id'] as int,
      iconCode: json['iconCode'] as int,
      title: json['title'] as String,
      isOn: json['isOn'] as bool,
      type: HomeMenuType.values.firstWhere((e) => e.name == json['type'], orElse: () => HomeMenuType.NULL),
    );
  }
  final int id;
  final int iconCode;
  final String title;
  bool isOn;
  final HomeMenuType type;

  IconData get icon => IconData(iconCode, fontFamily: 'MaterialIcons');

  Map<String, dynamic> toJson() => {'id': id, 'iconCode': iconCode, 'title': title, 'isOn': isOn, 'type': type.name};

  HomeMenuItem copyWith({int? id, int? iconCode, String? title, bool? isOn, HomeMenuType? type}) {
    return HomeMenuItem(id: id ?? this.id, iconCode: iconCode ?? this.iconCode, title: title ?? this.title, isOn: isOn ?? this.isOn, type: type ?? this.type);
  }
}
