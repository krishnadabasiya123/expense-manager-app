import 'dart:developer';

import 'package:expenseapp/commons/widgets/BottomNavigationPageChange.dart';
import 'package:expenseapp/commons/widgets/full_screen_image_widgrt.dart';
import 'package:expenseapp/commons/widgets/select_currency_screen.dart';
import 'package:expenseapp/commons/widgets/select_language_screen.dart';
import 'package:expenseapp/features/Account/Screen/account_screen.dart';
import 'package:expenseapp/features/Account/Screen/account_transaction_screen.dart';
import 'package:expenseapp/features/Calendar/Screen/calendar_screen.dart';
import 'package:expenseapp/features/Category/Screen/category_screen.dart';
import 'package:expenseapp/features/Home/Screen/edit_home_screen.dart';
import 'package:expenseapp/features/Home/Screen/home_page.dart';
import 'package:expenseapp/features/Restore/Screen/restore_data_screen.dart';
import 'package:expenseapp/features/Home/introSliderScreen.dart';
import 'package:expenseapp/features/Home/splashScreen.dart';
import 'package:expenseapp/features/Party/Screen/add_party_transaction_screen.dart';
import 'package:expenseapp/features/Party/Screen/party_screen.dart';
import 'package:expenseapp/features/Party/Screen/party_transaction_screen.dart';
import 'package:expenseapp/features/Profile/Screen/edit_profile_screen.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/RecurringTransaction.dart';
import 'package:expenseapp/features/RecurringTransaction/Screen/edit_recurring_screen.dart';
import 'package:expenseapp/features/RecurringTransaction/Screen/main_recurring_transaction.dart';
import 'package:expenseapp/features/RecurringTransaction/Screen/recurring_transaction.dart';
import 'package:expenseapp/features/Transaction/Screen/transaction_screen.dart';
import 'package:expenseapp/features/Transaction/Screen/transaction_tabBar_view_screen.dart';
import 'package:expenseapp/features/budget/screens/add_budget_screen.dart';
import 'package:expenseapp/features/budget/screens/budget_history_screen.dart';
import 'package:expenseapp/features/budget/screens/budget_screen.dart';
import 'package:expenseapp/features/login/sign_in_screen.dart';
import 'package:expenseapp/features/login/sign_up_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Routes {
  static const splash = 'splash';
  static const login = 'login';
  static const selectLanguage = 'selectLanguage';
  static const intro = 'intro';
  static const signUp = 'signUp';
  static const selectCurrency = 'selectCurrency';
  static const home = 'home';
  static const bottomNavigationBar = 'bottomNavigationBar';
  static const account = 'account';
  static const partyList = 'partyList';
  static const partyTransactionList = 'partyTransactionList';
  static const category = 'category';
  static const listTransaction = 'transaction';
  static const transactionTabBarView = 'transactionTabBarView';
  static const fullScreenImageView = 'fullScreenImageView';
  static const addPartyTransaction = 'addPartyTransaction';
  static const editHomeScreen = 'editHomeScreen';
  static const editProfile = 'editProfile';
  static const accountTransaction = 'accountTransaction';
  static const restoreData = 'restoreData';
  static const mainrecurringTransactionList = 'mainrecurringTransactionList';
  static const recurringTransaction = 'recurringTransaction';
  static const editMainRecurringTransaction = 'editMainRecurringTransaction';
  static const calendar = 'calendar';
  static const budget = 'budget';
  static const addBudget = 'addBudget';
  static const budgetHistory = 'budgetHistory';

  static String currentRoute = splash;

  static Route<dynamic>? onGenerateRouted(RouteSettings routeSettings) {
    currentRoute = routeSettings.name ?? '';

    log('currentRoute : $currentRoute');

    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const SignInScreen());

      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case selectLanguage:
        return MaterialPageRoute(builder: (_) => const InitialLanguageSelectionScreen());

      case intro:
        return MaterialPageRoute(builder: (_) => const IntrosliderScreen());

      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());

      case selectCurrency:
        return MaterialPageRoute(builder: (_) => const SelectCurrencyScreen());

      case bottomNavigationBar:
        return CupertinoPageRoute(builder: (_) => BottomNavigationPageChnage(key: bottomNavKey));

      case account:
        return MaterialPageRoute(builder: (_) => const AccountScreen());

      case partyList:
        return MaterialPageRoute(builder: (_) => const PartyScreen());

      case partyTransactionList:
        return PartyTransactionScreen.route(routeSettings);

      case category:
        return MaterialPageRoute(builder: (_) => const CategoryScreen());

      case listTransaction:
        return MaterialPageRoute(builder: (_) => const TransactionScreen());

      case addPartyTransaction:
        return AddPartyTransactionWidget.route(routeSettings);

      case transactionTabBarView:
        return TransactionTabBarViewScreen.route(routeSettings);

      case fullScreenImageView:
        return FullScreenImageView.route(routeSettings);

      case editHomeScreen:
        return MaterialPageRoute(builder: (_) => const EditHomeScreen());

      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());

      case accountTransaction:
        return AccountTransactionScreen.route(routeSettings);

      case restoreData:
        return MaterialPageRoute(builder: (_) => const RestoreDataScreen());

      case mainrecurringTransactionList:
        return MaterialPageRoute(builder: (_) => const RecurringTransactionList());

      case recurringTransaction:
        return RecurringTransactionScreen.route(routeSettings);

      case editMainRecurringTransaction:
        return EditRecurringScreen.route(routeSettings);

      case calendar:
        return MaterialPageRoute(builder: (_) => const CalendarScreen());

      case budget:
        return MaterialPageRoute(builder: (_) => const BudgetScreen());

      case addBudget:
        return MaterialPageRoute(builder: (_) => const AddBudgetScreen());

      case budgetHistory:
        return BudgetHistoryScreen.route(routeSettings);

      default:
        return CupertinoPageRoute(builder: (_) => const Scaffold());
    }
  }
}
