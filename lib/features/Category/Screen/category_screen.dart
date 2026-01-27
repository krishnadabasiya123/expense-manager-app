import 'dart:ui';

import 'package:expenseapp/commons/widgets/CommonSearchController.dart';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/Category/Cubits/delete_category_cubit.dart';
import 'package:expenseapp/features/Category/Widgets/add_category_dialogue.dart';
import 'package:expenseapp/features/Party/Cubits/PartyTransaction/get_soft_delete_party_transaction_cubit.dart';
import 'package:expenseapp/features/RecurringTransaction/Cubit/get_recurring_transaction_cubit.dart';
import 'package:expenseapp/features/Transaction/Cubits/get_soft_delete_transactions_cubit.dart';
import 'package:expenseapp/utils/constants/Debouncer.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  final categoryLocalStorage = CategoryLocalStorage();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearch);
    super.dispose();
  }

  List<Category> getCategoryList({String? keyword}) {
    return context.read<GetCategoryCubit>().searchCaterory(keyword: keyword);
  }

  void _onSearch() {
    _debouncer.run(() {
      setState(() {
        getCategoryList(keyword: _searchController.text);
      });
    });
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
        title: CustomTextView(text: context.tr('categoryKey'), fontSize: 22.sp(context), color: colorScheme.surface),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: IconButton(
              onPressed: () {
                showAddCategoryDialogue(context);
              },
              icon: Icon(
                Icons.add,
                color: colorScheme.surface,
              ),
            ),
          ),
        ],
      ),

      body: ResponsivePadding(
        topPadding: context.height * 0.01,
        leftPadding: context.width * 0.035,
        rightPadding: context.width * 0.035,
        child: Column(
          children: [
            CommonSearchController(controller: _searchController, hintText: context.tr('searchCategoryKey')),
            SizedBox(height: context.height * 0.01),
            Expanded(
              child: SingleChildScrollView(
                child: BlocBuilder<GetCategoryCubit, GetCategoryState>(
                  builder: (context, state) {
                    if (state is GetCategorySuccess) {
                      final categoryList = getCategoryList(keyword: _searchController.text);
                      return ReorderableListView.builder(
                        proxyDecorator: (child, index, animation) {
                          return Material(
                            color: Colors.transparent,
                            elevation: 6,
                            borderRadius: BorderRadius.circular(14),
                            child: ClipRRect(borderRadius: BorderRadius.circular(14), child: child),
                          );
                        },
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categoryList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          final categoryDetails = categoryList[i];

                          return Card(
                            shadowColor: colorScheme.primary.withValues(alpha: 0.6),
                            key: ValueKey('${categoryDetails.id}-$i'),
                            elevation: 2,
                            margin: EdgeInsetsDirectional.only(bottom: context.height * 0.01),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            child: Padding(
                              padding: EdgeInsetsDirectional.symmetric(horizontal: context.width * 0.05, vertical: context.height * 0.01),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomTextView(text: categoryDetails.name, fontSize: 17.sp(context), color: Colors.black, softWrap: true, maxLines: 4, fontWeight: FontWeight.w300),
                                  ),

                                  PopupMenuButton<String>(
                                    constraints: BoxConstraints(
                                      maxHeight: context.screenHeight * (context.isMobile ? 0.3 : 0.95),

                                      maxWidth: context.screenWidth * (context.isMobile ? 1 : 2),
                                    ),

                                    padding: EdgeInsetsDirectional.zero,
                                    icon: (categoryDetails.isDefault) ? const Icon(Icons.more_vert, color: Colors.grey) : null,
                                    onSelected: (value) {
                                      if (value == context.tr('editKey')) {
                                        showAddCategoryDialogue(context, isEdit: true, category: categoryDetails);
                                      } else if (value == context.tr('deleteKey')) {
                                        showDeleteAlertDialog(context, category: categoryDetails);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      if (!categoryDetails.isDefault) ...[
                                        PopupMenuItem(
                                          value: context.tr('editKey'),
                                          child: Row(
                                            children: [
                                              Expanded(child: CustomTextView(text: context.tr('editKey'))),
                                              Icon(Icons.edit, size: 20.sp(context)),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: context.tr('deleteKey'),
                                          child: Row(
                                            children: [
                                              Expanded(child: CustomTextView(text: context.tr('deleteKey'))),

                                              Icon(Icons.delete, color: Colors.red, size: 20.sp(context)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),

                                  ReorderableDragStartListener(
                                    index: i,
                                    child: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },

                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            if (newIndex > oldIndex) newIndex -= 1;

                            final item = state.category.removeAt(oldIndex);
                            state.category.insert(newIndex, item);

                            context.read<GetCategoryCubit>().reorder(state.category);
                          });
                        },
                      );
                    }
                    if (state is GetCategoryFailure) {
                      return CustomTextView(
                        text: state.errorMessage,
                        softWrap: true,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                      );
                    }
                    return const CustomCircularProgressIndicator();
                  },
                ),
              ),
            ),

            SizedBox(height: context.height * 0.01),
          ],
        ),
      ),
    );
  }

  void showDeleteAlertDialog(BuildContext context, {Category? category}) {
    showGeneralDialog(
      context: context,
      barrierLabel: 'Delete',
      barrierColor: Colors.black.withValues(alpha: 0.3),
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
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              if (context.read<DeleteCategoryCubit>().state is! DeleteCategoryLoading) {
                Navigator.of(context).pop();
                return;
              }
            },
            child: AlertDialog(
              constraints: BoxConstraints(maxHeight: size.height * 0.45, maxWidth: size.width * 0.85),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

              title: CustomTextView(
                text: context.tr('deleteCategoryKey'),
                fontWeight: FontWeight.bold,
                fontSize: 20.sp(context),
              ),
              content: CustomTextView(text: context.tr('deleteCategoryMsgDialogueKey'), softWrap: true, maxLines: 3),
              actions: [
                BlocProvider(
                  create: (context) => DeleteCategoryCubit(),
                  child: BlocConsumer<DeleteCategoryCubit, DeleteCategoryState>(
                    listener: (context, state) {
                      if (state is DeleteCategorySuccess) {
                        Navigator.pop(context);
                        context.read<GetCategoryCubit>().deleteCategoryLocally(state.category);
                        context.read<GetTransactionCubit>().setNullCategoryValueInTransaction(state.category.id);
                        context.read<GetPartyCubit>().setNullCategoryValueInParty(state.category.id);
                        context.read<GetSoftDeletePartyTransactionCubit>().updateSoftDeletePartyTransactionAfterDeleteCategory(categoryId: state.category.id);
                        context.read<GetSoftDeleteTransactionsCubit>().updateSoftDeleteTransactionAfterDeleteCategory(categoryId: state.category.id);
                        context.read<GetRecurringTransactionCubit>().setNullCategoryValueInRecurringTransaction(state.category.id);
                      }

                      if (state is DeleteCategoryFailure) {
                        Navigator.pop(context);
                        UiUtils.showCustomSnackBar(context: context, errorMessage: state.errorMessage);
                      }
                    },
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: CustomRoundedButton(
                              onPressed: () {
                                if (state is! DeleteCategoryLoading) {
                                  Navigator.pop(context);
                                }
                              },
                              width: 1,
                              backgroundColor: Theme.of(context).primaryColor,
                              text: context.tr('deleteAccountCancelKey'),
                              borderRadius: BorderRadius.circular(8),
                              height: 40.sp(context),
                              textStyle: TextStyle(fontSize: 15.sp(context)),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: CustomRoundedButton(
                              onPressed: () {
                                context.read<DeleteCategoryCubit>().deleteCategory(category!);
                              },
                              width: 1,
                              backgroundColor: Theme.of(context).primaryColor,
                              text: context.tr('deleteAccountConfirmKey'),
                              borderRadius: BorderRadius.circular(8),
                              height: 40.sp(context),
                              textStyle: TextStyle(fontSize: 15.sp(context)),
                              isLoading: state is DeleteCategoryLoading,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
