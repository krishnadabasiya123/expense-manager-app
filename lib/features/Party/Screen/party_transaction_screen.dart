import 'dart:ui';

import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/Party/Screen/party_details_widget.dart';

import 'package:flutter/material.dart';

class PartyTransactionScreen extends StatefulWidget {
  const PartyTransactionScreen({required this.party, super.key});
  final Party party;

  @override
  State<PartyTransactionScreen> createState() => _PartyTransactionScreenState();

  static Route<dynamic>? route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>? ?? {};

    final party = arguments['party'] as Party;

    return MaterialPageRoute(builder: (_) => PartyTransactionScreen(party: party));
  }
}

class _PartyTransactionScreenState extends State<PartyTransactionScreen> {
  Party? partyDetails;
  @override
  void initState() {
    partyDetails = widget.party;
    super.initState();

    context.read<GetPartyCubit>().getPartyById(partyId: widget.party.id);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: colorScheme.surface,
        ),
        backgroundColor: colorScheme.primary,
        title: Center(
          child: CustomTextView(
            text: partyDetails!.name!,
            fontSize: 20.sp(context),
            color: colorScheme.surface,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: IconButton(
              onPressed: () {
                // showAddPartyTransactionDialogue(context, isEdit: false);
                Navigator.of(context).pushNamed(Routes.addPartyTransaction, arguments: {'partyId': partyDetails});
              },
              icon: Icon(
                Icons.add_to_photos_sharp,
                size: context.isTablet ? 22.sp(context) : 20.sp(context),
                color: colorScheme.surface,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<GetPartyCubit, GetPartyState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is GetPartySuccess) {
                  final items = context.read<GetPartyCubit>().getPartyTransactionByFilterDate(
                    partyId: widget.party.id,
                  );

                  if (items.isEmpty) {
                    return NoDataFoundScreen(title: context.tr('noPartyTransactionFound'), subTitle: context.tr('noPartyTransactionFoundPlsAdd'));
                  }

                  return LedgerList(
                    partyTransactions: items,
                    partyId: partyDetails!.id,
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),

          ColoredBox(
            color: Colors.white,
            child: BlocBuilder<GetPartyCubit, GetPartyState>(
              builder: (context, state) {
                final totalCredit = state is GetPartySuccess ? context.read<GetPartyCubit>().getTotalPartyTransactionCredit(partyId: partyDetails!.id).formatAmt() : '0';
                final totalDebit = state is GetPartySuccess ? context.read<GetPartyCubit>().getTotalPartyTransactionDebit(partyId: partyDetails!.id).formatAmt() : '0';
                final totalBalance = state is GetPartySuccess ? context.read<GetPartyCubit>().getTotalPartyTransactionBalance(partyId: partyDetails!.id).formatAmt() : '0';

                return Row(
                  mainAxisAlignment: .spaceEvenly,
                  children: [
                    _buildCard(text: context.tr('creditKey'), amount: '${context.symbol}  $totalCredit', textColor: colorScheme.primary),
                    SizedBox(width: context.width * 0.02),
                    _buildCard(text: context.tr('debitKey'), amount: '${context.symbol} $totalDebit', textColor: colorScheme.primary),
                    SizedBox(width: context.width * 0.02),
                    _buildCard(text: context.tr('balanceKey'), amount: '${context.symbol} $totalBalance', bgColor: colorScheme.primary, textColor: colorScheme.surface),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String text, required String amount, Color? bgColor, Color? textColor}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsetsDirectional.all(5),
        color: bgColor,

        child: Column(
          mainAxisAlignment: .spaceEvenly,
          children: [
            CustomTextView(
              text: text,
              fontSize: 14.sp(context),
              color: textColor,
            ),

            CustomTextView(text: amount, fontSize: 16.sp(context), color: textColor, fontWeight: FontWeight.bold),
          ],
        ),
      ),
    );
  }
}

class LedgerList extends StatelessWidget {
  const LedgerList({required this.partyTransactions, required this.partyId, super.key});
  final String partyId;
  final List<Map<String, dynamic>> partyTransactions;

  @override
  Widget build(BuildContext context) {
    return ResponsivePadding(
      topPadding: context.height * 0.01,
      bottomPadding: 5,
      leftPadding: context.width * 0.05,
      rightPadding: context.width * 0.05,
      //  child: const Text(''),
      child: ListView(
        padding: EdgeInsetsDirectional.zero,
        children: partyTransactions.map((entry) {
          final date = entry['date'] as String;
          final dateItems = entry['transactions'] as List<PartyTransaction>;

          return Column(
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_month, size: 20.sp(context)),
                  SizedBox(width: context.width * 0.02),
                  CustomTextView(text: UiUtils.convertCustomDate(date), fontSize: 15.sp(context), fontWeight: FontWeight.w500, color: Colors.black),
                ],
              ),
              SizedBox(height: context.height * 0.01),
              Container(
                margin: const EdgeInsetsDirectional.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .08), blurRadius: 10, offset: const Offset(0, 4))],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...dateItems.asMap().entries.map((e) {
                      final idx = e.key;
                      final item = e.value;

                      return Column(
                        children: [
                          if (idx != 0) const CustomHorizontalDivider(padding: EdgeInsetsDirectional.all(0), endOpacity: 0.4),
                          LedgerItemRow(
                            index: idx,
                            credit: item.type! == TransactionType.CREDIT ? item.amount! : 0.0,
                            debit: item.type! == TransactionType.DEBIT ? item.amount! : 0.0,
                            party: item,
                            partyId: partyId,
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class LedgerItemRow extends StatefulWidget {
  const LedgerItemRow({required this.credit, required this.debit, required this.party, required this.index, required this.partyId, super.key});
  final int index;
  final double credit;
  final double debit;
  final PartyTransaction party;
  final String? partyId;

  @override
  State<LedgerItemRow> createState() => _LedgerItemRowState();
}

class _LedgerItemRowState extends State<LedgerItemRow> {
  late TransactionType type;
  late bool isCredit;

  @override
  void initState() {
    super.initState();
    type = widget.party.type!;
    isCredit = type == TransactionType.CREDIT;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showPartyDetailsWidgetBottomSheet(context, transaction: widget.party, partyId: widget.partyId, isEdit: true);
      },
      child: Container(
        padding: const EdgeInsetsDirectional.all(14),

        // decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(context.width * 0.02)), color: Colors.white),
        child: Row(
          children: [
            Container(
              height: 35.sp(context),
              width: 35.sp(context),
              decoration: BoxDecoration(color: isCredit ? const Color.fromRGBO(155, 230, 158, 1) : const Color.fromARGB(255, 237, 210, 209), shape: BoxShape.circle),
              child: Icon(
                isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                color: isCredit ? const Color.fromARGB(255, 36, 119, 39) : Colors.red,
                size: 16.sp(context),
              ),
            ),

            SizedBox(width: context.width * 0.03),

            Expanded(
              child: CustomTextView(
                text: isCredit ? context.tr('paymentReceivedKey') : context.tr('outgoingTransferKey'),
                fontWeight: FontWeight.w900,
                color: Colors.black,
                fontSize: 15.sp(context),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomTextView(
                  text: isCredit ? '+ ${context.symbol}${widget.credit.formatAmt()}' : '- ${context.symbol}${widget.debit.formatAmt()}',
                  //fontWeight: FontWeight.bold,
                  color: isCredit ? const Color.fromARGB(255, 36, 119, 39) : Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showDeleteAlertDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: 'Delete',
      barrierColor: Colors.black.withValues(alpha: .3),
      transitionDuration: const Duration(milliseconds: 300),

      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return Transform.scale(
          scale: Curves.easeOutBack.transform(animation.value),
          child: Opacity(opacity: animation.value, child: child),
        );
      },

      pageBuilder: (context, animation, secondaryAnimation) {
        final size = MediaQuery.of(context).size;

        return Center(
          child: AlertDialog(
            constraints: BoxConstraints(maxHeight: size.height * 0.45, maxWidth: size.width * 0.85),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: CustomTextView(text: context.tr('deleteTransactionKey'), fontWeight: FontWeight.bold),
            content: CustomTextView(text: context.tr('deleteTransactionDialogMsg'), softWrap: true, maxLines: 3),
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
        );
      },
    );
  }
}
