import 'dart:ui';
import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/Category/Cubits/add_category_cubit.dart';
import 'package:expenseapp/features/Category/Cubits/update_category_cubit.dart';

import 'package:flutter/material.dart';

void showAddCategoryDialogue(BuildContext context, {bool isEdit = false, Category? category}) {
  showGeneralDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.3),
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: context.width * 0.5, maxWidth: context.isDesktop ? context.width * 0.6 : double.infinity),
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => AddCategoryCubit()),
              BlocProvider(create: (context) => UpdateCategoryCubit()),
            ],
            child: _AddCategoryWidget(isEdit: isEdit, category: category),
          ),
        ),
        // child: _AddCategoryWidget(isEdit: isEdit),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return Transform.scale(
        scale: Curves.easeOutBack.transform(animation.value),
        child: Opacity(opacity: animation.value, child: child),
      );
    },
  );
}

class _AddCategoryWidget extends StatefulWidget {
  const _AddCategoryWidget({required this.isEdit, super.key, this.category});
  final bool isEdit;
  final Category? category;

  @override
  State<_AddCategoryWidget> createState() => __AddCategoryWidgetState();
}

class __AddCategoryWidgetState extends State<_AddCategoryWidget> {
  final TextEditingController _nameController = TextEditingController();
  // CategoryType selectedType = CategoryType.EXPENSE;

  ValueNotifier<TransactionType> selectedType = ValueNotifier(TransactionType.EXPENSE);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.isEdit ? widget.category!.name : '';
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: context.isTablet ? MediaQuery.of(context).size.width * 0.45 : MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsetsDirectional.all(20),
        decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(16)),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextView(
                text: widget.isEdit ? context.tr('updateCategoryKey') : context.tr('addCategoryKey'),
                fontSize: 20.sp(context),
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),

              const SizedBox(height: 10),

              CustomTextFormField(
                controller: _nameController,
                hintText: context.tr('categoryNameKey'),
                validator: (value) => value == null || value.isEmpty ? context.tr('categoryNameKyReq') : null,
                hintTextSize: 17.sp(context),
              ),
              const SizedBox(height: 24),

              BlocConsumer<UpdateCategoryCubit, UpdateCategoryState>(
                listener: (context, updateCategoryState) {
                  if (updateCategoryState is UpdateCategorySuccess) {
                    Navigator.pop(context);
                    context.read<GetCategoryCubit>().updateCategoryLocally(updateCategoryState.category);
                  }
                  if (updateCategoryState is UpdateCategoryFailure) {
                    Navigator.pop(context);
                    UiUtils.showCustomSnackBar(context: context, errorMessage: updateCategoryState.errorMessage);
                  }
                },
                builder: (context, updateCategoryState) {
                  return BlocConsumer<AddCategoryCubit, AddCategoryState>(
                    listener: (context, addCategoryState) {
                      if (addCategoryState is AddCategorySuccess) {
                        Navigator.pop(context);

                        //   context.read<GetCategoryCubit>().getAllCategory();

                        context.read<GetCategoryCubit>().addCategoryLocally(addCategoryState.category);
                      }
                      if (addCategoryState is AddCategoryFailure) {
                        Navigator.pop(context);
                        UiUtils.showCustomSnackBar(context: context, errorMessage: addCategoryState.errorMessage);
                      }
                    },
                    builder: (context, addCategoryState) {
                      return Row(
                        children: [
                          Expanded(
                            child: CustomRoundedButton(
                              onPressed: () {
                                final categoryId = 'C'.withDateTimeMillisRandom();
                                if (_nameController.text.isEmpty) {
                                  UiUtils.showCustomSnackBar(context: context, errorMessage: context.tr('categoryNameKyReq'));
                                  return;
                                } else {
                                  if (widget.isEdit) {
                                    context.read<UpdateCategoryCubit>().updateCategory(Category(id: widget.category!.id, name: _nameController.text));
                                  } else {
                                    context.read<AddCategoryCubit>().addCategory([Category(id: categoryId, name: _nameController.text)]);
                                  }
                                }
                              },
                              width: 1,
                              backgroundColor: Theme.of(context).primaryColor,
                              text: widget.isEdit ? context.tr('update') : context.tr('addKey'),
                              borderRadius: BorderRadius.circular(8),
                              //showBorder: false,
                              height: 40.sp(context),
                              textStyle: TextStyle(fontSize: 18.sp(context)),
                              isLoading: widget.isEdit ? updateCategoryState is UpdateCategoryLoading : addCategoryState is AddCategoryLoading,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomRoundedButton(
                              onPressed: () {
                                if (widget.isEdit) {
                                  if (updateCategoryState is! UpdateCategoryLoading) {
                                    Navigator.pop(context);
                                  }
                                } else {
                                  if (addCategoryState is! AddCategoryLoading) {
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              width: 1,
                              backgroundColor: Theme.of(context).primaryColor,
                              text: context.tr('cancel'),
                              borderRadius: BorderRadius.circular(8),
                              height: 40.sp(context),
                              textStyle: TextStyle(
                                fontSize: 18.sp(context),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioButton({required TransactionType value, required String text}) {
    return Row(
      children: [
        Radio<TransactionType>(
          value: value,
          groupValue: selectedType.value,
          onChanged: (value) {
            selectedType.value = value!;
          },
        ),
        CustomTextView(text: text, fontSize: 20.sp(context), color: Colors.black),
      ],
    );
  }
}
