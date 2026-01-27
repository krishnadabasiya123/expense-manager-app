import 'package:device_preview/device_preview.dart';
import 'package:expenseapp/commons/cubit/currency_cubit.dart';
import 'package:expenseapp/commons/cubit/theme_cubit.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/core/localization/app_localization.dart';
import 'package:expenseapp/core/theme/app_theme.dart';
import 'package:expenseapp/features/Account/Cubits/add_account_cubit.dart';
import 'package:expenseapp/features/Account/Cubits/update_account_cubit.dart';
import 'package:expenseapp/features/Home/Cubits/edit_home_cubit.dart';
import 'package:expenseapp/features/Party/Cubits/PartyTransaction/delete_party_transaction_cubit.dart';
import 'package:expenseapp/features/Party/Cubits/PartyTransaction/get_soft_delete_party_transaction_cubit.dart';
import 'package:expenseapp/features/RecurringTransaction/Cubit/get_recurring_transaction_cubit.dart';
import 'package:expenseapp/features/RecurringTransaction/Cubit/update_recurring_transaction_cubit.dart';
import 'package:expenseapp/features/Transaction/Cubits/add_transaction_cubit.dart';
import 'package:expenseapp/features/Transaction/Cubits/delete_transactions_cubit.dart';
import 'package:expenseapp/features/Transaction/Cubits/get_soft_delete_transactions_cubit.dart';
import 'package:expenseapp/features/Transaction/Cubits/update_trasansaction_cubit.dart';
import 'package:expenseapp/features/RecurringTransaction/LocalStorage/recurring_transaction_local_data.dart';
import 'package:expenseapp/features/localization/auth_localization_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<Widget> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<dynamic>(settingsBox);
  // await Hive.openBox<dynamic>(partyBox);
  // await Hive.openBox<dynamic>(partyTransactionBox);
  await AccountLocalStorage.init();
  await TransactionLocalData.init();
  await PartyLocalData.init();
  await PartyTransactionLocalData.init();
  await CategoryLocalStorage.init();
  await RecurringTransactionLocalData.init();

  // Hive
  //   ..registerAdapter(TransactionAdapter())
  //   ..registerAdapter(TransactionTypeAdapter())
  //   ..registerAdapter(ImageDataAdapter())
  //   ..registerAdapter(PartyAdapter())
  //   ..registerAdapter(PartyTransactionAdapter())
  //   ..registerAdapter(CategoryAdapter())
  //   ..registerAdapter(AccountAdapter());

  return const MyAppWrapper();
}

class MyAppWrapper extends StatefulWidget {
  const MyAppWrapper({super.key});

  @override
  State<MyAppWrapper> createState() => _MyAppWrapperState();
}

class _MyAppWrapperState extends State<MyAppWrapper> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MyApp();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider<AppLocalizationCubit>(create: (context) => AppLocalizationCubit(SystemSettingLocalData())),

          BlocProvider<ThemeCubit>(create: (context) => ThemeCubit(SystemSettingLocalData())),

          BlocProvider<EditHomeCubit>(create: (context) => EditHomeCubit()),

          BlocProvider<GetTransactionCubit>(create: (context) => GetTransactionCubit()),

          BlocProvider<CurrencyCubit>(create: (context) => CurrencyCubit(SystemSettingLocalData())),

          BlocProvider<GetAccountCubit>(create: (context) => GetAccountCubit()),

          BlocProvider<GetPartyCubit>(create: (context) => GetPartyCubit()),

          BlocProvider(create: (context) => UpdateTrasansactionCubit()),
          BlocProvider(create: (context) => AddTransactionCubit()),

          BlocProvider(create: (context) => DeletePartyTransactionCubit()),

          BlocProvider(create: (context) => GetCategoryCubit()),

          BlocProvider(create: (context) => GetSoftDeleteTransactionsCubit()),

          BlocProvider(create: (context) => AddAccountCubit()),
          BlocProvider(create: (context) => UpdateAccountCubit()),

          BlocProvider(create: (context) => GetSoftDeletePartyTransactionCubit()),

          //BlocProvider(create: (context) => DeleteTransactionsCubit()),

          BlocProvider(create: (context) => GetRecurringTransactionCubit()),

          BlocProvider(create: (context) => UpdateRecurringTransactionCubit()),
        ],

        child: Builder(
          builder: (context) {
            final currentTheme = context.select<ThemeCubit, AppThemeType>((bloc) => bloc.state.appTheme);
            final currentLanguage = context.watch<AppLocalizationCubit>().state.language;

            return MaterialApp(
              title: 'Expense App',
              debugShowCheckedModeBanner: false,
              theme: appThemeData[currentTheme],
              // home: const SelectCurrencyScreen(),
              initialRoute: Routes.splash,
              onGenerateRoute: Routes.onGenerateRouted,
              locale: currentLanguage,
              localizationsDelegates: [Applocalization.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
              supportedLocales: supportedLocales.map(UiUtils.getLocaleFromLanguageCode).toList(),
            );
          },
        ),
      ),
    );
  }
}
