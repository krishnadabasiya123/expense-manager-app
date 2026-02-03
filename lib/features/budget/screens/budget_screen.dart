import 'package:expenseapp/commons/widgets/common_text_view.dart';
import 'package:expenseapp/commons/widgets/custom_app_bar.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/budget/cubits/get_budget_cubit.dart';
import 'package:flutter/material.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetBudgetCubit>().getBudget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QAppBar(
        title: CustomTextView(text: context.tr('budgetKey'), fontSize: 20.sp(context), color: Colors.white),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.addBudget);
        },
        child: const Icon(Icons.add),
      ),
      body: ResponsivePadding(
        topPadding: context.height * 0.01,
        bottomPadding: context.height * 0.01,
        leftPadding: context.width * 0.04,
        rightPadding: context.width * 0.04,
        child: BlocConsumer<GetBudgetCubit, GetBudgetState>(
          listener: (context, state) {
            if (state is GetBudgetSuccess) {}
          },
          builder: (context, state) {
            if (state is GetBudgetSuccess) {
              final budgetList = state.budget;
              if (budgetList.isEmpty) {
                return CustomErrorWidget(
                  errorMessage: context.tr('noDataFound'),
                  errorType: CustomErrorType.noDataFound,
                  onRetry: () {
                    context.read<GetBudgetCubit>().getBudget();
                  },
                );
              }
              return ListView.builder(
                padding: EdgeInsetsDirectional.zero,
                shrinkWrap: true,
                itemCount: budgetList.length,
                itemBuilder: (context, index) {
                  final item = budgetList[index];
                  final spent = context.read<GetTransactionCubit>().getTotalBudgetSpent(categoryIds: item.catedoryId);
                  final left = item.amount - spent;
                  final percentage = (left / item.amount) * 100;
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.budgetHistory, arguments: {'category': item.catedoryId});
                    },
                    child: BudgetCard(
                      title: item.budgetName,
                      left: left < 0 ? 0 : left,
                      spent: spent,
                      percent: percentage < 0 ? 0 : percentage,
                      limit: item.amount,
                      category: item.catedoryId,
                    ),
                  );
                },
              );
            }
            if (state is GetBudgetFailure) {
              return CustomErrorWidget(
                errorMessage: state.error,
                onRetry: () {
                  context.read<GetBudgetCubit>().getBudget();
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class BudgetCard extends StatelessWidget {
  const BudgetCard({
    required this.title,
    required this.left,
    required this.spent,
    required this.percent,
    required this.limit,
    required this.category,
    super.key,
  });
  final String title;
  final double left;
  final double spent;
  final double percent;
  final double limit;
  final List<String> category;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 8),
      padding: const EdgeInsetsDirectional.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    CustomTextView(text: title, fontSize: 18.sp(context), fontWeight: FontWeight.bold),
                    const SizedBox(width: 5),
                    if (spent > limit) ...[
                      Container(
                        padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.02, vertical: context.height * 0.005),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: .15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: CustomTextView(text: context.tr('limitExceededKey'), fontSize: 11.sp(context), color: Colors.red),
                      ),
                    ],
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  log('hyyy');
                  PopupMenuButton<String>(
                    // padding: EdgeInsetsDirectional.zero,
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == context.tr('editKey')) {
                      } else if (value == context.tr('deleteKey')) {}
                    },
                    itemBuilder: (context) => [
                      _popUpMenuBuild(context: context, value: context.tr('editKey'), text: context.tr('editKey'), icon: Icons.edit, color: Colors.black),
                      _popUpMenuBuild(context: context, value: context.tr('deleteKey'), text: context.tr('deleteKey'), icon: Icons.delete, color: context.colorScheme.expenseColor),
                    ],
                  );
                },
                child: const Icon(Icons.more_horiz, color: Colors.black),
              ),
            ],
          ),
          //SizedBox(height: context.height * 0.01),
          Row(
            children: [
              Icon(Icons.category, color: Colors.black, size: 16.sp(context)),
              const SizedBox(width: 10),
              CustomTextView(text: '${category.length} ${context.tr('categoryKey')}', fontSize: 12.sp(context), color: Colors.black),
            ],
          ),
          SizedBox(height: context.height * 0.015),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomTextView(
                    text: '${context.symbol}$left ',
                    fontSize: 20.sp(
                      context,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                  CustomTextView(text: context.tr('remainingKey'), fontSize: 12.sp(context), fontWeight: FontWeight.bold, color: Colors.grey),
                ],
              ),
              Row(
                children: [
                  CustomTextView(
                    text: context.tr('spentKey'),
                    color: Colors.black,
                    fontSize: 12.sp(context),
                    fontWeight: FontWeight.bold,
                  ),
                  CustomTextView(text: '  ${context.symbol}$spent', color: spent > limit ? Colors.red : Colors.black),
                ],
              ),
            ],
          ),

          SizedBox(height: context.height * 0.009),
          SizedBox(
            height: 10,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: LinearProgressIndicator(
                value: percent / 100,
                valueColor: AlwaysStoppedAnimation<Color>(
                  left > 0 ? colorScheme.primary : Colors.red,
                ),
                backgroundColor: left > 0 ? colorScheme.primary : Colors.red,
              ),
            ),
          ),

          SizedBox(height: context.height * 0.009),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextView(text: '${percent.toInt()}% ${context.tr('UtilizationKey')}', fontSize: 12.sp(context), color: Theme.of(context).primaryColor),
              Row(
                children: [
                  CustomTextView(
                    text: context.tr('limitKey'),
                    color: Colors.black,
                    fontSize: 12.sp(context),
                    fontWeight: FontWeight.bold,
                  ),
                  CustomTextView(text: '  ${context.symbol}$limit', color: Colors.black, fontSize: 12.sp(context)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _popUpMenuBuild({required BuildContext context, required String value, required String text, required IconData icon, required Color color}) {
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
}
