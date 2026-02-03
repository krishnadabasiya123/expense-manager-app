import 'dart:ui';

import 'package:expenseapp/commons/widgets/CommonSearchController.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/Party/Cubits/Party/delete_party_cubit.dart';
import 'package:expenseapp/features/Party/Screen/party_create_bottom_sheet.dart';
import 'package:expenseapp/utils/constants/Debouncer.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PartyScreen extends StatefulWidget {
  const PartyScreen({super.key});

  @override
  State<PartyScreen> createState() => _PartyScreenState();
}

class _PartyScreenState extends State<PartyScreen> {
  final searchController = TextEditingController();

  final _debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearch);
    context.read<GetPartyCubit>().getParty();
  }

  List<Party> getParty({String searchText = ''}) {
    return context.read<GetPartyCubit>().getPartyBySearchName(searchText: searchText);
  }

  void _onSearch() {
    _debouncer.run(() {
      setState(() {
        context.read<GetPartyCubit>().getPartyBySearchName(searchText: searchController.text);
      });
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearch);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: CustomTextView(
          text: context.tr('partyKey'),
          fontSize: 20.sp(context),
          color: colorScheme.surface,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: colorScheme.surface),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: IconButton(
              onPressed: () {
                showCreatePartySheet(context);
              },
              icon: Icon(Icons.add, color: colorScheme.surface, size: context.isTablet ? 28.sp(context) : 25.sp(context)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: context.isTablet ? context.height * 0.11 : context.height * 0.14,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                  ),
                ),

                ResponsivePadding(
                  leftPadding: context.width * 0.02,
                  rightPadding: context.width * 0.02,

                  child: Container(
                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                        CommonSearchController(
                          controller: searchController,
                          hintText: context.tr('searchPartyKey'),
                          borderRadius: 15,
                          fontSize: 15.sp(context),
                          prefixIconSize: 18.sp(context),
                        ),
                        SizedBox(height: context.height * 0.01),
                        _buildNetWorthAndTotalCard(),
                        SizedBox(height: context.height * 0.01),
                        _buildPartyList(colorScheme),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartyCard({required String text, required String amount, required Color textColor}) {
    return Column(
      mainAxisAlignment: .spaceEvenly,
      children: [
        CustomTextView(text: text, fontSize: 14.sp(context), color: Colors.black),

        CustomTextView(text: amount, fontSize: 15.sp(context), color: textColor, fontWeight: FontWeight.bold),
      ],
    );
  }

  Widget _buildPartyList(ColorScheme colorScheme) {
    return BlocConsumer<GetPartyCubit, GetPartyState>(
      listener: (context, state) {
        if (state is GetPartyFailure) {
          UiUtils.showCustomSnackBar(context: context, errorMessage: state.message);
        }
      },
      builder: (context, state) {
        if (state is GetPartySuccess) {
          //final party = state.party;

          final party = getParty(searchText: searchController.text);

          if (party.isEmpty) {
            return CustomErrorWidget(
              errorMessage: context.tr('noPartyAddKey'),
              errorType: CustomErrorType.noDataFound,
              onRetry: () {
                context.read<GetPartyCubit>().getParty();
              },
            );
          }

          return ListView.builder(
            padding: EdgeInsetsDirectional.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: party.length,
            itemBuilder: (context, index) {
              final partyData = party[index];
              final totalCredit = context.read<GetPartyCubit>().getTotalPartyTransactionCredit(partyId: partyData.id);
              final totalDebit = context.read<GetPartyCubit>().getTotalPartyTransactionDebit(partyId: partyData.id);
              final totalBalance = context.read<GetPartyCubit>().getTotalPartyTransactionBalance(partyId: partyData.id);

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(Routes.partyTransactionList, arguments: {'party': partyData});

                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => PartyTransactionScreen(party: partyData),
                  //   ),
                  // );
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.04, vertical: context.height * 0.01),
                  margin: EdgeInsetsDirectional.only(bottom: context.height * 0.01),
                  width: context.width * 0.8,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: colorScheme.primary.withValues(alpha: 0.5), offset: const Offset(0, 4), blurRadius: 6)],
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: .start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                CustomTextView(
                                  text: partyData.name,
                                  fontSize: 16.sp(context),
                                  color: Theme.of(context).colorScheme.onSecondary,
                                  fontWeight: FontWeight.bold,
                                  softWrap: true,
                                  maxLines: 2,
                                ),
                                SizedBox(height: context.height * 0.005),
                                CustomTextView(
                                  text: '${context.tr('updatedKey')}: ${UiUtils.covertInBuiltDate(DateTime.parse(partyData.updatedAt), context)}',
                                  fontSize: 14.sp(context),
                                  color: Colors.black,
                                ),
                                SizedBox(height: context.height * 0.01),
                              ],
                            ),
                          ),

                          PopupMenuButton<String>(
                            constraints: BoxConstraints(
                              maxHeight: context.screenHeight * (context.isMobile ? 0.5 : 0.1),
                              maxWidth: context.screenWidth * (context.isMobile ? 1.5 : 2.5),
                            ),

                            // padding: EdgeInsetsDirectional.zero,
                            icon: const Icon(Icons.more_vert),
                            onSelected: (value) {
                              if (value == context.tr('editKey')) {
                                showCreatePartySheet(context, isEdit: true, party: partyData);
                              } else if (value == context.tr('deleteKey')) {
                                showDeleteAlertDialog(context, party: partyData);
                              }
                            },
                            itemBuilder: (context) => [
                              _popUpMenuBuild(value: context.tr('editKey'), text: context.tr('editKey'), icon: Icons.edit, color: Colors.black),
                              _popUpMenuBuild(value: context.tr('deleteKey'), text: context.tr('deleteKey'), icon: Icons.delete, color: context.colorScheme.expenseColor),
                            ],
                          ),
                        ],
                      ),

                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          crossAxisAlignment: .start,
                          mainAxisAlignment: .spaceEvenly,
                          children: [
                            _buildPartyCard(text: context.tr('creditKey'), amount: '${context.symbol}  ${totalCredit.formatAmt()}', textColor: context.colorScheme.incomeColor),
                            Container(width: 1.5, height: context.height * 0.06, color: Colors.grey.shade400),
                            _buildPartyCard(text: context.tr('debitKey'), amount: '${context.symbol} ${totalDebit.formatAmt()}', textColor: context.colorScheme.expenseColor),

                            Container(width: 1.5, height: context.height * 0.06, color: Colors.grey.shade400),
                            _buildPartyCard(text: context.tr('balanceKey'), amount: '${context.symbol} ${totalBalance.formatAmt()}', textColor: Colors.black),
                          ],
                        ),
                      ),
                      SizedBox(height: context.height * 0.01),
                      Row(
                        mainAxisAlignment: .end,
                        children: [
                          Container(
                            padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.02, vertical: context.height * 0.005),
                            decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    //showCreatePartySheet(context, isEdit: true, party: partyData);
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: CustomTextView(text: context.tr('viewReportKey'), fontSize: 10.sp(context), color: colorScheme.primary, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: context.width * 0.02),
                                Icon(Icons.arrow_forward_ios, size: 10.sp(context), color: colorScheme.primary),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        if (state is GetPartyFailure) {
          return CustomErrorWidget(
            errorMessage: state.message,
            onRetry: () {
              context.read<GetPartyCubit>().getParty();
            },
          );
        }
        return const CustomCircularProgressIndicator();
      },
    );
  }

  PopupMenuItem<String> _popUpMenuBuild({required String value, required String text, required IconData icon, required Color color}) {
    return PopupMenuItem(
      value: value,

      child: Row(
        children: [
          Expanded(
            child: CustomTextView(text: text, fontSize: 15.sp(context)),
          ),
          Icon(icon, size: 18.sp(context), color: color),
        ],
      ),
    );
  }

  Widget _buildNetWorthAndTotalCard() {
    return Column(
      children: [
        SizedBox(height: context.height * 0.005),

        BlocBuilder<GetPartyCubit, GetPartyState>(
          builder: (context, state) {
            final totalBalance = (state is GetPartySuccess) ? context.read<GetPartyCubit>().getTotalNetBalance(partyId: state.party).formatAmt() : '0';
            final totalTransactionCount = context.read<GetPartyCubit>().getTotalPartyTransactionCount();

            return Row(
              children: [
                Expanded(
                  child: _buildCard(text: context.tr('netBalanceKey'), amount: '${context.symbol} $totalBalance', color: Colors.blue.shade100, borderColor: Colors.blue),
                ),
                SizedBox(width: context.width * 0.02),
                Expanded(
                  child: _buildCard(text: context.tr('totalPartiesKey'), amount: totalTransactionCount.toString(), color: Colors.grey.shade300, borderColor: Colors.grey),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildCard({required String text, required String amount, Color? color, Color? borderColor}) {
    return Container(
      height: context.isTablet ? context.height * 0.08 : context.height * 0.1,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor ?? Colors.grey),
      ),
      child: Column(
        mainAxisAlignment: .spaceEvenly,
        children: [
          CustomTextView(
            text: text,
            fontSize: 14.sp(context),
            color: Theme.of(context).colorScheme.onSecondary,
          ),

          CustomTextView(
            text: amount,
            fontSize: 18.sp(context),
            color: Theme.of(context).colorScheme.onSecondary,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  void showDeleteAlertDialog(BuildContext context, {required Party party}) {
    context.showAppDialog(
      child: BlocProvider(
        create: (context) => DeletePartyCubit(),
        child: Builder(
          builder: (dialogContext) {
            return Center(
              child: PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop) return;
                  if (dialogContext.read<DeletePartyCubit>().state is! DeletePartyLoading) {
                    Navigator.of(dialogContext).pop();
                    return;
                  }
                },
                child: AlertDialog(
                  constraints: const BoxConstraints(),
                  //constraints: BoxConstraints(maxHeight: size.height * 0.45, maxWidth: size.width * 0.85),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: CustomTextView(text: context.tr('deleteAccountTitleKey'), fontWeight: FontWeight.bold, fontSize: 20.sp(context)),
                  content: CustomTextView(text: context.tr('deletePartyDialogMsg'), softWrap: true, maxLines: 3),
                  actions: [
                    BlocConsumer<DeletePartyCubit, DeletePartyState>(
                      listener: (context, state) {
                        if (state is DeletePartySuccess) {
                          Navigator.of(context).pop();

                          context.read<GetPartyCubit>().deletePartyLocally(state.party);

                          for (final transaction in state.party.transaction) {
                            context.read<GetTransactionCubit>().deleteTransacionLocally(Transaction(id: transaction.mainTransactionId));
                          }
                        }

                        if (state is DeletePartyFailure) {
                          UiUtils.showCustomSnackBar(context: context, errorMessage: state.message);
                          Navigator.of(context).pop();
                        }
                      },
                      builder: (context, state) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  //  padding: const EdgeInsetsDirectional.symmetric(vertical: 14),
                                ),
                                onPressed: () {
                                  if (state is! DeletePartyLoading) {
                                    Navigator.of(context).pop();
                                  }
                                },

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
                                onPressed: state is DeletePartyLoading
                                    ? null
                                    : () async {
                                        await context.read<DeletePartyCubit>().deleteParty(party);
                                      },
                                child: state is DeletePartyLoading
                                    ? const CustomCircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : CustomTextView(text: context.tr('deleteAccountConfirmKey'), fontSize: 15.sp(context), color: Colors.white, textAlign: TextAlign.center),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
