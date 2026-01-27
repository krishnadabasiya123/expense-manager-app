import 'dart:math';

import 'package:expenseapp/commons/cubit/currency_cubit.dart';
import 'package:expenseapp/core/localization/app_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expenseapp/core/app/all_import_file.dart';

extension UniqueStringExtension on String {
  String withDateTimeMillisRandom({int randomLength = 6}) {
    final now = DateTime.now();

    final dateTime =
        '${now.year}-${_two(now.month)}-${_two(now.day)}_'
        '${_two(now.hour)}-${_two(now.minute)}-${_two(now.second)}';

    final milliseconds = now.millisecondsSinceEpoch;

    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-*/.%^*()';
    final random = Random();
    final randomPattern = List.generate(
      randomLength,
      (_) => chars[random.nextInt(chars.length)],
    ).join();

    return '${this}_${dateTime}_${milliseconds}_$randomPattern';
  }

  String _two(int value) => value.toString().padLeft(2, '0');
}

extension CurrencyContext on BuildContext {
  String get symbol => watch<CurrencyCubit>().symbol;
}

extension CustomContext on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}

extension DateCompare on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isPast {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(year, month, day);
    return dateOnly.isBefore(today);
  }

  /// true if this date is after today (ignores time)
  bool get isFuture {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(year, month, day);
    return dateOnly.isAfter(today);
  }
}

// extension AmountFormatter on num {
//   String formatimport 'package:intl/intl.dart';

extension AmountFormatter on num {
  String formatAmt({int decimal = 1}) {
    final isNegative = this < 0;
    final value = abs();

    final formatted = NumberFormat.compact().format(value).toUpperCase();

    return isNegative ? '-$formatted' : formatted;
  }
}

//({int decimal = 1}) {
//     final isNegative = this < 0;
//     final value = abs();

//     String formatted;

//      final value = num.tryParse(numberString) ?? 0;

//     // .compact() turns 1000 -> 1K, 1000000 -> 1M
//     // .toLowerCase() turns 1K -> 1k
//     return NumberFormat.compact().format(value).toUpperCase();

//     // if (value >= 1000000000) {
//     //   formatted = '${(value / 1000000000).toStringAsFixed(decimal)}B';
//     // } else if (value >= 1000000) {
//     //   formatted = '${(value / 1000000).toStringAsFixed(decimal)}M';
//     // } else if (value >= 1000) {
//     //   formatted = '${(value / 1000).toStringAsFixed(decimal)}K';
//     // } else {
//     //   formatted = value.toStringAsFixed(2);
//     // }

//     return isNegative ? '-$formatted' : formatted;
//   }
// }

extension AppDialogExt on BuildContext {
  Future<T?> showAppDialog<T>({
    bool barrierDismissible = true,
    Widget? child,
  }) {
    return showGeneralDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, _, __) {
        return Center(child: child);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return Transform.scale(
          scale: Curves.easeOutBack.transform(animation.value),
          child: Opacity(opacity: animation.value, child: child),
        );
      },
    );
  }
}
