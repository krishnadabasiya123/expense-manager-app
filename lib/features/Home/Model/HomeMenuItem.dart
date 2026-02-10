import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/Home/Model/enums/HomeMenuType.dart';
import 'package:flutter/material.dart';

part 'HomeMenuItem.g.dart';

@HiveType(typeId: 13)
class HomeMenuItem {
  HomeMenuItem({required this.id, required this.iconCode, required this.title, required this.type, this.isOn = false});

  factory HomeMenuItem.fromJson(Map<String, dynamic> json) {
    return HomeMenuItem(
      id: json['id'] as int,
      iconCode: json['iconCode'] as int,
      title: json['title'] as String,
      isOn: json['isOn'] as bool,
      type: HomeMenuType.values.firstWhere((e) => e.name == json['type'], orElse: () => HomeMenuType.NULL),
    );
  }

  @HiveField(0)
  final int id;

  @HiveField(1)
  final int iconCode;

  @HiveField(2)
  final String title;

  @HiveField(3)
  bool isOn;

  @HiveField(4)
  final HomeMenuType type;

  IconData get icon {
    switch (type) {
      case HomeMenuType.HOME_PAGE_BANNER:
        return Icons.edit;
      case HomeMenuType.BUDGETS:
        return Icons.pie_chart_sharp;
      case HomeMenuType.UPCOMING_TRANSACTION:
        return Icons.calendar_view_day_rounded;
      case HomeMenuType.GOALS:
        return Icons.abc;
      case HomeMenuType.ACCOUNT_LIST:
        return Icons.list;
      case HomeMenuType.INCOME_EXPENSE:
        return Icons.import_export;
      case HomeMenuType.NET_WORTH:
        return Icons.balance;
      case HomeMenuType.LOANS:
        return Icons.label;
      case HomeMenuType.GRAPHS:
        return Icons.pie_chart;
      case HomeMenuType.TRANSACTION_LIST:
        return Icons.abc;
      case HomeMenuType.NULL:
      default:
        return Icons.help_outline;
    }
  }

  Map<String, dynamic> toJson() => {'id': id, 'iconCode': iconCode, 'title': title, 'isOn': isOn, 'type': type.name};

  HomeMenuItem copyWith({int? id, int? iconCode, String? title, bool? isOn, HomeMenuType? type}) {
    return HomeMenuItem(id: id ?? this.id, iconCode: iconCode ?? this.iconCode, title: title ?? this.title, isOn: isOn ?? this.isOn, type: type ?? this.type);
  }
}
