import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/budget/cubits/get_budget_cubit.dart';
import 'package:expenseapp/features/budget/models/Budget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BudgetHistoryScreen extends StatefulWidget {
  BudgetHistoryScreen({required this.budget, super.key});
  Budget budget;

  @override
  State<BudgetHistoryScreen> createState() => _BudgetHistoryScreenState();

  static Route<dynamic>? route(RouteSettings routeSettings) {
    final args = routeSettings.arguments as Map<String, dynamic>?;

    final budget = args?['item'] as Budget;

    return CupertinoPageRoute(
      builder: (_) => BudgetHistoryScreen(budget: budget),
    );
  }
}

class _BudgetHistoryScreenState extends State<BudgetHistoryScreen> {
  List<Map<String, dynamic>> budgetList = [];
  @override
  void initState() {
    super.initState();
    budgetList = context.read<GetTransactionCubit>().getTransactionByCategoryId(categoryIds: widget.budget.catedoryId, date: widget.budget.endDate, type: widget.budget.type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QAppBar(
        title: CustomTextView(text: context.tr('budgetHistoryKey'), fontSize: 20.sp(context), color: Colors.white),
      ),
      body: ResponsivePadding(
        topPadding: context.height * 0.01,
        bottomPadding: context.height * 0.01,
        leftPadding: context.width * 0.04,
        rightPadding: context.width * 0.04,
        child: (budgetList.isEmpty)
            ? CustomErrorWidget(
                errorMessage: context.tr('noDataFound'),
                errorType: CustomErrorType.noDataFound,
                onRetry: () {
                  context.read<GetBudgetCubit>().getBudget();
                },
              )
            : ListView.builder(
                padding: EdgeInsetsDirectional.zero,
                itemCount: budgetList.length,

                itemBuilder: (context, index) {
                  final category = budgetList[index];
                  final categoryId = category['categoryId'] as String;
                  final categoryName = context.read<GetCategoryCubit>().getCategoryName(categoryId);
                  final total = category['total'] as double;
                  final transaction = category['transactions'] as List<Transaction>;

                  return Padding(
                    padding: const EdgeInsetsDirectional.only(top: 8, bottom: 8),
                    child: _categorySection(
                      title: categoryName,
                      total: total.formatAmt(),
                      context: context,
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final item = transaction[index];
                            final type = item.type;
                            final subtitle = item.title;
                            final accountName = context.read<GetAccountCubit>().getAccountName(id: item.accountId);
                            final amount = item.amount;

                            final date = UiUtils.parseDate(item.date);
                            return Container(
                              padding: const EdgeInsetsDirectional.all(10),
                              child: Row(
                                children: [
                                  Container(
                                    height: 30.sp(context),
                                    width: 30.sp(context),
                                    decoration: BoxDecoration(
                                      color: type.color!.withValues(alpha: 0.09),
                                      shape: BoxShape.circle,
                                    ),

                                    child: Icon(
                                      type.icon,
                                      color: type.color,
                                      size: 20.sp(context),
                                    ),
                                  ),

                                  SizedBox(width: context.width * 0.02),

                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomTextView(
                                          text: UiUtils.covertInBuiltDate(date, context),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: context.isTablet ? 18.sp(context) : 15.sp(context),
                                        ),

                                        if (subtitle.isNotEmpty) ...[
                                          CustomTextView(
                                            text: subtitle,
                                            color: Colors.black,
                                            fontSize: context.isTablet ? 15.sp(context) : 14.sp(context),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            if (item.recurringId.isNotEmpty) ...[
                                              QImage(
                                                imageUrl: AppImages.repeatIcon,
                                                fit: BoxFit.contain,
                                                height: 12.sp(context),
                                              ),
                                              const SizedBox(width: 4),
                                            ],
                                            CustomTextView(
                                              text: amount.formatAmt(),
                                              fontWeight: FontWeight.bold,
                                              color: type.color,
                                              textAlign: TextAlign.end,
                                            ),
                                          ],
                                        ),

                                        CustomTextView(
                                          text: accountName,
                                          fontSize: 14.sp(context),
                                          color: Colors.grey.shade600,
                                          textAlign: TextAlign.end,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const CustomHorizontalDivider(
                              padding: EdgeInsetsDirectional.zero,
                            );
                          },
                          itemCount: transaction.length,
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}

Widget _categorySection({
  required String title,
  required String total,
  required List<Widget> children,
  required BuildContext context,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  return Column(
    children: [
      Container(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.2),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: .spaceEvenly,
          children: [
            Expanded(
              child: CustomTextView(text: title, fontSize: 13.sp(context), fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            CustomTextView(
              text: '${context.symbol}$total',
              fontSize: 13.sp(context),
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ),
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        child: Column(
          children: children,
        ),
      ),
    ],
  );
}
