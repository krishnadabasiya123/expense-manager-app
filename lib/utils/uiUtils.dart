import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:expenseapp/commons/widgets/ErrorOverlayWidget.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/Home/Model/HomeMenuItem.dart';
import 'package:expenseapp/features/Home/Model/enums/HomeMenuType.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Enums/RecurringFrequency.dart';
import 'package:expenseapp/features/budget/models/enums/BudgetPeriod.dart';
import 'package:expenseapp/features/budget/models/enums/BudgetType.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class UiUtils {
  static Locale getLocaleFromLanguageCode(String languageCode) {
    final result = languageCode.split('-');

    return result.length == 1 ? Locale(result.first) : Locale(result.first, result.last);
  }

  static String getRecurringFrequencyString(RecurringFrequency recurring) {
    switch (recurring) {
      case RecurringFrequency.weekly:
        return 'Weekly';
      case RecurringFrequency.daily:
        return 'Daily';
      case RecurringFrequency.monthly:
        return 'Monthly';
      case RecurringFrequency.yearly:
        return 'Yearly';
      case RecurringFrequency.none:
        return 'None';
    }
  }

  static RecurringFrequency? convertStringToRecurringFrequency(String recurringFrequency) {
    switch (recurringFrequency) {
      case 'Weekly':
        return RecurringFrequency.weekly;
      case 'Monthly':
        return RecurringFrequency.monthly;
      case 'Yearly':
        return RecurringFrequency.yearly;
      case 'Daily':
        return RecurringFrequency.daily;
      case 'None':
        return RecurringFrequency.none;
    }
    return null;
  }

  static String getTransactionTypeString(TransactionType transactionType) {
    switch (transactionType) {
      case TransactionType.INCOME:
        return 'Income';

      case TransactionType.EXPENSE:
        return 'Expense';

      case TransactionType.TRANSFER:
        return 'Transfer';

      case TransactionType.DEBIT:
        return 'Debit';

      case TransactionType.CREDIT:
        return 'Credit';

      case TransactionType.LOAN:
        return 'Loan';

      case TransactionType.LOAN_INTEREST:
        return 'Loan Interest';

      case TransactionType.ALL:
        return 'All';

      case TransactionType.RECURRING:
        return 'Recurring';

      case TransactionType.NONE:
        return 'None';
    }
  }

  static String getStringBudgetType(BudgetType type) {
    switch (type) {
      case BudgetType.INCOME:
        return 'Income';

      case BudgetType.EXPENSE:
        return 'Expense';
    }
  }

  static String getStringBudgetPeriod(BudgetPeriod period) {
    switch (period) {
      case BudgetPeriod.WEEKLY:
        return 'Weekly';

      case BudgetPeriod.MONTHLY:
        return 'Monthly';

      case BudgetPeriod.YEARLY:
        return 'Yearly';

      case BudgetPeriod.CUSTOM:
        return 'Custom';
    }
  }

  // static String getFilterTransactionTypeString(FilterType filterType) {
  //   switch (filterType) {
  //     case FilterType.all:
  //       return 'All';

  //     case FilterType.income:
  //       return 'Income';

  //     case FilterType.expense:
  //       return 'Expense';
  //   }
  // }

  // static String partyTypeToString(PartyType type) {
  //   switch (type) {
  //     case PartyType.customer:
  //       return 'Customer';
  //     case PartyType.wholesaler:
  //       return 'Wholesaler';
  //     case PartyType.retailer:
  //       return 'Retailer';
  //     case PartyType.supplier:
  //       return 'Supplier';
  //   }
  // }

  static Future<DateTime?> selectDate(BuildContext context, TextEditingController dateController, {bool isChangeEndDate = false}) async {
    final colorScheme = Theme.of(context).colorScheme;

    final today = DateTime.now();
    log('today $today');

    // final selectedDate = dateController.text.isNotEmpty ? UiUtils.parseDate(dateController.text) : today;
    // log('selectedDate $selectedDate');
    var selectedDate = today;

    if (dateController.text.isNotEmpty) {
      try {
        var text = dateController.text;

        if (text.contains(':')) {
          text = text.split(':').last.trim();
        }

        if (text.contains('-')) {
          final parts = text.split(' ');
          text = parts.first;
        }

        selectedDate = UiUtils.parseDate(text);
      } catch (e) {
        selectedDate = today;
      }
    }

    DateTime initialDate;
    DateTime firstDate;

    if (isChangeEndDate) {
      // end date (recurring)
      firstDate = selectedDate.add(const Duration(days: 1));
      initialDate = firstDate;
    } else {
      initialDate = selectedDate.isBefore(today) ? today : selectedDate;
      firstDate = today;
    }

    return showDatePicker(
      barrierDismissible: false,
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(primary: Colors.white, surface: colorScheme.primary),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: const BorderSide(color: Colors.white),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  static Future<void> pickTime(BuildContext context, TextEditingController timeController) async {
    final colorScheme = Theme.of(context).colorScheme;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            timePickerTheme: TimePickerThemeData(
              // Change the color of the AM/PM text
              dayPeriodTextColor: colorScheme.primary,
              backgroundColor: colorScheme.surface,

              // You can also change the primary color used for other selected items
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      timeController.text = time.format(context);
    }
  }

  static Future<void> showCustomSnackBar({required BuildContext context, required String errorMessage, Color? backgroundColor, Duration delayDuration = errorMessageDisplayDuration}) async {
    final overlayState = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => ErrorMessageOverlayContainer(backgroundColor: backgroundColor ?? context.colorScheme.onSecondary, errorMessage: errorMessage),
    );

    overlayState.insert(overlayEntry);
    await Future.delayed(delayDuration, overlayEntry.remove);
  }

  static const hzMarginPct = 0.04;
  static const vtMarginPct = 0.05;

  static const bottomSheetTopRadius = BorderRadius.vertical(top: Radius.circular(20));

  static Future<bool> hasStoragePermissionGiven() async {
    if (Platform.isIOS) {
      var permissionGiven = await Permission.storage.isGranted;
      if (!permissionGiven) {
        permissionGiven = (await Permission.storage.request()).isGranted;
        return permissionGiven;
      }
      return permissionGiven;
    }
    //if it is for android
    final deviceInfoPlugin = DeviceInfoPlugin();
    final androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    if (androidDeviceInfo.version.sdkInt < 33) {
      var permissionGiven = await Permission.storage.isGranted;
      if (!permissionGiven) {
        permissionGiven = (await Permission.storage.request()).isGranted;
        return permissionGiven;
      }
      return permissionGiven;
    } else {
      var permissionGiven = await Permission.photos.isGranted;
      if (!permissionGiven) {
        permissionGiven = (await Permission.photos.request()).isGranted;
        return permissionGiven;
      }
      return permissionGiven;
    }
  }

  static final month = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  static final List<HomeMenuItem> homeMenuList = [
    // HomeMenuItem(id: 0, iconCode: Icons.edit.codePoint, title: 'homePageKey', type: HomeMenuType.HOME_PAGE_BANNER),
    //HomeMenuItem(id: 1, iconCode: Icons.list.codePoint, title: 'accountListKey', type: HomeMenuType.ACCOUNT_LIST),
    HomeMenuItem(id: 0, iconCode: Icons.pie_chart_sharp.codePoint, title: 'budgetKey', type: HomeMenuType.BUDGETS),
    HomeMenuItem(id: 1, iconCode: Icons.calendar_view_day_rounded.codePoint, title: 'upcomingTransactionsKey', type: HomeMenuType.UPCOMING_TRANSACTION),
    HomeMenuItem(id: 2, iconCode: Icons.abc.codePoint, title: 'goalsKey', type: HomeMenuType.GOALS),
    HomeMenuItem(id: 3, iconCode: Icons.import_export.codePoint, title: 'incomeExpenseKey', type: HomeMenuType.INCOME_EXPENSE),
    HomeMenuItem(id: 4, iconCode: Icons.balance.codePoint, title: 'netWorthKey', type: HomeMenuType.NET_WORTH),
    HomeMenuItem(id: 5, iconCode: Icons.label.codePoint, title: 'loansKey', type: HomeMenuType.LOANS),
    HomeMenuItem(id: 6, iconCode: Icons.pie_chart.codePoint, title: 'graphsKey', type: HomeMenuType.GRAPHS),
    HomeMenuItem(id: 7, iconCode: Icons.abc.codePoint, title: 'transactionListKey', type: HomeMenuType.TRANSACTION_LIST),
  ];
  static String convertCustomDate(String date) {
    // Example input: "24.12.2025"
    final parsedDate = DateFormat('dd.MM.yyyy').parse(date);

    final now = DateTime.now();

    final isToday = parsedDate.year == now.year && parsedDate.month == now.month && parsedDate.day == now.day;

    if (isToday) {
      return 'Today, ${DateFormat('MMMM yyyy').format(parsedDate)}';
    }

    return DateFormat('MMMM d, yyyy').format(parsedDate);
  }

  static String covertInBuiltDate(DateTime date, BuildContext context) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final inputDate = DateTime(date.year, date.month, date.day);

    final difference = today.difference(inputDate).inDays;

    if (difference == 0) {
      return context.tr('todayKey');
    } else if (difference == -1) {
      return context.tr('yesterdayKey');
    } else {
      return DateFormat('MMMM d, yyyy').format(date);
    }
  }

  static String budgetCustomDate(String date) {
    // Example input: "24.12.2025"
    final parsedDate = DateFormat('dd.MM.yyyy').parse(date);

    //final now = DateTime.now();

    // final isToday = parsedDate.year == now.year && parsedDate.month == now.month && parsedDate.day == now.day;

    // if (isToday) {
    //   return 'Today, ${DateFormat('MMMM yyyy').format(parsedDate)}';
    // }

    return DateFormat('MMM d').format(parsedDate);
  }

  static Widget marqueeText({required String text, required TextStyle textStyle, required double width, TextAlign? textAlign}) {
    // Handle empty text early
    if (text.trim().isEmpty) {
      return SizedBox(width: width, child: const SizedBox.shrink());
    }

    return SizedBox(
      width: width,
      child: Builder(
        builder: (context) {
          // Calculate text width without LayoutBuilder
          final textPainter = TextPainter(
            text: TextSpan(text: text, style: textStyle),
            textDirection: ui.TextDirection.ltr,
            maxLines: 1,
          )..layout();

          final textWidth = textPainter.size.width;

          // Add some padding to account for potential measurement differences
          final effectiveWidth = width;

          if (textWidth > effectiveWidth) {
            // Use Marquee with proper constraints
            return SizedBox(
              height: textPainter.size.height + 2,
              child: Marquee(
                text: text,
                style: textStyle,
                blankSpace: 10,
                velocity: 30,
                pauseAfterRound: const Duration(seconds: 2),
              ),
            );
          } else {
            // Use regular Text widget
            return Text(
              text,
              style: textStyle,
              textAlign: textAlign,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          }
        },
      ),
    );
  }

  static String getFormattedDate(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  static final dateFormatter = DateFormat('dd.MM.yyyy');

  static Future<File> uint8ListToFile(
    Uint8List bytes,
    String fileName,
  ) async {
    final tempDir = await getTemporaryDirectory();

    final safeFileName = sanitizeFileName(fileName);

    final file = File('${tempDir.path}/$safeFileName.jpg');

    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  static String sanitizeFileName(String name) {
    //return name.replaceAll(RegExp(r'[^\w\-\.]-*/.%^*()'), '_');
    return name.replaceAll(
      RegExp(r'[^\w.]|[-*/%^()]'),
      '_',
    );
  }

  static String? getFormatedDate(TextEditingController date) {
    return date.text.contains(':') ? date.text.split(':')[1].split('-').first.trim() : date.text;
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static DateTime parseDate(String date) {
    final parsed = UiUtils.dateFormatter.parse(date);
    return DateTime(parsed.year, parsed.month, parsed.day);
  }
}
