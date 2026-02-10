import 'dart:math' as math;

import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/budget/cubits/delete_budget_cubit.dart';
import 'package:expenseapp/features/budget/cubits/get_budget_cubit.dart';
import 'package:expenseapp/features/budget/models/Budget.dart';
import 'package:expenseapp/features/budget/models/enums/BudgetType.dart';
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

  String label = '';
  double left = 0;
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
                  final result = context.read<GetTransactionCubit>().getTotalBudgetSpent(categoryIds: item.catedoryId, type: item.type, date: item.endDate);

                  final spent = result;

                  final limit = item.amount;
                  //final absSpent = result.abs();

                  if (item.type == TransactionType.INCOME) {
                    if (spent > limit) {
                      // Over saved
                      left = spent - limit;
                      label = context.tr('overSavedKey');
                    } else {
                      // Remaining to reach goal
                      left = limit - spent;
                      label = context.tr('leftKey');
                    }
                  } else if (item.type == TransactionType.EXPENSE) {
                    // EXPENSE
                    if (spent > limit) {
                      // Over spent
                      left = spent - limit;
                      label = context.tr('overSpentKey');
                    } else {
                      // Remaining budget
                      left = limit - spent;
                      label = context.tr('leftKey');
                    }
                  } else {
                    // ALL Type

                    if (spent < 0) {
                      // Income case
                      left = spent.abs();
                      label = context.tr('overSavedKey');
                    } else if (spent > limit) {
                      // Overspent
                      left = spent - limit;
                      label = context.tr('overSpentKey');
                    } else {
                      // Normal remaining
                      left = limit - spent;
                      label = context.tr('leftKey');
                    }
                  }
                  final parseEndDate = UiUtils.parseDate(item.endDate);
                  return GestureDetector(
                    onTap: () {
                      if (parseEndDate.isPast) {
                        UiUtils.showCustomSnackBar(context: context, errorMessage: context.tr('budgetEnded'));
                        return;
                      } else {
                        Navigator.pushNamed(context, Routes.budgetHistory, arguments: {'item': item});
                      }
                    },
                    child: Opacity(
                      opacity: parseEndDate.isPast ? 0.5 : 1,
                      //   opacity: UiUtils.parseDate(item.endDate).isBefore(DateTime.now()) ? 0.5 : 1,
                      child: BudgetCard(
                        title: item.budgetName,
                        left: left,
                        spent: result,
                        percent: (spent / item.amount) * 100,
                        limit: item.amount,
                        category: item.catedoryId,
                        type: item.type,
                        budget: item,
                        label: label,
                      ),
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
    required this.type,
    required this.budget,
    required this.label,
    super.key,
  });
  final String title;
  final double left;
  final double spent;
  final double percent;
  final double limit;
  final List<String> category;
  final TransactionType type;
  final Budget budget;
  final String label;

  @override
  Widget build(BuildContext context) {
    final parseEndDate = UiUtils.parseDate(budget.endDate);
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 8),
      padding: const EdgeInsetsDirectional.all(15),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextView(text: title, fontSize: 15.sp(context), fontWeight: FontWeight.bold, softWrap: true, maxLines: 3),
              ),
              Container(
                padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.02, vertical: 2.sp(context)),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomTextView(text: '${category.length} ${context.tr('categoryKey')}', fontSize: 12.sp(context), color: Colors.black),
              ),
              if (!parseEndDate.isPast)
                PopupMenuButton<String>(
                  padding: EdgeInsetsGeometry.zero,
                  constraints: BoxConstraints(
                    maxHeight: context.screenHeight * (context.isMobile ? 0.5 : 0.1),
                    maxWidth: context.screenWidth * (context.isMobile ? 1.5 : 2.5),
                  ),
                  icon: Container(
                    height: 36,
                    width: 5,
                    alignment: Alignment.centerRight,
                    child: const Icon(
                      Icons.more_vert,
                    ),
                  ),
                  onSelected: (value) {
                    if (value == context.tr('editKey')) {
                      Navigator.pushNamed(context, Routes.addBudget, arguments: {'item': budget, 'isEdit': true});
                    } else if (value == context.tr('deleteKey')) {
                      showDeleteAlertDialog(context: context, budget: budget);
                    }
                  },
                  itemBuilder: (context) => [
                    _popUpMenuBuild(value: context.tr('editKey'), text: context.tr('editKey'), icon: Icons.edit, color: Colors.black, context: context),
                    _popUpMenuBuild(value: context.tr('deleteKey'), text: context.tr('deleteKey'), icon: Icons.delete, color: context.colorScheme.expenseColor, context: context),
                  ],
                ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomTextView(
                    text: '${context.symbol}$left ',
                    fontSize: 18.sp(context),
                    fontWeight: FontWeight.bold,
                  ),
                  CustomTextView(
                    text: label,
                    fontSize: 12.sp(context),
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ],
              ),
              Row(
                children: [
                  CustomTextView(
                    text: spent < 0 ? context.tr('savedKey') : context.tr('usedKey'),
                    color: Colors.black,
                    fontSize: 12.sp(context),
                    fontWeight: FontWeight.bold,
                  ),
                  CustomTextView(text: '  ${context.symbol}${spent.abs()}', color: Colors.black),
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
                  colorScheme.primary.withValues(alpha: 0.8),
                ),
                backgroundColor: colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
          ),

          SizedBox(height: context.height * 0.009),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextView(text: '${percent.toInt()}%', fontSize: 12.sp(context), color: Theme.of(context).primaryColor),
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

  void showDeleteAlertDialog({required Budget budget, required BuildContext context}) {
    context.showAppDialog(
      child: BlocProvider(
        create: (context) => DeleteBudgetCubit(),
        child: Builder(
          builder: (dialogueContext) {
            return Center(
              child: PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop) return;
                  if (dialogueContext.read<DeleteBudgetCubit>().state is! DeleteBudgetLoading) {
                    Navigator.of(dialogueContext).pop();
                    return;
                  }
                },
                child: AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: Text(
                    context.tr('deleteAccountTitleKey'),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp(context)),
                  ),
                  content: CustomTextView(text: context.tr('budgetDeleteDialogMsg'), softWrap: true, maxLines: 3, fontSize: 15.sp(context)),
                  actions: [
                    BlocConsumer<DeleteBudgetCubit, DeleteBudgetState>(
                      listener: (context, state) {
                        if (state is DeleteBudgetSuccess) {
                          context.read<GetBudgetCubit>().deleteBudgetLocally(state.budget);
                          Navigator.pop(context);
                        }
                        if (state is DeleteBudgetFailure) {
                          UiUtils.showCustomSnackBar(context: context, errorMessage: state.error);
                          Navigator.pop(context);
                        }
                      },
                      builder: (context, state) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: CustomRoundedButton(
                                onPressed: () {
                                  if (state is! DeleteBudgetLoading) {
                                    Navigator.of(context).pop();
                                  }
                                },

                                width: 1,
                                backgroundColor: Theme.of(context).primaryColor,
                                text: context.tr('deleteAccountCancelKey'),
                                borderRadius: BorderRadius.circular(8),
                                height: 45.sp(context),
                              ),
                            ),

                            const SizedBox(width: 15),

                            Expanded(
                              child: CustomRoundedButton(
                                onPressed: () {
                                  context.read<DeleteBudgetCubit>().deleteBudget(budget);
                                },
                                isLoading: state is DeleteBudgetLoading,
                                width: 1,
                                backgroundColor: Theme.of(context).primaryColor,
                                text: context.tr('deleteAccountConfirmKey'),
                                borderRadius: BorderRadius.circular(8),
                                height: 45.sp(context),
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
