import 'dart:ui';

import 'package:expenseapp/commons/widgets/currency_selector_sheet.dart';
import 'package:expenseapp/commons/widgets/language_selector_sheet.dart';
import 'package:expenseapp/commons/widgets/theme_selector_sheet.dart';
import 'package:expenseapp/core/app/all_import_file.dart';

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<({IconData icon, String title})> menu = [
    (title: 'appSettingsKey', icon: Icons.settings),
    (title: 'calenderKey', icon: Icons.calendar_month_sharp),
    (title: 'budgetKey', icon: Icons.settings),
    (title: 'goalsKey', icon: Icons.settings),
    (title: 'accountKey', icon: Icons.account_balance),
    (title: 'partyKey', icon: Icons.party_mode),
    (title: 'splitterKey', icon: Icons.splitscreen_outlined),
    (title: 'imgListKey', icon: Icons.image),
    (title: 'categoryKey', icon: Icons.category),
    (title: 'importExportKey', icon: Icons.import_export),
    (title: 'recurringKey', icon: Icons.repeat),
    (title: 'reportsKey', icon: Icons.report),
    (title: 'accountSettingsKey', icon: Icons.login),
    (title: 'aboutKey', icon: Icons.info_outline),
  ];

  final List<({IconData icon, String title})> aboutMenuList = [
    (title: 'helpCenterKey', icon: Icons.help),
    (title: 'privacyPolicyKey', icon: Icons.privacy_tip),
    (title: 'termsAndConditionsKey', icon: Icons.info_outline),
    (title: 'versionKey', icon: Icons.new_releases),
  ];

  final List<({IconData icon, String title})> appSettingsMenuList = [
    (title: 'languageKey', icon: Icons.language),
    (title: 'themeKey', icon: Icons.color_lens),
    (title: 'currencyKey', icon: Icons.currency_bitcoin),
    (title: 'notificationKey', icon: Icons.notification_add),
    (title: 'lockAppKey', icon: Icons.lock),
  ];

  final List<({IconData icon, String title})> accountSettingsMenuList = [
    (title: 'deleteAccountKey', icon: Icons.delete),
    (title: 'logoutKey', icon: Icons.logout),
    (title: 'loginKey', icon: Icons.login),
    (title: 'restoreKey', icon: Icons.restore),
  ];

  final List<({IconData icon, String title})> importExportMenuList = [
    (title: 'importKey', icon: Icons.import_export),
    (title: 'exportKey', icon: Icons.import_export),
    (title: 'backupAndRestoreKey', icon: Icons.import_export),
    (title: 'clearAllDataKey', icon: Icons.import_export),
  ];

  bool isLockEnabled = false;
  bool isAuthenticating = false;

  ValueNotifier<bool> isDataManaKeyDiologueOpen = ValueNotifier<bool>(false);
  ValueNotifier<bool> isAppSettingsOpen = ValueNotifier<bool>(false);
  ValueNotifier<bool> isAccountSettingsOpen = ValueNotifier<bool>(false);
  ValueNotifier<bool> isAboutOpen = ValueNotifier<bool>(false);
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void dispose() {
    isDataManaKeyDiologueOpen.dispose();
    isAppSettingsOpen.dispose();
    isAccountSettingsOpen.dispose();
    isAboutOpen.dispose();

    super.dispose();
  }

  Future<bool> authenticateUser() async {
    try {
      return await auth.authenticate(
        localizedReason: 'Authenticate to enable app lock',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: context.height * 0.18,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                ),
              ),
              Positioned(
                top: context.height * 0.07,
                left: 0,
                right: 0,
                child: Center(
                  child: CustomTextView(text: context.tr('profileLbl'), fontSize: 22.sp(context), fontWeight: FontWeight.bold, color: colorScheme.onPrimary),
                ),
              ),
              _buildProfileCard(context, colorScheme),
            ],
          ),
          SizedBox(height: context.isTablet ? context.height * 0.03 : context.height * 0.05),
          Expanded(child: _buildMenuItem(colorScheme)),
        ],
      ),
    );
  }

  Widget _buildMenuItem(ColorScheme colorScheme) {
    return ResponsivePadding(
      leftPadding: context.width * 0.05,
      rightPadding: context.width * 0.05,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsetsDirectional.zero,
        itemCount: menu.length,
        itemBuilder: (context, index) {
          final menuData = menu[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                _onPressed(menuData.title, context);
              });
            },

            child: Container(
              margin: EdgeInsetsDirectional.only(bottom: context.height * 0.01),
              padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.02, vertical: context.height * 0.01),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: colorScheme.surface),
              child: ValueListenableBuilder(
                valueListenable: isAboutOpen,
                builder: (context, value, child) {
                  return ValueListenableBuilder(
                    valueListenable: isAppSettingsOpen,
                    builder: (context, value, child) {
                      return ValueListenableBuilder(
                        valueListenable: isAccountSettingsOpen,
                        builder: (context, value, child) {
                          return ValueListenableBuilder(
                            valueListenable: isDataManaKeyDiologueOpen,
                            builder: (context, value, child) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.all(5),
                                    child: Row(
                                      children: [
                                        SizedBox(width: context.width * 0.02),

                                        Expanded(
                                          child: CustomTextView(text: context.tr(menuData.title), fontSize: 15.sp(context), color: colorScheme.onSecondary),
                                        ),

                                        if (menu[index].title == 'importExportKey') _buildIconMenu(colorScheme, isDataManaKeyDiologueOpen),

                                        if (menu[index].title == 'appSettingsKey') _buildIconMenu(colorScheme, isAppSettingsOpen),

                                        if (menu[index].title == 'accountSettingsKey') _buildIconMenu(colorScheme, isAccountSettingsOpen),

                                        if (menu[index].title == 'aboutKey') _buildIconMenu(colorScheme, isAboutOpen),
                                      ],
                                    ),
                                  ),

                                  if (isAboutOpen.value && menu[index].title == 'aboutKey') ...[
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),

                                      padding: EdgeInsetsDirectional.zero,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            // Navigator.push backup
                                          },
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.02, vertical: context.height * 0.01),
                                            child: Row(
                                              children: [
                                                Icon(aboutMenuList[index].icon, size: 15.sp(context), color: colorScheme.onSecondary),
                                                SizedBox(width: context.width * 0.02),
                                                CustomTextView(text: context.tr(aboutMenuList[index].title), fontSize: 15.sp(context)),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        if (index == aboutMenuList.length - 1) {
                                          return SizedBox(height: context.height * 0.01);
                                        }
                                        return const CustomHorizontalDivider(padding: EdgeInsetsDirectional.all(2), endOpacity: 0.57);
                                      },
                                      itemCount: aboutMenuList.length,
                                    ),
                                  ],

                                  if (isDataManaKeyDiologueOpen.value && menu[index].title == 'importExportKey') ...[
                                    ListView.separated(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsetsDirectional.zero,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {},
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.02, vertical: context.height * 0.01),
                                            child: Row(
                                              children: [
                                                Icon(importExportMenuList[index].icon, size: 15.sp(context), color: colorScheme.onSecondary),
                                                SizedBox(width: context.width * 0.02),
                                                CustomTextView(text: context.tr(importExportMenuList[index].title), fontSize: 15.sp(context)),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        if (index == importExportMenuList.length - 1) {
                                          return SizedBox(height: context.height * 0.01);
                                        }
                                        return const CustomHorizontalDivider(padding: EdgeInsetsDirectional.all(2), endOpacity: 0.57);
                                      },
                                      itemCount: importExportMenuList.length,
                                    ),
                                  ],

                                  if (isAccountSettingsOpen.value && menu[index].title == 'accountSettingsKey') ...[
                                    ListView.separated(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsetsDirectional.zero,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (accountSettingsMenuList[index].title == 'deleteAccountKey') {
                                              showDeleteAlertDialog(context);
                                              isAccountSettingsOpen.value = false;
                                            }
                                            if (accountSettingsMenuList[index].title == 'logoutKey') {
                                              showSignOutDialog(context);
                                              isAccountSettingsOpen.value = false;
                                            }
                                            if (accountSettingsMenuList[index].title == 'loginKey') {
                                              Navigator.of(context).pushNamed(Routes.login);
                                              isAccountSettingsOpen.value = false;
                                            }
                                            if (accountSettingsMenuList[index].title == 'restoreKey') {
                                              Navigator.of(context).pushNamed(Routes.restoreData);
                                              isAccountSettingsOpen.value = false;
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.02, vertical: context.height * 0.01),
                                            child: Row(
                                              children: [
                                                Icon(accountSettingsMenuList[index].icon, size: 15.sp(context), color: colorScheme.onSecondary),
                                                SizedBox(width: context.width * 0.02),
                                                CustomTextView(text: context.tr(accountSettingsMenuList[index].title), fontSize: 15.sp(context)),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        if (index == accountSettingsMenuList.length - 1) {
                                          return SizedBox(height: context.height * 0.01);
                                        }
                                        return const CustomHorizontalDivider(padding: EdgeInsetsDirectional.all(2), endOpacity: 0.57);
                                      },
                                      itemCount: accountSettingsMenuList.length,
                                    ),
                                  ],

                                  if (isAppSettingsOpen.value && menu[index].title == 'appSettingsKey') ...[
                                    ListView.separated(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsetsDirectional.zero,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (appSettingsMenuList[index].title == 'languageKey') {
                                              showLanguageSelectorSheet(context);
                                            }
                                            if (appSettingsMenuList[index].title == 'themeKey') {
                                              showThemeSelectorSheet(context);
                                            }
                                            if (appSettingsMenuList[index].title == 'currencyKey') {
                                              showCurrencySelectorSheet(context);
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.02, vertical: context.height * 0.01),
                                            child: Row(
                                              children: [
                                                Icon(appSettingsMenuList[index].icon, size: 15.sp(context), color: colorScheme.onSecondary),
                                                SizedBox(width: context.width * 0.02),
                                                Expanded(
                                                  child: CustomTextView(text: context.tr(appSettingsMenuList[index].title), fontSize: 15.sp(context)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        if (index == appSettingsMenuList.length - 1) {
                                          return SizedBox(height: context.height * 0.01);
                                        }
                                        return const CustomHorizontalDivider(padding: EdgeInsetsDirectional.all(2), endOpacity: 0.57);
                                      },
                                      itemCount: appSettingsMenuList.length,
                                    ),
                                  ],
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIconMenu(ColorScheme colorScheme, ValueNotifier<bool> key) {
    return GestureDetector(
      onTap: () {
        key.value = !key.value;
        //isDataManaKeyDiologueOpen.value = !isDataManaKeyDiologueOpen.value;
      },
      child: Icon(key.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 22.sp(context), color: colorScheme.onSecondary),
    );
  }

  Widget _buildProfileCard(BuildContext context, ColorScheme colorScheme) {
    return Positioned(
      top: context.height * 0.12,
      left: 15,
      right: 15,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: const EdgeInsetsDirectional.all(10),
            width: context.width * 0.8,
            height: context.isTablet ? context.height * 0.08 : context.height * 0.1,
            decoration: BoxDecoration(color: colorScheme.surface, borderRadius: const BorderRadius.all(Radius.circular(15))),

            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.01),
              child: Row(
                children: [
                  SizedBox(
                    height: 50.sp(context),
                    width: 50.sp(context),
                    child: const ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      child: QImage(
                        imageUrl: AppImages.splashScreen,
                      ),
                    ),
                  ),
                  SizedBox(width: context.width * 0.029),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      mainAxisAlignment: .center,
                      children: [
                        CustomTextView(
                          text: 'Krishna Dabasiya',
                          fontSize: 16.sp(context),
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onTertiary,
                        ),
                        CustomTextView(
                          text: 'Hy there',
                          fontSize: 14.sp(context),
                          color: Theme.of(context).colorScheme.onTertiary.withValues(alpha: 0.4),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    // onTap: _handleProfileEdit,
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.editProfile);
                    },
                    child: Container(
                      height: context.screenWidth * (context.isMobile ? 0.09 : 0.05),
                      width: context.screenWidth * (context.isMobile ? 0.09 : 0.05),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Theme.of(context).primaryColor),
                      ),
                      child: Icon(Icons.edit_outlined, size: context.isTablet ? 20.sp(context) : 18.sp(context), color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onPressed(String index, BuildContext context) {
    switch (index) {
      case 'accountKey':
        Navigator.of(context).pushNamed(Routes.account);
        return;
      case 'partyKey':
        Navigator.of(context).pushNamed(Routes.partyList);
        return;
      case 'categoryKey':
        Navigator.of(context).pushNamed(Routes.category);
        return;
      case 'recurringKey':
        Navigator.of(context).pushNamed(Routes.mainrecurringTransactionList);
        return;
      case 'calenderKey':
        Navigator.of(context).pushNamed(Routes.calendar);
        return;
      case 'budgetKey':
        Navigator.of(context).pushNamed(Routes.budget);
    }
  }
}

void showDeleteAlertDialog(BuildContext context) {
  context.showAppDialog(
    child: Center(
      child: AlertDialog(
        constraints: BoxConstraints(maxHeight: context.height * 0.45, maxWidth: context.width * 0.85),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.tr('deletedAccountKey'), style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(context.tr('deleteAccDescKey')),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    //  padding: const EdgeInsetsDirectional.symmetric(vertical: 14),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: CustomTextView(text: context.tr('deleteAccountCancelKey'), fontSize: 15.sp(context), color: Colors.white, textAlign: TextAlign.center),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    //padding: const EdgeInsetsDirectional.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    // context.read<LogoutCubit>().logout();
                  },
                  child: CustomTextView(text: context.tr('deleteAccountConfirmKey'), fontSize: 15.sp(context), color: Colors.white, textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Future<void> showSignOutDialog(BuildContext context) async {
  await context.showAppDialog(
    child: Center(
      child: AlertDialog(
        constraints: BoxConstraints(maxHeight: context.height * 0.45, maxWidth: context.width * 0.85),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.tr('signOutKey'), style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(context.tr('signOutDescKey')),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    //  padding: const EdgeInsetsDirectional.symmetric(vertical: 14),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: CustomTextView(text: context.tr('deleteAccountCancelKey'), fontSize: 15.sp(context), color: Colors.white, textAlign: TextAlign.center),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    //padding: const EdgeInsetsDirectional.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    // context.read<LogoutCubit>().logout();
                  },
                  child: CustomTextView(text: context.tr('deleteAccountConfirmKey'), fontSize: 15.sp(context), color: Colors.white, textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
